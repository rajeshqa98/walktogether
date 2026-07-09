# Admin Access Governance

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** SRE Lead + Security Lead

## Overview

WalkTogether admins have powerful capabilities: they can suspend or ban users, review safety events, manage appeals, trigger data exports, and configure retention rules. With great power comes great responsibility — and great risk. A compromised admin account, a rogue admin, or simply an admin who hasn't logged in for months all represent security and governance risks.

Phase 25 introduces the Admin Access Governance system at `/admin/admin-access` (backed by `GET /api/admin/admin-access` and `POST /api/admin/admin-access`). The system tracks every admin login, every failed login attempt, every high-risk action, and provides controls to deactivate admins who should no longer have access.

This document covers the admin lifecycle, access logging, high-risk action tracking, inactive admin detection, and the controls available to super-admins.

## Admin lifecycle

### Provisioning

A user becomes an admin when their `User.role` is changed from `"user"` to `"admin"`. This is done by an existing admin via the `/admin/users` page. The role change is audit-logged in `AuditLog` with `action: "role_changed"`.

All admins are expected to have:

* 2FA enabled (where supported by the auth provider).
* A valid phone number (for emergency contact).
* A documented reason for admin access (in their `statusReason` field or in the audit log entry that granted them admin).

### Active admin

An active admin (`User.status: "active"`, `User.role: "admin"`) can:

* View all admin pages (`/admin/*`).
* Perform admin actions (warn, suspend, ban, restore users).
* Review safety events, reports, appeals.
* Trigger data exports and retention runs.
* Create and resolve incidents.
* View audit logs and admin access logs.

### Inactive admin

An admin is considered inactive if they have not logged in for 30 days. The `/admin/admin-access` page surfaces inactive admins with a yellow `INACTIVE` badge. Inactive admins should be reviewed quarterly — either they should be re-engaged (given a reason to log in) or deactivated.

Inactive admins are not automatically deactivated. The decision to deactivate is a human one, made by a super-admin or the SRE Lead.

### Deactivated admin

A deactivated admin (`User.status: "suspended"`, with `statusReason: "Admin access revoked by ..."`) cannot:

