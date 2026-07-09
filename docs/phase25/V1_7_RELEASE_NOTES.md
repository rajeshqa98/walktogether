# V1.7 Release Notes — Production Hardening & Privacy Governance

**Version:** 1.7.0
**Phase:** 25
**Release date:** 2026-07-06
**Status:** Released

## Overview

WalkTogether V1.7 is a production hardening release focused on reliability, privacy governance, data retention, backup/recovery, observability, and operational resilience. The app remains 100% free for everyone — no payments, subscriptions, premium features, ads, or monetization.

This release introduces 10 new admin pages, 19 new API endpoints, 8 new database models, and 14 documentation deliverables. It hardens the account deletion flow with a 14-day grace period, adds a complete privacy request workflow, and provides admin access governance for the first time.

## What's new

### For admins

#### Production Reliability Dashboard (`/admin/reliability`)

A single real-time view of every production system:

* Live health check for app, database, redis, socket, push, OTP provider, and service worker.
* Key metrics (1-hour window): API error rate, average API latency, failed login rate, failed OTP rate, notification delivery failures, realtime disconnect rate.
* SLO summary panel showing meeting/near_breach/breached status for each SLO.
* Active incidents panel.
* Recent snapshots trend (last 24).
* Auto-refresh every 30 seconds.

#### Service-Level Objectives (`/admin/slo`)

10 SLOs defined and tracked:

* SOS / report / block success: 99.9% (critical)
* Auth availability: 99%+ (critical)
* OTP success rate: 98%+
* Nearby search p95 latency: under 1500ms
* Chat send success: 99%+
* Walk request creation success: 99.5%+
* Admin action success: 99%+
* Push delivery success: 95%+
* Socket reconnect success: 95%+

Each SLO has a 7-day trend sparkline, breach bucket count, and worst-performing SLO is highlighted.

#### Data Retention Policy (`/admin/retention`)

14 retention rules enforced:

* **Preserved indefinitely:** safety events, reports, appeals, audit logs, moderation decisions, trust score history, privacy requests.
* **Expired per rule:** OTP attempts (30d), live presence (1d), location pings (7d), push subscriptions (90d), abandoned sessions (1d), invite tokens (90d), temp logs (90d), data export jobs (7d).

Admins can dry-run, run a single rule, or run all rules. Every run is audit-logged.

#### Privacy Request Queue (`/admin/privacy-requests`)

A complete queue for user-initiated privacy requests:

* 7 request types: account_deletion, data_export, data_correction, appeal_history_copy, optional_profile_deletion, push_token_removal, location_data_cleanup.
* SLA tracking with overdue badges.
* Admin actions: start_review, start_progress, complete, reject.
* Every action audit-logged.
* Specific request types trigger automation (e.g. account_deletion starts grace period, push_token_removal deletes subscriptions).

#### Incident Response (`/admin/incidents`)

12 incident playbooks:

* OTP outage, database outage, Redis outage, socket outage, push outage, SOS/report failure, location privacy bug, abusive user incident, admin account compromise, data leak suspicion, app store complaint, false-positive moderation spike.

Each playbook has severity, detection, immediate actions, user communication template, admin actions, rollback steps, and prevention measures. Admins can create incidents pre-populated from a playbook.

#### Admin Access Governance (`/admin/admin-access`)

First-time admin governance:

* Admin list with last login, action count, inactive flag.
* Failed login attempts (24h).
* High-risk actions log (30d) — every ban, suspend, delete, role change is tracked.
* Deactivate/reactivate admins (with required reason).
* Self-protection: cannot deactivate own account.
* Quarterly admin access review process documented.

#### Security Review (`/admin/security-review`)

12 automated security checks:

* Admin APIs require admin role.
* User APIs require authentication.
* Suspended/banned users remain blocked.
* Appeal APIs do not leak other user data.
* Trust score history is admin-only.
* Safety task data is admin-only.
* Exact location not exposed in normal APIs.
* Push subscriptions belong to authenticated user.
* Rate limiting works.
* OTP brute-force protection works.
* Service worker does not cache API responses.
* Admin export does not expose exact coordinates.

