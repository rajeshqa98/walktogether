# Observability and Logging Guide

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** SRE Lead

## Overview

WalkTogether uses structured JSON logging for all production events. Logs are the primary observability surface — they feed the reliability dashboard, the SLO tracking system, the incident response process, and the audit trail. This guide covers what we log, what we don't log, log redaction rules, log levels, and how logs are consumed.

The logging module is at `src/lib/logger.ts`. Phase 25 adds the `redactPayload()` function in `src/lib/phase25.ts` for sensitive-field redaction.

## What we log

### Auth events

| Event | Level | When |
|---|---|---|
| `auth_success` | info | Successful login |
| `auth_failure` | warn | Failed login (wrong password, invalid token) |
| `auth_token_refreshed` | info | NextAuth token refresh |
| `auth_logout` | info | User logs out |

### OTP events

| Event | Level | When |
|---|---|---|
| `otp_request_sent` | info | OTP code sent to user |
| `otp_request_blocked` | warn | OTP request rate-limited |
| `otp_verify_success` | info | OTP verified successfully |
| `otp_verify_failed` | warn | OTP verification failed (wrong code) |
| `otp_expired` | info | OTP expired without verification |

### Rate limit events

| Event | Level | When |
|---|---|---|
| `rate_limit_triggered` | warn | Rate limit hit on any endpoint |
| `rate_limit_blocked` | warn | Request blocked by rate limiter |

### Safety events

| Event | Level | When |
|---|---|---|
| `sos_triggered` | error (high priority) | SOS button pressed |
| `safety_share_activated` | info | Safety share turned on |
| `safety_share_deactivated` | info | Safety share turned off |
| `report_filed` | info | User files a report |
| `block_initiated` | info | User blocks another user |

### Admin actions

| Event | Level | When |
|---|---|---|
| `admin_action` | info | Any admin action (warn, suspend, ban, etc.) |
| `admin_login_success` | info | Admin logs in |
| `admin_login_failed` | warn | Admin login fails |
| `admin_deactivated` | error | Admin account deactivated |
| `admin_reactivated` | warn | Admin account reactivated |
| `high_risk_action` | warn | High-risk admin action (ban, delete, role change) |

### Appeal actions

| Event | Level | When |
|---|---|---|
| `appeal_submitted` | info | User submits an appeal |
| `appeal_review_started` | info | Admin starts reviewing an appeal |
| `appeal_approved` | info | Appeal approved |
| `appeal_rejected` | info | Appeal rejected |
| `appeal_closed` | info | Appeal closed |

### Privacy requests

| Event | Level | When |
|---|---|---|
| `privacy_request_submitted` | info | User submits privacy request |
| `privacy_request_cancelled` | info | User cancels privacy request |
| `privacy_request_complete` | info | Admin completes privacy request |
| `privacy_request_reject` | warn | Admin rejects privacy request |
| `account_deletion_started` | info | Account deletion grace period started |
| `account_deletion_cancelled` | info | Account deletion cancelled |
| `account_deletion_finalized` | info | Account deletion finalized (personal data anonymized) |

### Trust score changes

| Event | Level | When |
|---|---|---|
| `trust_score_changed` | info | Trust score increased or decreased |
| `trust_score_locked` | info | Trust score locked (user banned) |

### Safety automation

| Event | Level | When |
|---|---|---|
| `safety_signal_detected` | warn | Automated safety signal triggered |
| `safety_task_created` | info | Safety task created from signal |
| `safety_task_assigned` | info | Safety task assigned to admin |
| `safety_task_resolved` | info | Safety task resolved |

### Push delivery

| Event | Level | When |
|---|---|---|
| `push_send_success` | info | Push delivered successfully |
| `push_send_failed` | warn | Push delivery failed |
| `push_subscription_expired` | info | Push subscription marked expired |

### Socket events

| Event | Level | When |
|---|---|---|
| `socket_connect` | info | Client connects to socket |
| `socket_disconnect` | info | Client disconnects |
| `socket_error` | error | Socket error |
| `socket_reconnect_success` | info | Client reconnected after disconnect |
| `socket_reconnect_failed` | warn | Client failed to reconnect |

### Database events

| Event | Level | When |
|---|---|---|
| `db_query_slow` | warn | DB query took > 1 second |
| `db_error` | error | DB query failed |
| `db_connection_lost` | error | DB connection lost |
| `db_connection_restored` | info | DB connection restored |

### Retention events

| Event | Level | When |
|---|---|---|
| `retention_rule_enforced` | info | Retention rule ran successfully |
| `retention_rule_failed` | error | Retention rule failed |