* Log in to admin pages (they're redirected to `/` if they try).
* Perform admin actions.
* Appear in the admin list as "active".

The deactivation is reversible — a super-admin can reactivate the admin via the `/admin/admin-access` page.

### Self-protection

An admin cannot deactivate their own account via the `/admin/admin-access` page. This prevents an admin from accidentally locking themselves out. If an admin needs to be deactivated, another admin must do it.

## Access logging

Every admin access event is logged in the `AdminAccessLog` table:

| Field | Description |
|---|---|
| `adminId` | The admin's user ID (null if failed login with unknown admin) |
| `eventType` | `login_success` / `login_failed` / `logout` / `deactivated` / `reactivated` / `role_changed` / `high_risk_action` |
| `ipAddress` | Hashed IP address (for security forensics) |
| `userAgent` | Browser user agent |
| `metadata` | JSON with event-specific details |
| `createdAt` | When the event occurred |

### Login events

* `login_success` — Admin successfully logs in.
* `login_failed` — Admin login fails (wrong password, invalid 2FA, etc.).
* `logout` — Admin logs out.

Failed logins are surfaced on the `/admin/admin-access` page (last 24 hours). A spike in failed logins for a specific admin may indicate a compromise attempt.

### Lifecycle events

* `deactivated` — Admin account was deactivated (by another admin).
* `reactivated` — Admin account was reactivated.
* `role_changed` — Admin role was granted or revoked.

### High-risk action events

* `high_risk_action` — Admin performed a high-risk action. The `metadata` field contains the action type, target, and reason.

## High-risk actions

The following admin actions are classified as high-risk:

| Action | Why it's high-risk |
|---|---|
| `ban_user` | Permanently removes a user from the community |
| `suspend_user` | Temporarily removes a user from the community |
| `delete_user` | Hard-deletes a user (rare; usually we anonymize instead) |
| `deactivate_admin` | Removes admin access from another admin |
| `role_changed` | Grants or revokes admin role |
| `restore_user` | Reverses a ban/suspend — could enable a bad actor to return |
| `data_export_admin` | Triggers a data export on behalf of a user |
| `privacy_request_complete` | Completes a privacy request (e.g. account deletion) |
| `account_deletion_finalize` | Finalizes account deletion (anonymizes personal data) |

Every high-risk action is:

1. Audit-logged in `AuditLog` with the admin ID, action, target, and reason.
2. Logged in `AdminAccessLog` with `eventType: "high_risk_action"` and metadata.
3. Surfaced on the `/admin/admin-access` page (last 30 days).

The `/admin/admin-access` page shows:

* The admin who performed the action.
* The action type.
* The target (user name if available, otherwise target ID).
* The reason (if provided).
* When the action was taken.

This allows a super-admin to review the high-risk actions of any admin and detect unusual patterns (e.g. an admin banning 50 users in an hour is suspicious).

## Inactive admin detection

An admin is flagged as inactive if they have not logged in for 30 days. The `/admin/admin-access` page shows:

* Total admins.
* Active admins (status: active).
* Inactive admins (no login in 30 days).

The inactive admin count is a governance signal. A high number of inactive admins suggests:

* Admins have left the team but weren't deactivated.
* Admins are no longer engaged with the safety review process.
* The admin roster is stale and should be reviewed.

The recommended response to inactive admins:

1. Contact the admin to confirm they still need access.
2. If yes, ask them to log in within 7 days.
3. If no, deactivate them.
4. If no response in 7 days, deactivate them.

This quarterly review is the responsibility of the SRE Lead or a designated super-admin.

## Failed login monitoring

Failed admin logins are surfaced on the `/admin/admin-access` page (last 24 hours). Patterns to watch for:

* **Multiple failed logins for the same admin** — may indicate a compromised password or 2FA bypass attempt.
* **Failed logins from a new IP** — may indicate an attacker trying to brute-force an admin account.
* **Failed logins at unusual hours** — may indicate an attacker in a different timezone.

If you see 5+ failed logins for a single admin in 1 hour:

1. Contact the admin (via out-of-band channel) to verify they're trying to log in.
2. If not, immediately deactivate the admin account.
3. Review recent admin actions by that account for any unauthorized changes.
4. Force a password reset and 2FA re-enrollment before reactivating.

## Admin controls

### Deactivate an admin

A super-admin can deactivate an admin via the `/admin/admin-access` page:

1. Click "Deactivate" on the admin row.
2. Enter a reason (required — documented in audit log).
3. Confirm.

The deactivation:

* Sets `User.status: "suspended"`.
* Sets `User.statusReason: "Admin access revoked by [admin name]: [reason]"`.
* Logs `admin_deactivated` in `AdminAccessLog`.
* Logs `admin_deactivated` in `AuditLog`.
* Prevents the admin from logging in or accessing `/admin/*`.

### Reactivate an admin

A super-admin can reactivate a deactivated admin:

1. Click "Reactivate" on the deactivated admin row.
2. Confirm.

The reactivation:

* Sets `User.status: "active"`.
* Clears `User.statusReason`.
* Logs `admin_reactivated` in `AdminAccessLog`.
* Logs `admin_reactivated` in `AuditLog`.

Reactivation should be rare and well-justified — the reason for the original deactivation should be reviewed before reactivating.

### Log a high-risk action

Admins can manually log a high-risk action via `POST /api/admin/admin-access` with `action: "log_high_risk"`. This is useful for documenting actions that don't fit the standard high-risk action types but should still be tracked.

## Quarterly admin access review

Every quarter, the SRE Lead (or designated super-admin) conducts an admin access review:

1. Pull the `/admin/admin-access` page.
2. Review the admin list:
   * Are all admins still with the team?
   * Are any admins inactive (no login in 30 days)?
   * Are any admins' roles inappropriate (e.g. an admin who only needs read access)?
3. Review the failed logins:
   * Any patterns suggesting compromise attempts?
4. Review the high-risk actions:
   * Any unusual patterns?
   * Any actions that seem unjustified?
5. Document the review in the SRE wiki.
6. Make changes (deactivate inactive admins, adjust roles) as needed.

The review is mandatory and is tracked as a quarterly OKR for the SRE Lead.

## Acceptance criteria

* `/admin/admin-access` page loads with admin list, failed logins, high-risk actions, and access logs.
* Admin can deactivate another admin (with required reason).
* Admin can reactivate a deactivated admin.
* Admin cannot deactivate their own account.
* Every admin login is logged in `AdminAccessLog`.
* Every failed admin login is logged.
* Every high-risk action is logged in both `AuditLog` and `AdminAccessLog`.
* Inactive admins (no login in 30 days) are flagged.
* Quarterly admin access review is documented.