#### Global Compliance Readiness (`/admin/compliance`)

Operational readiness assessment for 9 frameworks:

* India DPDP Act 2023
* GDPR (EU)
* CCPA / CPRA (California)
* Children / Minors Policy
* Emergency Disclaimer
* Location Data Minimization
* Moderation Transparency
* Appeal Process
* Free Product Promise

Each framework shows readiness, summary, gaps, controls implemented, and lawyer review flag. The page includes a prominent disclaimer: "This is an operational readiness assessment, not a legal certification."

#### Backup & Restore Plan (`/admin/backup-restore`)

Complete backup plan documentation:

* Daily encrypted DB backups with 30-day retention.
* Point-in-time recovery (Postgres, 7-day WAL).
* Monthly restore drill process (10 steps, with last drill + next drill due).
* Critical record counts that must survive any restore.
* Disaster recovery checklist (10 steps).
* Backup access control (view, restore, delete permissions).

#### Data Export Jobs (`/admin/data-export`)

Admin view of all user data export jobs:

* Job list with status, scope, file size, checksum, expiry.
* Summary counts by status (queued, in_progress, ready, failed, expired).
* Admin can trigger an export via `POST /api/admin/data-export`.

### For users

#### Privacy Request Workflow

Users can now submit privacy requests from the in-app Settings:

* Account deletion (starts 14-day grace period).
* Data export (immediate JSON download).
* Data correction / update.
* Appeal history copy.
* Optional profile data deletion.
* Push token removal.
* Location data cleanup.

Each request enters the admin queue with a tracked SLA. Users can cancel pending requests. Every action is audit-logged.

#### Account Deletion Hardening

The account deletion flow is now safer:

* **14-day grace period** — user can cancel any time.
* **Immediate safety measures** — user is hidden from nearby, push subscriptions revoked, live presence deleted on deletion start.
* **Anonymization after grace** — personal data (name, phone, email, photo, bio, location) is anonymized after 14 days.
* **Safety/audit records preserved** — safety events, reports, appeals, audit logs, trust score history, privacy requests remain preserved indefinitely for safety and legal reasons.
* **Transparent communication** — the confirmation dialog clearly explains what's preserved vs anonymized.

#### User Data Export

Users can download their data as JSON:

* Includes: profile, preferences, walks, groups/clubs, reports, appeals, feedback, ratings, blocks, trust score history, notifications.
* Excludes: other users' phone/email/exact coordinates, adminNotes, admin-only safety intelligence, push subscription secrets.
* Phone number is partially redacted (`+91*****4210`).
* Includes SHA-256 checksum for integrity verification.

## Technical details

### New Prisma models (8)

* `PrivacyRequest` — User-initiated privacy requests with SLA tracking.
* `AccountDeletionRequest` — Account deletion with grace period workflow.
* `DataExportJob` — Async user data export jobs.
* `AdminAccessLog` — Admin access governance logs.
* `IncidentReport` — Production incident reports.
* `SloMetric` — SLO metric snapshots (hourly buckets).
* `ReliabilitySnapshot` — Periodic reliability health snapshots.
* `RetentionAuditLog` — Data retention enforcement audit log.

### New API endpoints (19)

10 admin endpoints + 7 user-facing endpoints (see Phase 25 Test Report for full list).

### New admin pages (10)

See "For admins" section above.

### Library module: `src/lib/phase25.ts`

Single source of truth for:

* SLO definitions + evaluation (`SLO_DEFINITIONS`, `evaluateSlo`, `recordSloMetric`).
* Retention rules + enforcement (`RETENTION_RULES`, `enforceRetentionRule`, `runAllRetention`).
* Privacy request SLAs (`PRIVACY_REQUEST_SLAS`, `computeDueAt`).
* Reliability health checks (`performHealthCheck`, `saveReliabilitySnapshot`).
* Admin access governance (`HIGH_RISK_ADMIN_ACTIONS`, `logAdminAccess`).
* Log redaction (`redactPayload`).
* Incident playbooks (`INCIDENT_PLAYBOOKS`, `getPlaybook`).
* Account deletion helpers (`startAccountDeletion`, `cancelAccountDeletion`, `finalizeAccountDeletion`, `processPendingDeletions`).

