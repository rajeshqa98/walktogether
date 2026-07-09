# Incident Response Playbooks

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** SRE Lead + Product Lead

## Overview

WalkTogether maintains 12 incident response playbooks covering every major production failure mode. Each playbook defines severity, detection, immediate actions, user communication, admin actions, rollback steps, and prevention measures. Playbooks are accessible to admins at `/admin/incidents` and are referenced by the incident creation flow.

When an incident is detected (manually or by alerting), an admin creates an `IncidentReport` row that pre-populates the relevant playbook's immediate actions, rollback steps, and user communication template. The admin then works through the playbook, updating the incident status as it progresses: `active` → `mitigated` → `resolved` → `postmortem`.

## Playbook structure

Every playbook contains:

| Field | Description |
|---|---|
| `incidentType` | Machine-readable key (e.g. `otp_outage`) |
| `label` | Human-readable label (e.g. "OTP provider outage") |
| `severity` | `low` / `medium` / `high` / `critical` |
| `detection` | How the incident is detected |
| `immediateActions` | Ordered list of actions to take in the first 15 minutes |
| `userCommunication` | Template for what to tell users (in-app banner, push, status page) |
| `adminActions` | Ordered list of actions for the next 1-4 hours |
| `rollback` | Steps to revert once the incident is resolved |
| `prevention` | Long-term measures to prevent recurrence |

## Severity levels

| Severity | Meaning | Response time | Escalation |
|---|---|---|---|
| `critical` | User safety is at risk or core functionality is down | Immediate, 24/7 | Page on-call SRE + Product Lead + Safety Lead |
| `high` | Major functionality degraded, no immediate safety risk | 1 hour | Page on-call SRE |
| `medium` | Minor functionality degraded, workaround exists | 4 hours | Notify on-call SRE during business hours |
| `low` | Cosmetic issue, no user impact | Next business day | File ticket |

## The 12 playbooks

### 1. OTP provider outage (`otp_outage`)

**Severity:** High
**Detection:** OTP success rate drops below 80% in SLO dashboard, or users report not receiving OTP codes.

**Immediate actions:**
1. Verify OTP provider status page (Twilio, MSG91, etc.).
2. Switch to backup OTP provider if configured.
3. Temporarily extend OTP expiry window from 5min to 15min.
4. Notify all admins in #incidents channel.

**User communication:** In-app banner: "OTP delivery is delayed. Tap resend or try again in a few minutes."

**Rollback:**
1. Revert OTP provider switch once primary recovers.
2. Reset OTP expiry to 5min.
3. Clear OTP backlog queue.

**Prevention:**
1. Configure multi-provider OTP failover.
2. Add synthetic OTP test every 5 minutes.
3. Alert when p95 OTP delivery latency > 30s.

### 2. Database outage (`database_outage`)

**Severity:** Critical
**Detection:** DB health check fails, API returns 500s on all read/write endpoints.

**Immediate actions:**
1. Fail over to read replica if available.
2. Switch app to read-only mode via feature flag.
3. Post status page incident.
4. Notify on-call engineer + product lead.

**User communication:** Status page + in-app banner: "WalkTogether is experiencing issues. Walks in progress are safe; new requests may fail."

**Admin actions:**
1. Preserve all safety events to in-memory buffer if DB unreachable.
2. Disable non-critical write APIs (profile edits, preferences).
3. Keep SOS endpoint active via Redis-backed fallback.

**Rollback:**
1. Verify DB integrity after recovery.
2. Replay buffered writes in order.
3. Confirm no data loss for safety events.

**Prevention:**
1. Daily DB backups + monthly restore drill.
2. Read replica in different region.
3. Test failover quarterly.

### 3. Redis outage (`redis_outage`)

**Severity:** Medium
**Detection:** Redis health check reports 'down' on reliability dashboard.

**Immediate actions:**
1. Verify Redis process status.
2. App should auto-fall back to in-memory cache.
3. Check socket.io adapter (uses Redis for multi-instance).

**User communication:** None required unless realtime chat stops working — then: "Real-time chat may be briefly unavailable."

**Rollback:**
1. Restore Redis from RDB snapshot if data loss.
2. Rebuild cache by warming common keys.

**Prevention:**
1. Redis persistence (AOF + RDB).
2. Auto-restart on crash.
3. Alert when Redis memory > 80%.

### 4. Socket.io outage (`socket_outage`)

**Severity:** High
**Detection:** Realtime disconnect rate > 50% on reliability dashboard, or chat messages stop arriving.

