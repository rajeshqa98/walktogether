# Privacy Request Workflow

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** Privacy Lead + Product Lead

## Overview

WalkTogether provides a structured privacy request workflow that lets every user exercise their data subject rights under India's DPDP Act, the EU's GDPR, California's CCPA/CPRA, and other emerging privacy frameworks. Users can request account deletion, data export, data correction, appeal history copy, optional profile data deletion, push token removal, and location data cleanup — all from the in-app Settings screen.

Every privacy request enters an admin queue at `/admin/privacy-requests`, gets assigned to an admin, has a tracked SLA, and produces an audit log entry on completion. Every action — creation, review, completion, rejection, cancellation — is audit-logged so the privacy governance trail is complete.

This document covers the user-facing workflow, admin queue management, SLA targets, audit logging, and the integration with the account deletion grace period.

## User-facing workflow

### How users submit a privacy request

Users can submit a privacy request from the Settings screen. Two paths are available:

1. **Direct action buttons** (one-tap, immediate):
   * "Download my data" — triggers an immediate JSON export via `GET /api/me/export`.
   * "Delete my account" — starts the 14-day grace period via `POST /api/me/deletion`.

2. **Form-based privacy request** (for non-default request types):
   * User fills out a short form with request type + optional details.
   * POST to `/api/privacy-requests` creates a `PrivacyRequest` row.
   * Request enters the admin queue with a SLA due date.

### Request types

| Request type | Label | SLA | What happens |
|---|---|---|---|
| `account_deletion` | Account deletion | 30 days | Starts 14-day grace period, then anonymizes personal data |
| `data_export` | Data export | 7 days | Admin triggers a DataExportJob; user receives a JSON download |
| `data_correction` | Data correction / update | 14 days | Admin updates the user's profile fields per their request |
| `appeal_history_copy` | Appeal history copy | 7 days | Admin exports the user's appeal history as JSON |
| `optional_profile_deletion` | Optional profile data deletion | 14 days | Admin deletes specific optional fields (bio, photo, etc.) |
| `push_token_removal` | Push token removal | 3 days | Admin deletes all PushSubscription rows for the user |
| `location_data_cleanup` | Location data cleanup | 7 days | Admin deletes LivePresence + anonymizes WalkSession.routeSummary |

### Throttling

To prevent abuse, each user can have at most 5 open privacy requests at a time. If they try to create more, the API returns 429 with a friendly message asking them to wait for existing requests to complete.

### Cancellation

Users can cancel any privacy request that is in `submitted` or `in_review` status. Once a request is `in_progress`, it cannot be cancelled (admin is actively working on it). Cancelled requests remain in the audit log but are marked as `cancelled`.

## Admin queue management

### Queue view

The admin queue at `/admin/privacy-requests` shows:

* Summary cards: submitted, in_review, in_progress, completed, rejected, overdue counts.
* Filterable list of privacy requests with user info, request type, status, due date, and overdue badge.
* SLA reference table showing the SLA for each request type.
* Action buttons for each request: Start review, Mark in progress, Complete, Reject.

### Assignment

When an admin clicks "Start review" on a privacy request:

1. The request status changes to `in_review`.
2. `assignedAdminId` is set to the current admin.
3. An `AuditLog` entry is created with `action: privacy_request_start_review`.

The admin who starts the review is the default assignee until the request is completed or rejected. Other admins can see who is working on what.

### Completion

When an admin clicks "Complete":

1. The request status changes to `completed`.
2. `completedAt` is set to now.
3. `reviewedById` is set to the current admin.
4. Admin notes are saved (required for complete/reject actions).
5. An `AuditLog` entry is created with `action: privacy_request_complete`.
6. For specific request types, additional automation runs:
   * `account_deletion` → calls `startAccountDeletion()` in `@/lib/phase25.ts` to start the 14-day grace period.
   * `data_export` → creates a `DataExportJob` with status `queued`.
   * `push_token_removal` → deletes all `PushSubscription` rows for the user.
   * `location_data_cleanup` → deletes `LivePresence` + anonymizes `WalkSession.routeSummary`.

### Rejection

