# Backup and Restore Plan

**Phase:** 25
**Status:** Implemented (SQLite dev) / Documented (Postgres prod)
**Last updated:** 2026-07-06
**Owner:** SRE Lead (on-call rotation)

## Overview

WalkTogether maintains daily encrypted database backups with a 30-day rolling retention, monthly restore drills, and a documented disaster recovery checklist. The plan is designed to ensure that no safety event, report, appeal, audit log, or privacy request record is ever lost — even in the event of a complete regional outage.

This document covers the backup strategy, restore process, drill cadence, access control, and verification steps. The admin-facing view of this plan is at `/admin/backup-restore`.

## Backup strategy

### Frequency

* **Daily full backup** at 02:00 UTC (low-traffic window globally).
* **Continuous WAL archiving** (Postgres only) for point-in-time recovery up to 7 days.
* **On-demand backup** before any schema migration or major deployment.

### Retention

| Backup type | Retention | Storage |
|---|---|---|
| Daily backups | 30 days | Encrypted S3 in primary region |
| Weekly backups (Sunday) | 12 weeks | Encrypted S3 in primary region |
| Monthly backups (1st of month) | 12 months | Encrypted S3 in primary region |
| Yearly backups (Jan 1) | 7 years | Encrypted S3 in cold archive |
| WAL segments (Postgres) | 7 days | Encrypted S3 in primary region |

### Encryption

* All backups are encrypted with AES-256 at rest.
* Encryption keys are managed by AWS KMS (or equivalent cloud KMS).
* Key rotation happens annually.
* Keys are stored separately from the encrypted backups — even if an attacker gains access to the backup bucket, they cannot decrypt without KMS access.

### Storage

* Primary backup bucket: same region as the production database (low latency for restore).
* Cross-region replica: a different geographic region (for regional disaster recovery).
* Cold archive: Glacier-class storage for yearly backups (low cost, hours-to-retrieve).

### Point-in-time recovery

* **Postgres:** 7-day PITR via WAL archiving. Restore to any point in time within the last 7 days.
* **SQLite (dev):** No PITR. Only snapshot-based restore (latest daily backup).

## Restore drill process

### Cadence

Monthly — first Saturday of each month at 10:00 UTC (low-traffic window).

### Steps

1. **Provision staging DB instance** from the latest daily backup. Staging is in an isolated VPC with no access to production data.
2. **Verify staging DB accepts connections** — basic TCP + auth check.
3. **Run integrity check:** `SELECT count(*) FROM safety_event, report, appeal, audit_log, trust_score_history, privacy_request`. Counts must match production within 24 hours.
4. **Compare record counts against production.** Discrepancy greater than 24 hours indicates a backup lag issue.
5. **Run app in read-only mode against staging DB.** Feature flag `READ_ONLY_MODE` is enabled; write APIs return 503.
6. **Verify admin dashboard loads** and critical queries succeed (safety queue, appeals queue, reports queue).
7. **Verify no PII leakage in logs.** Staging logs are scanned for unredacted phone, email, lat, lng fields.
8. **Document drill result in audit log** — `action: restore_drill_completed`, with notes about integrity check and record count match.
9. **Tear down staging instance.** All staging data is destroyed after the drill.
10. **File postmortem if any step fails.** Failures are treated as P2 incidents and must be resolved before the next drill.

### Drill ownership

* **Executor:** On-call SRE.
* **Reviewer:** SRE Lead.
* **Observer:** Product Lead (optional, recommended for first drill of each quarter).

### Drill record

Each drill is recorded in the `AuditLog` table with:

* `adminId` — the SRE who ran the drill
* `action` — `restore_drill_completed`
* `targetType` — `system`
* `targetId` — `backup_restore`
* `reason` — JSON with `notes`, `integrityCheck`, `recordCountsMatch`, `completedAt`

The `/admin/backup-restore` page surfaces the last drill date, notes, and next drill due date.

## Verification

After any restore (drill or real), the following must be verified:

### Critical record counts

These counts must match production (within 24-hour lag):

| Table | What it represents |
|---|---|
| `SafetyEvent` | SOS events, safety share activations |
| `Report` | User reports against other users |
| `Appeal` | User appeals + AppealTimeline |
| `AuditLog` | All admin actions |
| `TrustScoreHistory` | Every trust score change |
| `PrivacyRequest` | Every privacy request + completion record |
| `User` | User profiles (with anonymized deletion-pending users) |

If any of these counts differ from production by more than 24 hours of activity, the restore is considered failed and the SRE Lead + Product Lead are paged.

### Sensitive data not exposed

* Staging database must NOT be accessible from outside the staging VPC.
* Staging logs must NOT contain unredacted PII (phone, email, lat, lng).
* Staging admin dashboard must NOT be accessible from the public internet.
* Any data extracted from staging for verification must be deleted after use.

## Disaster recovery checklist

When a real restore is needed (production DB is unreachable or corrupted):

1. **Confirm primary DB is unreachable** (not just slow). Check `database` health on `/admin/reliability`.
2. **Notify DR owner + Product Lead.** Open a P1 incident in `/admin/incidents`.
3. **Switch DNS to failover region** (if multi-region configured). DNS TTL is 60 seconds.
4. **Provision fresh DB from most recent backup.** Target: 30 minutes from decision to live.
5. **Replay WAL up to failure point** (if PITR available). Target: up to 7 days of replay.
6. **Verify safety_event + report + appeal record counts** vs production snapshot. Any discrepancy is a P0.
7. **Verify audit logs are intact and queryable.** Audit logs are the legal record — any loss is a regulator-reportable event.
8. **Verify no PII leakage in restore process.** Logs are scanned for unredacted PII.
9. **Communicate to users via in-app banner + status page.** Honesty about scope and ETA.
10. **File postmortem within 7 days.** Root cause analysis + prevention plan.

## Access control

| Action | Who can do it |
|---|---|
| View backup list | SRE Lead, Product Lead |
| Restore backup | SRE Lead only |
| Delete backup | SRE Lead only |
| Configure backup schedule | SRE Lead only |

Every backup access (view, restore, delete) must be logged in `AdminAccessLog` with:

* `adminId` — who did it
* `eventType` — `high_risk_action`
* `metadata` — JSON with `action`, `backupId`, `reason`

Restoring a backup without an audit log entry is a security incident.

## Acceptance criteria

* Daily backups complete successfully (verified by monitoring).
* Monthly restore drill completes all 10 steps without failure.
* Critical record counts match production within 24-hour lag after restore.
* No PII leakage in staging logs during drill.
* All backup accesses are audit-logged.
* Disaster recovery checklist is documented and tested annually.
* Backup encryption keys are rotated annually.
* Cross-region replica is verified quarterly.