**Immediate actions:**
1. Verify mini-service socket-server is running.
2. Check Caddyfile proxy config for ws upgrade.
3. Restart socket service if hung.
4. Notify users via push: "Chat may be delayed".

**User communication:** Push notification: "Real-time chat is experiencing issues. Messages may be delayed."

**Admin actions:**
1. Monitor reconnection success rate.
2. If prolonged, switch chat to HTTP polling fallback.
3. Preserve undelivered messages for later delivery.

**Rollback:**
1. Verify all rooms re-populated after restart.
2. Test chat end-to-end post-recovery.

**Prevention:**
1. Socket health check every 30s.
2. Auto-restart on 3 consecutive failures.
3. Multi-instance socket adapter via Redis.

### 5. Push notification outage (`push_outage`)

**Severity:** Medium
**Detection:** Push delivery success rate < 70% in SLO dashboard.

**Immediate actions:**
1. Verify VAPID keys + FCM/APNS credentials.
2. Check push provider status pages (FCM, APNS).
3. Retry failed pushes with exponential backoff.

**User communication:** None required unless safety alerts affected — then: "Safety push notifications may be delayed."

**Admin actions:**
1. Manually send safety-critical pushes via SMS fallback if configured.
2. Quarantine failing push subscriptions (mark for cleanup).
3. Monitor recovery rate.

**Rollback:**
1. Re-enable retry queue.
2. Clean up expired push subscriptions via retention rule.

**Prevention:**
1. Daily push subscription health audit.
2. Multi-provider push fallback (FCM + APNS + Web Push).
3. Alert when push failure rate > 5% for 15min.

### 6. SOS / report creation failure (`sos_report_failure`)

**Severity:** Critical
**Detection:** SOS creation success SLO < 99.9% or user reports of failed SOS attempts.

**Immediate actions:**
1. Verify SOS API endpoint health.
2. Check DB write capacity.
3. If DB down, fallback to Redis-backed SOS log.
4. Page on-call admin immediately.

**User communication:** If user-visible: "SOS failed to send. Call local emergency number [country-specific]. Tap retry."

**Admin actions:**
1. Manually contact user if SOS attempt detected in logs.
2. Preserve any partial SOS records.
3. Notify safety lead + product lead.

**Rollback:**
1. Verify SOS endpoint restored.
2. Backfill any buffered SOS records to DB.
3. Confirm safety event review queue intact.

**Prevention:**
1. SOS endpoint health check every 30s.
2. Multi-region failover for SOS API.
3. Quarterly SOS drill with synthetic test.

### 7. Location privacy bug (`location_privacy_bug`)

**Severity:** High
**Detection:** User reports exact coordinates visible, or admin export contains unexpected location data.

**Immediate actions:**
1. Identify the leaking API endpoint or export path.
2. Disable the affected endpoint via feature flag.
3. Audit recent admin exports for coordinate leakage.
4. Notify privacy lead + DPO.

**User communication:** Direct outreach to affected users: "We identified a location data issue and have fixed it. Your safety is our priority."

**Admin actions:**
1. Patch the leak (round coordinates, remove from exports).
2. Run regression tests for location redaction.
3. Document the bug + fix in postmortem.

**Rollback:**
1. Re-enable endpoint after fix verified.
2. Add automated test for location redaction in CI.

**Prevention:**
1. CI test: every API response shape must not contain lat/lng fields.
2. Quarterly security review of all admin export endpoints.
3. Coordinate redaction unit tests.

### 8. Abusive user incident (`abusive_user_incident`)

**Severity:** High
**Detection:** Surge in user reports against a single user, or safety signal escalation.

**Immediate actions:**
1. Review reported user's recent activity.
2. Apply temporary suspension pending review (no auto-ban).
3. Notify safety queue admin.
4. Preserve all chat + safety event evidence.

**User communication:** To reporter: "Thank you for your report. We are reviewing it now." No notification to reported user.

**Admin actions:**
1. Review chat logs (admin-only).
2. Apply final action: warn / suspend / ban (with audit log + reason).
3. If ban, freeze trust score (trustLocked=true).

**Rollback:**
1. If false positive: restore user, +10 trust score, log apology.
2. Notify user via appeal workflow.

**Prevention:**
1. Automated safety signals (Phase 19) catch patterns early.
2. Human review required before any ban.
3. Appeal workflow always available.

### 9. Admin account compromise (`admin_account_compromise`)