When an admin clicks "Reject":

1. The request status changes to `rejected`.
2. `reviewedById` is set to the current admin.
3. Admin notes are saved (must include the reason for rejection).
4. An `AuditLog` entry is created with `action: privacy_request_reject`.

Rejection is appropriate when the request is fraudulent, duplicates a previous request, or asks for something WalkTogether cannot do (e.g. delete safety events that are legally required to be preserved).

## SLA tracking

Each privacy request has a `dueAt` date computed from the SLA for its request type. The admin queue shows:

* **Overdue badge** on any request past its due date that is not yet completed or rejected.
* **Due date** on every request card.
* **Summary count** of overdue requests in the summary cards.

The SLA targets are defined in `PRIVACY_REQUEST_SLAS` in `@/lib/phase25.ts`:

| Request type | SLA |
|---|---|
| account_deletion | 30 days (DPDP / GDPR requirement) |
| data_export | 7 days (GDPR Article 12.3 — without undue delay, max 1 month) |
| data_correction | 14 days |
| appeal_history_copy | 7 days |
| optional_profile_deletion | 14 days |
| push_token_removal | 3 days |
| location_data_cleanup | 7 days |

## Audit logging

Every privacy request action creates an `AuditLog` entry:

| Action | Audit log `action` field | Notes |
|---|---|---|
| User submits request | `privacy_request_submitted` | `adminId` is the user themselves |
| User cancels request | `privacy_request_cancelled` | `adminId` is the user themselves |
| Admin starts review | `privacy_request_start_review` | |
| Admin marks in progress | `privacy_request_start_progress` | |
| Admin completes request | `privacy_request_complete` | Includes `completionRecord` JSON |
| Admin rejects request | `privacy_request_reject` | Includes reason in `reason` field |
| Admin creates request on behalf of user | `privacy_request_created` | |

The audit log is preserved indefinitely (per the data retention policy).

## Integration with account deletion

The `account_deletion` request type is special because it triggers the grace period workflow:

1. User submits `account_deletion` request via Settings → "Delete my account" button.
2. `POST /api/me/deletion` is called, which calls `startAccountDeletion()` in `@/lib/phase25.ts`.
3. `startAccountDeletion()`:
   * Creates an `AccountDeletionRequest` with `graceEndsAt = now + 14 days`.
   * Marks the user as `hideMe: true` (removed from nearby results immediately).
   * Deletes the user's `LivePresence` row.
   * Deletes the user's `PushSubscription` rows.
   * Logs the action.
4. A `PrivacyRequest` is also created for the admin queue with `status: in_review`.
5. Admin reviews the request. If approved, the admin clicks "Complete" — but the grace period was already started by the user's self-initiated action. The admin's role is to verify the request is legitimate (not coerced, not fraudulent).
6. After 14 days, the scheduled `processPendingDeletions()` job (or admin manual trigger) calls `finalizeAccountDeletion()`:
   * Anonymizes the user's profile (name → "Deleted User", phone → "deleted_xxx", email → null, etc.).
   * Deletes `WalkerPreferences`, `NotificationPreference`, `LivePresence`.
   * Marks `User.status: "banned"`, `trustLocked: true`.
   * Updates the `AccountDeletionRequest` with `status: "anonymized"`, `anonymizedAt: now`, and a `preservationRecord` JSON listing what was kept vs anonymized vs revoked.
7. Safety events, reports, appeals, audit logs, trust score history, and privacy requests remain preserved indefinitely.

## Acceptance criteria

* User can submit any of the 7 privacy request types from the in-app Settings.
* User can cancel a pending privacy request.
* User can download their data immediately via "Download my data" button.
* User can start account deletion with 14-day grace period.
* Admin queue shows all privacy requests with status, due date, and overdue badge.
* Admin can start review, mark in progress, complete, or reject any request.
* Every action is audit-logged.
* `account_deletion` triggers the grace period workflow.
* `push_token_removal` deletes all push subscriptions.
* `location_data_cleanup` deletes live presence + anonymizes route summaries.
* SLA targets are enforced and overdue requests are visible.
* Throttling prevents abuse (max 5 open requests per user).
