# Service-Level Objectives

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** SRE Lead

## Overview

WalkTogether defines SLOs for every core system. Each SLO has a target, a measurement window, and a severity (critical / non-critical). When a critical SLO breaches, a P1 incident is opened. SLOs are tracked in the `SloMetric` table (one row per metric per hour) and surfaced on the `/admin/slo` dashboard.

SLOs are evaluated by the `evaluateSlo()` function in `@/lib/phase25.ts`. The function returns `meeting`, `near_breach`, `breached`, or `unknown`. The thresholds are:

* **Meeting** — actual is at or better than the target (for success rate: `actual >= target`; for latency: `actual <= target * 0.8`).
* **Near breach** — actual is within 1 percentage point of the target (for success rate) or between 80% and 100% of the latency target.
* **Breached** — actual is worse than the near-breach band.
* **Unknown** — no metric data in the current window.

## Defined SLOs

| Metric name | Label | Category | Target | Critical | Description |
|---|---|---|---|---|---|
| `sos_creation_success` | SOS event creation success | success_rate | 99.9% | Yes | SOS events must succeed — failure means a user in danger cannot alert us. |
| `report_block_success` | Report / block success | success_rate | 99.9% | Yes | Report and block actions must succeed — failure undermines user safety. |
| `auth_availability` | Auth availability | availability | 99%+ | Yes | Login and token refresh must be available — outages lock users out of the app. |
| `otp_success_rate` | OTP success rate | success_rate | 98%+ | No | OTP delivery + verification success — below target means users cannot sign up or log in. |
| `nearby_p95_latency_ms` | Nearby search p95 latency | latency | p95 < 1500ms | No | Nearby walker search p95 latency — slow responses make the app feel broken. |
| `chat_send_success` | Chat send success | success_rate | 99%+ | No | Chat message send success — failures break the user experience and may trigger safety concerns. |
| `walk_request_creation_success` | Walk request creation success | success_rate | 99.5%+ | No | Walk requests must be created — failure prevents users from connecting. |
| `admin_action_success` | Admin action success | operational | 99%+ | No | Admin dashboard + action APIs must be available — outage blocks safety review. |
| `push_delivery_success` | Push delivery success | success_rate | 95%+ | No | Push notifications must reach devices — failures delay safety alerts. |
| `socket_reconnect_success` | Socket reconnect success | operational | 95%+ | No | Socket reconnection after disconnect — failures break realtime chat and presence. |

## Rationale for each target

### SOS / report / block — 99.9% (critical)

SOS, report, and block are the user's safety valve. If a user in danger cannot trigger SOS, or a user being harassed cannot block, the product has failed them. We allow 0.1% failure (1 in 1,000) because absolute 100% is not achievable in any distributed system, but we treat any breach as a P1 incident requiring immediate response.

The 99.9% target allows for approximately 43 minutes of downtime per month. This is generous enough to allow for legitimate maintenance, but tight enough that any outage is felt.

### Auth availability — 99%+ (critical)

Auth is the gateway to the entire app. If auth is down, users cannot log in, cannot refresh tokens, and cannot access their account. We target 99%+ (allowing ~7 hours of downtime per month) because the auth flow is simpler than SOS and has more failure modes (NextAuth, OTP provider, database). A critical SLO breach here means users are locked out.

### OTP success rate — 98%+ (non-critical)

OTP delivery depends on third-party SMS providers (Twilio, MSG91, etc.) which have their own outages and rate limits. We target 98%+ because (a) SMS providers typically deliver 95-99% of messages within 30 seconds, (b) users can retry, and (c) a brief OTP outage does not put users in physical danger the way an SOS failure does.

When OTP success drops below 80%, the OTP provider health check on the reliability dashboard flips to `degraded`, and an incident is opened.

### Nearby search p95 latency — under 1500ms (non-critical)

Nearby walker search is the most common API call. If it's slow, the app feels broken. We target p95 under 1500ms because (a) PostGIS geospatial queries are fast on indexed columns, (b) the in-memory cache absorbs most requests, (c) anything over 1.5 seconds feels broken to a user holding their phone.

The p95 (not p50) is the target because we want to catch the slowest 5% of requests, not just the median.

### Chat send success — 99%+ (non-critical)

Chat is core to the user experience but not safety-critical. A failed chat send is annoying but not dangerous — the user can retry, or fall back to in-person communication during the walk. We target 99%+ because higher availability is achievable but the marginal cost exceeds the marginal benefit.

### Walk request creation — 99.5%+ (non-critical)

Walk requests are how users connect. A failed walk request is a missed connection but not a safety issue. We target 99.5% (between chat and auth) because the write path is simpler than chat (no realtime fan-out) but still depends on the database.

### Admin action success — 99%+ (non-critical)

Admin actions must succeed for safety review to function. However, a brief admin outage does not directly endanger users (safety events can still be created and queued). We target 99%+ because admin outages are recoverable and don't compromise user safety in the moment.

### Push delivery success — 95%+ (non-critical)

Push delivery depends on FCM (Android), APNS (iOS), and Web Push (browser). Each has its own failure modes (expired tokens, do-not-disturb, background restrictions). 95% is the realistic ceiling for cross-provider delivery. Safety push (SOS alerts) bypass this SLO — they are retried with exponential backoff and fall back to SMS if configured.

### Socket reconnect success — 95%+ (non-critical)

Socket reconnection after a network blip is important for chat and presence continuity, but not safety-critical. A failed reconnection just means the user sees a "reconnecting..." indicator; they can refresh the page. We target 95% because the socket.io client library handles most reconnection cases automatically.

## Measurement methodology

Each SLO metric is recorded by the `recordSloMetric()` function in `@/lib/phase25.ts`. The function is called from API middleware and route handlers. Each call:

1. Computes the current hour bucket (UTC).
2. Upserts a `SloMetric` row for `(metricName, windowStart)`.
3. Increments `totalRequests`, `successCount` or `failureCount`.
4. Recomputes `errorRate` and `sloStatus`.
5. Updates `p50LatencyMs`, `p95LatencyMs`, `p99LatencyMs` if applicable.

For latency SLOs, the function takes the maximum of the existing p95 and the new observation. This is a rough approximation of true p95 tracking; a proper histogram would require a separate library (e.g. hdrhistogram). The current approach is sufficient for incident detection.

## Alerting

When an SLO breaches:

1. The `/admin/slo` dashboard shows the SLO with a red `breached` badge.
2. The `/admin/reliability` dashboard surfaces the breach in the SLO summary panel.
3. The worst-performing SLO is highlighted at the top of the SLO dashboard.
4. If the SLO is critical (`sos_creation_success`, `report_block_success`, `auth_availability`), an incident should be auto-created by the alerting system (Phase 25 wires the data; the auto-creation is a future enhancement).

## SLO review cadence

SLOs are reviewed quarterly by the SRE Lead + Product Lead. The review considers:

* Are the targets still appropriate for the user base?
* Are we consistently meeting them? If so, should we tighten them?
* Are we consistently breaching them? If so, what infrastructure investment is needed?
* Are there new metrics we should track (e.g. new product features)?

The review is documented in the SRE wiki and updates to `SLO_DEFINITIONS` are shipped in the next release.