**Severity:** Critical
**Detection:** Anomalous admin actions, login from unfamiliar IP, or external report.

**Immediate actions:**
1. Immediately deactivate the admin account.
2. Revoke all active sessions for that admin.
3. Review all admin actions in last 24h by that account.
4. Notify security lead + product lead.

**User communication:** None unless user data was affected — then direct outreach per privacy playbook.

**Admin actions:**
1. Audit all admin actions by compromised account.
2. Reverse any unauthorized actions (bans, suspensions).
3. Force password reset for all admins.

**Rollback:**
1. Re-enable admin only after security review.
2. Require 2FA re-enrollment.
3. Monitor for 30 days post-incident.

**Prevention:**
1. 2FA mandatory for all admins.
2. Alert on login from new IP.
3. Quarterly admin access review (Phase 25).

### 10. Data leak suspicion (`data_leak_suspicion`)

**Severity:** Critical
**Detection:** External security report, unusual API access patterns, or admin audit log anomalies.

**Immediate actions:**
1. Identify scope of suspected leak (which users, which data).
2. Disable affected endpoints if leak is ongoing.
3. Engage security lead + legal counsel.
4. Document everything for potential regulator notification.

**User communication:** Per legal counsel guidance — typically: direct notification to affected users within 72h.

**Admin actions:**
1. Preserve all logs + audit trails.
2. Identify root cause (API misconfig, insider, etc.).
3. Notify data protection officer for DPDP/GDPR assessment.

**Rollback:**
1. Patch the leak source.
2. Rotate all API keys + secrets.
3. Reset affected user tokens.

**Prevention:**
1. Annual penetration test.
2. Continuous secret scanning in repo.
3. Strict least-privilege access controls.

### 11. App store policy complaint (`app_store_complaint`)

**Severity:** Medium
**Detection:** Apple/Google review team flags the app, or user reports policy violation.

**Immediate actions:**
1. Identify the specific policy concern.
2. Pull relevant app screenshots + content for review.
3. Engage product lead + legal.
4. Respond to store review within 24h.

**User communication:** Public response on store listing; direct outreach if specific user complaint.

**Admin actions:**
1. Fix the policy-violating content (e.g. misclassified age, missing safety info).
2. Document the fix + submit appeal.
3. Monitor for re-review.

**Rollback:**
1. Re-submit app for review.
2. Verify listing live after approval.

**Prevention:**
1. Pre-launch checklist includes store policy review.
2. Quarterly audit of app listing copy + screenshots.
3. Maintain open channel with store review teams.

### 12. High false-positive moderation spike (`false_positive_spike`)

**Severity:** Medium
**Detection:** False-positive rate > 15% on moderation dashboard, or appeal surge for message moderation.

**Immediate actions:**
1. Identify the moderation rule or banned term causing the spike.
2. Temporarily relax the rule (admin-only flag).
3. Notify native-speaker review queue.

**User communication:** Proactive: notify users whose messages were wrongly flagged — "We are reviewing your message."

**Admin actions:**
1. Review recent flagged messages for false positives.
2. Apply correct outcomes (true_positive / false_positive).
3. Restore affected users' trust scores (+10 per false positive).

**Rollback:**
1. Re-tighten moderation rule after fix.
2. Add the false-positive phrase to whitelist if appropriate.

**Prevention:**
1. Native-speaker review queue (Phase 24).
2. False-positive dashboard (Phase 24) tracked weekly.
3. Moderation rule changes require admin review.

## Incident lifecycle

Every incident moves through four statuses:

1. **active** — Incident is ongoing. Admin is working through immediate actions.
2. **mitigated** — Immediate impact is contained, but root cause not yet resolved.
3. **resolved** — Root cause is fixed, system is back to normal.
4. **postmortem** — Postmortem document is being written.

The `/admin/incidents` page allows admins to:

* View all incidents with severity and status filters.
* Create a new incident (pre-populated from a playbook).
* Update incident status.
* View playbook details for reference.

## Acceptance criteria

* All 12 playbooks are documented and accessible at `/admin/incidents`.
* Admin can create an incident with playbook pre-populated.
* Admin can update incident status (active → mitigated → resolved → postmortem).
* Every incident has a severity, detection, immediate actions, user communication, admin actions, rollback, and prevention fields.
* Critical incidents trigger immediate admin notification.
* Incident history is preserved indefinitely (IncidentReport table).
* All incident actions are audit-logged.
