# Account Deletion Hardening

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** Privacy Lead + SRE Lead

## Overview

WalkTogether's account deletion flow has been hardened in Phase 25 to provide a safe, transparent, and fully audit-logged deletion process. The previous flow was a hard delete that erased the user immediately; the new flow uses a 14-day grace period during which the user can cancel, followed by anonymization of personal data while preserving safety-critical records indefinitely.

The hardened flow is implemented in `@/lib/phase25.ts` via `startAccountDeletion()`, `cancelAccountDeletion()`, `finalizeAccountDeletion()`, and `processPendingDeletions()`. The user-facing entry point is `POST /api/me/deletion`. The admin can monitor pending deletions via the privacy request queue at `/admin/privacy-requests`.

## Why a grace period?

A hard delete is irreversible and unforgiving:

* Users delete accounts in moments of frustration and immediately regret it.
* Coercive partners or family members may force a deletion.
* A user might think deleting their account is the only way to stop notifications or hide from a stalker — but those problems have better solutions (hide me toggle, block, push token removal) that don't require losing their walk history and trust score.

A 14-day grace period gives the user time to reconsider. During the grace period:

* The user is hidden from nearby results (cannot be discovered by other users).
* The user's live presence is deleted (no real-time location shared).
* The user's push subscriptions are revoked (no notifications).
* The user's active sessions are revoked (must log in again to access the app).
* But the user's profile, walk history, and trust score are intact.

If the user logs back in during the grace period, they can cancel the deletion with one tap.

## What gets preserved vs anonymized

### Preserved indefinitely (safety/audit reasons)

These records are kept even after account anonymization. They reference the user's anonymized ID, so the user's identity is protected but the safety trail remains intact.

| Record type | Reason for preservation |
|---|---|
| SafetyEvent (SOS, safety share) | Incident investigation, pattern detection |
| Report (filed by or against the user) | Repeat-offender detection, legal defense |
| Appeal + AppealTimeline | Governance audit, appeal precedent |
| AuditLog (all admin actions on the user) | Legal defense, accountability |
| TrustScoreHistory | Fairness audit, appeals support |
| PrivacyRequest (the deletion request itself) | Audit trail of what was requested and when |
| AccountDeletionRequest | Audit trail of the deletion process |

### Anonymized after grace period

These personal data fields are scrubbed or replaced with non-identifying values:

| Field | Anonymized to |
|---|---|
| `User.name` | `"Deleted User"` |
| `User.phone` | `"deleted_" + last 8 chars of user ID` (unique but non-identifying) |
| `User.email` | `null` |
| `User.profilePhoto` | `null` |
| `User.bio` | `null` |
| `User.village`, `town`, `district`, `stateRegion`, `landmark` | `null` |
| `User.status` | `"banned"` (locks the account from re-login) |
| `User.statusReason` | `"Account deleted by user request — personal data anonymized"` |
| `User.trustLocked` | `true` (freezes trust score) |
| `User.hideMe` | `true` (extra safety) |
| `User.isOnline` | `false` |
| `User.isCommunityHost` | `false` |

### Deleted entirely

These records are deleted because they serve no purpose once the user is gone:

| Record type | Reason for deletion |
|---|---|
| WalkerPreferences | Optional profile data — no audit value |
| NotificationPreference | Optional profile data — no audit value |
| LivePresence | Already deleted at start of grace period |
| PushSubscription | Already deleted at start of grace period |

## The deletion lifecycle

### Step 1: User initiates deletion

User taps "Delete my account" in Settings → confirms the 14-day grace period dialog → `POST /api/me/deletion` is called with an optional `reason` field.

`startAccountDeletion(userId, reason)` in `@/lib/phase25.ts`:

1. Computes `graceEndsAt = now + 14 days`.
2. Creates an `AccountDeletionRequest` row with `status: "pending_grace"`.
3. Updates the user:
   * `hideMe: true`
   * `isOnline: false`
   * `statusReason: "User requested account deletion — in grace period"`
4. Deletes `LivePresence` (immediate removal from nearby).
5. Deletes `PushSubscription` rows (no more notifications).
6. Logs `account_deletion_started`.
7. Creates a `PrivacyRequest` (type: `account_deletion`, status: `in_review`, dueAt: now + 30 days) so the admin queue is aware.

