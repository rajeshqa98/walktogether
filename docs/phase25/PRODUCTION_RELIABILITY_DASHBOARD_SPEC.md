# Production Reliability Dashboard Spec

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** SRE Lead + Product Lead

## Overview

The Production Reliability Dashboard gives WalkTogether admins a single, real-time view of every production system that keeps the app safe and usable. It surfaces per-system health, key operational metrics, SLO summaries, and active incidents in one screen, and writes a periodic `ReliabilitySnapshot` to the database so historical trends are queryable.

The dashboard is reachable at `/admin/reliability` and the underlying data is served by `GET /api/admin/reliability`. Both are admin-only. The dashboard auto-refreshes every 30 seconds so an on-call admin can leave it open on a side monitor.

## Systems tracked

| System | Source of truth | Healthy when |
|---|---|---|
| app | Next.js process | Responding to HTTP requests |
| database | Prisma client | `db.user.count({ take: 1 })` succeeds |
| redis | Redis client (`@/lib/redis`) | `isRedisConnected()` returns true |
| socket | mini-services/socket-server | Process registered + Caddy route healthy |
| push | PushSubscription table + VAPID/FCM/APNS | Active subscriptions > 0, no recent delivery surge |
| otp_provider | OtpAttempt table | Failure rate < 50% in last hour |
| service_worker | `public/sw.js` | File exists + bypasses `/api/*` |

If any system reports `down`, the overall status becomes `down`. If any reports `degraded`, the overall becomes `degraded`. If no systems are degraded but there are active incidents, the overall becomes `needs_attention`.

## Key metrics (1-hour window)

The dashboard shows the following metrics, computed live from the database or from API middleware counters:

* **API error rate** — fraction of API requests that returned 5xx in the last 1h.
* **Average API latency** — mean response time across all API routes in the last 1h.
* **Failed login rate** — fraction of login attempts that failed in the last 1h.
* **Failed OTP rate** — fraction of OTP verify attempts that failed or expired in the last 1h.
* **Notification delivery failures** — number of push deliveries that failed in the last 1h.
* **Realtime disconnect rate** — fraction of socket connections that disconnected unexpectedly in the last 1h.

Thresholds for healthy vs degraded are codified in the dashboard component (`MetricCard` status logic).

## SLO summary panel

The dashboard surfaces a compact SLO summary pulled from the SLO API. For each SLO it shows the label, target (e.g. `99.9%`), the current 24h actual, total request volume, failure count, and current status (`meeting` / `near_breach` / `breached` / `unknown`). Critical SLOs (SOS, report, auth) are badged so admins can immediately see which breaches trigger a P1 incident.

## Active incidents panel

Every `IncidentReport` with status `active` or `mitigated` is listed at the bottom of the dashboard. Each card shows the title, incident type, severity badge, and creation timestamp. Clicking through goes to `/admin/incidents` for the full playbook.

## Recent snapshots trend

The dashboard lists the last 24 `ReliabilitySnapshot` rows so an admin can see whether the system has been consistently healthy or whether status has degraded over time. Each row shows the timestamp, OTP failure rate, active incident count, and overall status badge.

## Snapshot persistence

`POST /api/admin/reliability` triggers `saveReliabilitySnapshot()` in `@/lib/phase25.ts`, which:

1. Runs `performHealthCheck()` to collect live system status.
2. Computes the aggregate metrics from the database.
3. Writes a single `ReliabilitySnapshot` row with per-system status + 1h metrics.

In production this is wired to a scheduled job (cron / GitHub Action / Vercel Cron) that runs every 5 minutes, giving a continuous historical record. In development, admins can manually trigger a snapshot from the dashboard's "Save snapshot" button.

## Failure modes the dashboard must catch

The dashboard is the first line of defense for production incidents. It must surface:

1. **Database outage** — `database` system shows `down`, overall becomes `down`, an incident is auto-created if alerting is wired.
2. **OTP provider outage** — `otp_provider` system shows `degraded`, OTP failure rate exceeds threshold.
3. **Push delivery outage** — `push` system shows `degraded`, notification delivery failure count spikes.
4. **Socket outage** — `socket` system shows `degraded`, realtime disconnect rate spikes.
5. **SLO breach** — SLO summary shows `breached` status, worst-performing SLO is highlighted.

When any of these occurs, the on-call admin should immediately consult the relevant incident playbook in `/admin/incidents`.

## Acceptance criteria

* Dashboard loads in under 2 seconds with all panels populated.
* Auto-refresh every 30 seconds works without losing scroll position.
* Save snapshot button writes a `ReliabilitySnapshot` row.
* SLO summary panel reflects the same data as `/admin/slo`.
* Active incidents panel shows only `active` and `mitigated` incidents.
* Dashboard is admin-only (401 for unauthenticated, 403 for non-admin).
* No console errors during page load or refresh.