## What we do NOT log

### Full OTP codes

Never log the actual OTP code, even in development. The OTP code is a temporary secret; logging it would allow anyone with log access to impersonate the user during the OTP validity window.

The logger redacts any field named `otp`, `code`, or `otpCode` to `<redacted>`.

### Exact coordinates

Never log exact latitude/longitude of a user. Coordinates are highly sensitive — they reveal where a user lives, works, or walks. Even a single coordinate can be used for stalking.

The logger redacts any field named `lat`, `lng`, `latitude`, or `longitude` to `<redacted>`.

### Private chat bodies

Never log the body of a private chat message in normal logs. Chat bodies may contain deeply personal information (health, relationships, finances). Logs are operational, not surveillance.

Exceptions:

* A flagged message is logged with its body for moderation review — but only admin can access these logs.
* An SOS message is logged with its body for safety review — but only admin can access these logs.

### Full phone numbers

Never log a user's full phone number in normal logs. Phone numbers are PII and can be used for SIM-swap attacks or social engineering.

The logger partially redacts phone numbers: `+919876543210` becomes `+91*****4321`. The country code and last 4 digits are preserved for debugging; the middle is redacted.

### Full email addresses

Same logic as phone numbers. The logger partially redacts emails: `alice@example.com` becomes `a***@example.com`. The first character of the local part and the full domain are preserved for debugging.

### Push subscription endpoints

Never log the push endpoint URL, p256dh public key, or auth secret. These are cryptographic material that could be used to send unauthorized push notifications.

The logger redacts any field named `endpoint`, `p256dh`, or `auth` to `<redacted>`.

### Passwords

Never log passwords, password hashes, or password reset tokens. The logger redacts any field named `password`, `passwordHash`, or `resetToken` to `<redacted>`.

## Log levels

| Level | When to use | Color (dev) |
|---|---|---|
| `info` | Normal operation — most events | Cyan |
| `warn` | Something unusual but not broken | Yellow |
| `error` | Something is broken, needs attention | Red |

The `log()` function in `src/lib/logger.ts` defaults to `info` level. Use `logWarn()` for warnings and `logError()` for errors. Errors include a stack trace.

## Log format

### Development

In development, logs are pretty-printed to the console with colors:

```
[2026-07-06T12:34:56.789Z] auth_success {"userId":"clxxx...","ip":"127.0.0.1"}
```

### Production

In production, logs are JSON to stdout for log aggregation (CloudWatch, Datadog, Loki, etc.):

```json
{"timestamp":"2026-07-06T12:34:56.789Z","level":"info","event":"auth_success","userId":"clxxx...","ip":"127.0.0.1"}
```

## Redaction implementation

The `redactPayload()` function in `src/lib/phase25.ts` is the single source of truth for log redaction. It:

1. Iterates over every key in the log payload.
2. For each key (case-insensitive):
   * If the key is in `PARTIAL_REDACT_KEYS` (`phone`, `email`): partially redact the value.
   * If the key is in `REDACT_KEYS` (`otp`, `code`, `password`, `token`, `secret`, `endpoint`, `lat`, `lng`): fully redact to `<redacted>`.
3. Recursively redacts nested objects.

The function is called by `log()` before the payload is serialized. This ensures no sensitive data ever reaches stdout or the log aggregator.

## Log consumption

Logs are consumed by:

1. **Reliability dashboard** — `/admin/reliability` reads from the database (ReliabilitySnapshot, SloMetric tables) which are populated from log events.
2. **SLO tracking** — `recordSloMetric()` in `@/lib/phase25.ts` is called from API middleware, derived from log events.
3. **Incident response** — Admins query logs during incident investigation.
4. **Audit trail** — `AuditLog` and `AdminAccessLog` tables persist admin actions indefinitely.
5. **Compliance** — DPDP/GDPR auditors may request log excerpts.

## Log retention

* **Production logs:** 30 days hot (searchable), 1 year cold (archived).
* **Audit logs (AuditLog table):** Indefinite (per data retention policy).
* **Admin access logs (AdminAccessLog table):** Indefinite (per data retention policy).

## Acceptance criteria

* Every API route logs at least one event (request received + response sent).
* Every admin action is logged in `AuditLog`.
* Every admin access event is logged in `AdminAccessLog`.
* OTP codes are never logged in plaintext.
* Exact coordinates are never logged.
* Phone numbers are partially redacted.
* Email addresses are partially redacted.
* Push subscription endpoints are never logged.
* Passwords are never logged.
* Logs are JSON-formatted in production.
* Logs are pretty-printed in development.
* `redactPayload()` is called on every log entry.