### Step 2: Grace period (14 days)

During the grace period, the user can:

* Log back in to the app (their account is still functional, just hidden).
* Cancel the deletion via `DELETE /api/me/deletion`.
* Continue using the app normally if they cancel.

The user is encouraged to cancel via in-app messaging if they log in during this period.

### Step 3: Cancellation (if user changes mind)

`cancelAccountDeletion(userId)`:

1. Updates the `AccountDeletionRequest` to `status: "cancelled"`.
2. Restores the user:
   * `hideMe: false`
   * `statusReason: null`
3. Logs `account_deletion_cancelled`.

The user can immediately re-appear in nearby results and re-enable push subscriptions.

### Step 4: Finalization (after grace period ends)

The scheduled `processPendingDeletions()` job runs daily and finds all `AccountDeletionRequest` rows where `status: "pending_grace"` and `graceEndsAt < now`. For each, it calls `finalizeAccountDeletion(userId)`:

1. Anonymizes the user profile (see table above).
2. Deletes `WalkerPreferences`, `NotificationPreference`, `LivePresence`.
3. Updates the `AccountDeletionRequest`:
   * `status: "anonymized"`
   * `anonymizedAt: now`
   * `processedById: null` (automated) or admin ID (manual)
   * `preservationRecord: JSON.stringify({ kept: [...], anonymized: [...], revoked: [...] })`
4. Logs `account_deletion_finalized`.

The admin can also manually trigger finalization via the privacy request queue (completing the `account_deletion` request), but the scheduled job is the primary mechanism.

### Step 5: Audit trail

Every step is audit-logged:

| Action | Audit log entry |
|---|---|
| User starts deletion | `account_deletion_self_requested` |
| User cancels deletion | `account_deletion_cancelled` |
| Admin reviews deletion request | `privacy_request_start_review` |
| Admin completes deletion request | `privacy_request_complete` |
| Automated finalization | `account_deletion_finalized` (in app logs, not AuditLog table) |

The `AccountDeletionRequest.preservationRecord` JSON is the definitive record of what was kept vs anonymized vs revoked. It is preserved indefinitely.

## Why we don't hard-delete the User row

Hard-deleting the `User` row would break referential integrity:

* `SafetyEvent.reporterId` / `subjectId` reference the user.
* `Report.reporterId` / `reportedUserId` reference the user.
* `Appeal.userId` references the user.
* `AuditLog.adminId` / `targetUserId` reference the user.
* `TrustScoreHistory.userId` references the user.

If we deleted the User row, every one of these references would either (a) need to be cascaded (losing safety data) or (b) become orphaned (breaking queries). Anonymization is the right approach — the User row stays, but the personal data is scrubbed.

## Compliance alignment

| Framework | Requirement | How we comply |
|---|---|---|
| India DPDP Act 2023 | Right to erasure | 14-day grace period + anonymization within 30 days |
| GDPR Article 17 | Right to erasure ("right to be forgotten") | Same |
| CCPA / CPRA | Right to delete | Same |
| COPPA | Children's data deletion | N/A — no users under 18 |

The 14-day grace period is shorter than the 30-day DPDP / GDPR deadline, giving us buffer time for any unexpected issues.

## Acceptance criteria

* User can start account deletion from Settings → "Delete my account".
* Confirmation dialog clearly explains the 14-day grace period and what is preserved vs anonymized.
* On deletion start: user is hidden from nearby, push subscriptions revoked, live presence deleted.
* User can cancel deletion during grace period by logging in.
* After 14 days, personal data is anonymized (name, phone, email, photo, bio, location).
* Safety events, reports, appeals, audit logs, trust score history, privacy requests preserved indefinitely.
* Every step is audit-logged.
* Admin can monitor pending deletions via `/admin/privacy-requests`.
* `processPendingDeletions()` runs daily and finalizes all grace-period-expired requests.
* Anonymized user cannot log in (status: "banned", trustLocked: true).
* Anonymized user is not discoverable in nearby results (hideMe: true).