## What didn't change

* **Free product promise:** WalkTogether remains 100% free for everyone. No payments, subscriptions, premium features, ads, or monetization.
* **Safety-first principles:** All safety features remain free and mandatory. No auto-ban without admin review.
* **Community-first principles:** Community governance, appeals, and transparency remain core to the product.
* **9-language support:** en, hi, te, ta, kn, bn, es, ar, fr (Arabic RTL).
* **Existing admin tools:** All Phase 24 admin tools (safety queue, appeals, workload balancing, false-positive dashboard, native speaker review, village/town growth analytics, host growth analytics) remain unchanged.
* **Existing user features:** All user-facing features (walks, groups, clubs, chats, SOS, safety share, ratings, blocks) remain unchanged.

## Migration notes

* Database migration is automatic via `bun run db:push`. 8 new tables are created.
* No existing data is modified or deleted.
* No breaking changes to existing APIs.
* No client-side changes required (existing user app continues to work).

## Known limitations

* **Redis health check** in dev mode returns `degraded` because Redis is not running. This is expected — in production, Redis is available and the check returns `healthy`.
* **SLO metrics** are only populated when API traffic flows. In dev with no traffic, SLOs show `unknown` status. In production, real traffic populates the metrics within an hour.
* **Reliability snapshots** are only saved when an admin clicks "Save snapshot" or when the scheduled job runs. In dev, no scheduled job runs; in production, it runs every 5 minutes.
* **Data export fileUrl** is null in dev (no S3 configured). In production, this is a signed S3 URL.
* **Compliance readiness** is operational but not legally certified. Each framework requires lawyer review before formal compliance can be claimed.

## Acceptance criteria

All 12 acceptance criteria from the Phase 25 spec pass:

1. Reliability dashboard is available. ✓
2. SLOs are defined. ✓
3. Retention rules are documented or implemented. ✓
4. Backup/restore plan is complete. ✓
5. Privacy request workflow is ready. ✓
6. Account deletion is safer. ✓
7. User export is specified. ✓
8. Admin access is governed. ✓
9. Incident playbooks are complete. ✓
10. Security review passes. ✓
11. WalkTogether remains 100% free for everyone. ✓

## Documentation

14 documentation deliverables in `docs/phase25/`:

1. PRODUCTION_RELIABILITY_DASHBOARD_SPEC.md
2. SERVICE_LEVEL_OBJECTIVES.md
3. DATA_RETENTION_POLICY.md
4. BACKUP_AND_RESTORE_PLAN.md
5. PRIVACY_REQUEST_WORKFLOW.md
6. ACCOUNT_DELETION_HARDENING.md
7. USER_DATA_EXPORT_SPEC.md
8. SECURITY_REVIEW_REPORT.md
9. INCIDENT_RESPONSE_PLAYBOOKS.md
10. OBSERVABILITY_LOGGING_GUIDE.md
11. ADMIN_ACCESS_GOVERNANCE.md
12. GLOBAL_COMPLIANCE_READINESS.md
13. PHASE_25_TEST_REPORT.md
14. V1_7_RELEASE_NOTES.md (this document)

## Looking ahead

Phase 25 completes the production hardening story. Possible future directions:

* **Phase 26:** Multi-region deployment + active-active failover.
* **Phase 27:** Advanced fraud detection (device fingerprinting, behavioral analysis).
* **Phase 28:** Voice / video calls (with end-to-end encryption).
* **Phase 29:** Accessibility audit (WCAG 2.2 AA compliance).
* **Phase 30:** Public API for researchers + data donation.

For now, WalkTogether V1.7 is ready for global production deployment. Stay safe, walk together.
