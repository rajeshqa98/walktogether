# Data Retention Policy

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** SRE Lead + Privacy Lead

## Overview

WalkTogether retains user data only as long as it serves a legitimate safety, audit, or operational purpose. This policy defines, for every category of data, how long we keep it and what we do when it expires. The policy is enforced by the `enforceRetentionRule()` function in `@/lib/phase25.ts` and is triggered via:

* `POST /api/admin/retention` (admin manual run, with `runMode: scheduled | manual | dry_run`)
* A scheduled job (cron / GitHub Action / Vercel Cron) that runs daily at 03:00 UTC

Every enforcement run writes a `RetentionAuditLog` row documenting the rule, scope, rows inspected, rows deleted, rows anonymized, cutoff date, status, and any errors.

## Categories of data

### 1. Safety-critical — preserved indefinitely

| Rule name | Applies to | Retention |
|---|---|---|
| `safety_events` | SafetyEvent table | Indefinite |
| `reports` | Report table | Indefinite |
| `appeals` | Appeal + AppealTimeline tables | Indefinite |
| `audit_logs` | AuditLog + AdminAccessLog tables | Indefinite |
| `moderation_decisions` | Message.moderationStatus + GroupWalkMessage.moderationStatus | Indefinite |
| `trust_score_history` | TrustScoreHistory table | Indefinite |
| `privacy_requests` | PrivacyRequest + AccountDeletionRequest tables | Indefinite |

**Rationale:** Safety events (SOS, safety share), reports, appeals, audit logs, moderation decisions, trust score history, and privacy request records must be preserved indefinitely for incident review, repeat-offender pattern detection, governance audit, and legal defense. Deleting any of these would compromise our ability to investigate incidents, detect abuse patterns, or defend against legal challenges.

**Storage cost:** These tables grow slowly (safety events are rare, reports are infrequent, audit logs grow ~100/day). Even after 10 years of operation, the total storage is well under 10GB.

### 2. Operational — expired after defined period

| Rule name | Applies to | Retention | Action |
|---|---|---|---|
| `otp_attempts` | OtpAttempt table | 30 days | delete |
| `live_presence` | LivePresence rows where `expiresAt < now` | 1 day | delete |
| `location_pings` | WalkSession.routeSummary on sessions older than 7 days | 7 days | anonymize (set to null) |
| `push_subscriptions` | PushSubscription rows with stale `updatedAt` | 90 days | delete |
| `abandoned_sessions` | WalkSession in `active` state with no heartbeat for >24h | 1 day | anonymize (mark as ended) |
| `invite_tokens` | InviteLink with `visitCount=0` older than 90 days | 90 days | delete |
| `temp_logs` | AnalyticsEvent rows | 90 days | delete |
| `data_export_jobs` | DataExportJob rows past their 7-day download window | 7 days | anonymize (clear fileUrl, mark expired) |

**Rationale for each:**

* **OTP attempts (30 days):** OTP records are needed for brute-force detection and audit, but anything older than 30 days has no investigative value. Deleting them keeps the OtpAttempt table small.
* **Live presence (1 day):** LivePresence is real-time location data. Keeping it past expiry serves no purpose and creates privacy risk. Deleted as soon as `expiresAt` passes.
* **Location pings (7 days):** WalkSession.routeSummary contains the route of a completed walk. We keep it for 7 days in case of post-walk incident report, then anonymize. After 7 days, the safety value diminishes and the privacy cost of retention grows.
* **Push subscriptions (90 days):** Push endpoints that haven't been updated in 90 days are likely abandoned devices. Deleting them keeps the push subscription table clean and avoids sending pushes to dead endpoints.
* **Abandoned sessions (1 day):** Walk sessions stuck in `active` state for over 24 hours are almost certainly abandoned (user closed app without ending walk). We mark them as `ended` to free up the safety state, but preserve the row for audit.
* **Invite tokens (90 days):** Invite links that have never been visited and are older than 90 days are dead. Deleting them keeps the InviteLink table clean.
* **Temp logs (90 days):** AnalyticsEvent rows are aggregated into DailyMetricSnapshot daily, then the raw events can be deleted after 90 days. The aggregated data is preserved indefinitely.
* **Data export jobs (7 days):** User data export files have a 7-day download window. After that, the file URL is cleared and the job is marked expired. The job record itself is preserved indefinitely (it's an audit log of what was exported and when).

## Location privacy principles

WalkTogether minimizes location data by design:

1. **No continuous location tracking.** We do not track user location in the background. Live presence is only updated when the user has the app open and has explicitly shared location.

2. **No exact coordinates in normal API responses.** The nearby walker API returns coarse distance (e.g. "500m away"), not exact latitude/longitude. Exact coordinates are only used server-side for distance computation.

3. **No exact coordinates in admin exports.** Admin exports of user data exclude latitude/longitude fields. Admins can see coarse location (city, neighborhood) but not exact coordinates.

4. **Live presence expires automatically.** LivePresence rows have an `expiresAt` field, set to 1 hour by default. The retention rule deletes expired rows daily.

5. **Historical location is anonymized.** WalkSession.routeSummary (which may contain route data) is anonymized 7 days after the walk ends.

6. **Logs never contain exact coordinates.** The logger in `@/lib/phase25.ts` has a `redactPayload()` function that redacts `lat` and `lng` keys from any log payload. This prevents accidental coordinate leakage in structured logs.

7. **Location cleanup is a privacy request type.** Users can request "location_data_cleanup" via the privacy request workflow. This immediately deletes their LivePresence and anonymizes any WalkSession.routeSummary on their sessions.

## Enforcement

The `enforceRetentionRule(ruleName, runMode)` function in `@/lib/phase25.ts`:

1. Looks up the rule definition.
2. If the action is `preserve`, returns immediately with status `ok`.
3. Computes the cutoff date (`now - retentionDays`).
4. For `dry_run` mode: counts matching rows without modifying anything.
5. For `scheduled` and `manual` modes: deletes or anonymizes matching rows.
6. Returns a result object with `rowsInspected`, `rowsDeleted`, `rowsAnonymized`, `cutoffDate`, `status`.
7. The caller (`POST /api/admin/retention` or `runAllRetention()`) writes a `RetentionAuditLog` row.

## Audit trail

Every retention run is logged in `RetentionAuditLog`:

| Field | Description |
|---|---|
| `ruleName` | Which rule was enforced |
| `scope` | The `appliesTo` description from the rule |
| `rowsInspected` | How many rows matched the cutoff |
| `rowsDeleted` | How many rows were deleted |
| `rowsAnonymized` | How many rows were anonymized |
| `cutoffDate` | The cutoff date used |
| `status` | `ok` / `partial` / `failed` |
| `errorDetails` | Error message if status is not `ok` |
| `runMode` | `scheduled` / `manual` / `dry_run` |
| `startedAt` | When the run started |
| `completedAt` | When the run completed |

Admins can view the recent audit log at `/admin/retention`.

## Manual override

Admins can:

1. **Dry-run any rule** — see how many rows would be affected without modifying data.
2. **Run a single rule** — useful for testing or for cleaning up a specific issue.
3. **Run all rules** — useful for periodic cleanup outside the scheduled window.

All manual runs are logged with `runMode: manual` so they can be distinguished from scheduled runs in the audit log.

## Review cadence

This policy is reviewed quarterly by the SRE Lead + Privacy Lead. The review considers:

* Are the retention periods still appropriate?
* Are there new data categories that need a rule?
* Are there rules that can be tightened (shorter retention) or loosened (longer retention)?
* Are there any rules that are consistently failing?

Changes to `RETENTION_RULES` are shipped in the next release and documented in the release notes.
