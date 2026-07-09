# WalkTogether — Admin Appeals Queue Spec

**Phase:** 21
**Status:** Implemented

---

## 1. Overview

Admin appeals queue at `/admin/appeals` allows admins to review and resolve user appeals.

## 2. Admin Actions

| Action | Description | Effect |
|--------|-------------|--------|
| start_review | Mark as under review | Assigns admin |
| request_info | Request more info from user | Status → needs_more_info |
| approve | Approve appeal | Restores account/host/trust |
| reject | Reject appeal | Restriction remains |
| close | Close without resolution | Status → closed |

## 3. Restore Options (on approve)

- `restoreAccount` — sets user status to "active", clears statusReason
- `restoreHostAbility` — sets isCommunityHost to true
- `restoreTrust` — adds +15 to trust score if < 50

## 4. Decision Templates

10 templates available for consistent messaging:
- warning_issued, temporary_suspension, permanent_ban
- appeal_approved, appeal_rejected
- host_ability_restored, group_walk_cancelled
- false_positive_confirmed, needs_more_information
- safety_concern_acknowledged

## 5. Audit Logging

Every admin action creates an audit log entry with:
- adminId, targetUserId, action, targetType, targetId, notes

## 6. Notifications

Users receive push notifications when:
- Appeal is approved
- Appeal is rejected
- More information is requested

## 7. Acceptance Criteria

- [x] Admin can view appeal with user context
- [x] Admin can approve/reject/close appeals
- [x] Approved appeals restore account, host ability, trust
- [x] Every action creates audit log
- [x] User receives notification on decision
