# User Data Export Spec

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** Privacy Lead

## Overview

WalkTogether provides a complete data export endpoint at `GET /api/me/export` that returns everything the user is entitled to see about themselves in a single JSON file. The export is designed to comply with India's DPDP Act (right to access), GDPR Article 15 (right of access), GDPR Article 20 (right to data portability), and CCPA (right to know).

The export is available immediately — no waiting period, no admin review required. Users can download it any time from Settings → "Download my data". Admins can also trigger an export on behalf of a user via `POST /api/admin/data-export` (typically when a privacy request is approved).

## What's included

### Profile data

* `id`, `name`, `phone` (redacted — see below), `email`, `ageRange`, `gender`, `bio`, `city`, `neighborhood`, `village`, `town`, `district`, `stateRegion`, `countryCode`, `language`, `verificationStatus`, `trustScore`, `completedWalks`, `isCommunityHost`, `hostOnboardedAt`, `createdAt`, `updatedAt`.

### Preferences and notification preferences

* `WalkerPreferences` (pace, languages, walkTypes, genderPreference, maxRadius, verifiedOnly, womenOnly, daylightOnly, publicPlaceOnly, groupWalk).
* `NotificationPreference` (pushEnabled, walkRequestPush, chatMessagePush).

### Walks

* Sent walk requests (with receiver's name only — no phone/email).
* Received walk requests (with sender's name only).
* Walk sessions (with `routeSummary` redacted to "<route data available on request>" — full route is available via a separate request if needed).

### Groups and clubs

* Hosted group walks.
* Group walk participations.
* Created clubs.
* Club memberships.

### Reports filed

* All reports the user has filed, with the reported user's name only (no phone/email).
* `adminNotes` field is EXCLUDED — that's internal admin commentary, not meant for the user.

### Appeals

* All appeals the user has submitted, including the full timeline events.
* `adminNotes` field is EXCLUDED.

### Feedback

* All feedback the user has submitted.
* `adminNotes` field is EXCLUDED.

### Ratings

* Ratings given (with rated user's name only).
* Ratings received (with rater's name only).

### Blocks

* Blocks initiated (with blocked user's name only).
* Blocks received (with blocker's name only).

### Trust score history

* Full history of every trust score change, with reason and source event.

### Notifications

* All notifications the user has received (last 500).

### Push subscriptions

* List of push subscriptions, with `userAgent`, `createdAt`, `updatedAt`.
* `endpoint`, `p256dh`, `auth` fields are EXCLUDED for security.

## What's NOT included

### Other users' private data

* Other users' phone numbers.
* Other users' email addresses.
* Other users' exact coordinates.
* Other users' full profile data.

When another user is referenced (e.g. "you sent a walk request to X"), only the other user's name is included. This is the minimum necessary for the user to understand their own data.

### Internal moderation notes

* `Report.adminNotes` — internal admin commentary on a report.
* `Appeal.adminNotes` — internal admin commentary on an appeal.
* `UserFeedback.adminNotes` — internal admin commentary on feedback.

These fields are explicitly excluded from the export.

### Admin-only safety intelligence

* `SafetyTask` data — internal safety review tasks.
* `SafetySignal` data — automated safety signal detections.
* `AdminAccessLog` data — admin access governance logs.
* `RetentionAuditLog` data — data retention enforcement logs.
* `IncidentReport` data — production incident reports.

These are operational records, not user data, and are not included in user exports.

### Push subscription secrets

* `PushSubscription.endpoint` — the browser push endpoint URL (could be abused to send unauthorized pushes).
* `PushSubscription.p256dh` — the client public key.
* `PushSubscription.auth` — the auth secret.

These are excluded for security. The user can see that they have N push subscriptions and when they were created, but not the cryptographic material.

## Phone number redaction

The user's own phone number is partially redacted in the export:

* Original: `+919876543210`
* Exported: `+91*****4210`

This is a security measure — the export file may be stored on the user's device or shared (accidentally or intentionally), and a full phone number could be used for SIM-swap attacks or social engineering. The user already knows their own phone number; they don't need it in the export.

If the user needs their full phone number for verification purposes, they can see it in the app's Profile screen.

## Checksum

Every export includes a `exportChecksum` field — a SHA-256 hash of the JSON content (excluding the checksum itself). This allows the user (or a regulator) to verify that the export has not been tampered with after download.

The checksum is computed by `createHash("sha256").update(JSON.stringify(exportData)).digest("hex")` in the export route.

## Export metadata

Every export includes an `exportMetadata` object:

```json
{
  "exportedAt": "2026-07-06T12:34:56.789Z",
  "userId": "clxxx...",
  "schema": "walktogether-user-export-v1",
  "note": "This export contains all data WalkTogether holds about you. Other users' private data (phone, email, exact coordinates) is excluded."
}
```

The `schema` field versioning allows the export format to evolve without breaking consumers.

## Admin-triggered exports

Admins can trigger an export on behalf of a user via `POST /api/admin/data-export` with `userId` and optional `scope`. This creates a `DataExportJob` row with:

* `status: "in_progress"` → `"ready"`
* `startedAt`, `completedAt`
* `sha256Checksum`
* `fileSizeBytes`
* `expiresAt` (7 days from creation)

The job is visible at `/admin/data-export`. In production, the `fileUrl` would be a signed S3 URL; in development, it's null (the export data is stored in the job's metadata).

Admin-triggered exports are audit-logged:

* `action: "data_export_admin_triggered"`
* `targetType: "user"`
* `targetUserId: <userId>`
* `reason: "Job ID: ..., Scope: ..."`

## Data export jobs table

The `DataExportJob` model tracks every export, whether user-initiated (immediate download) or admin-initiated (job with file URL). For user-initiated exports, no `DataExportJob` is created — the export is streamed directly to the response. For admin-initiated exports, a `DataExportJob` row is created and the file is stored (in production: S3; in dev: in-memory only).

This split is intentional: user-initiated exports are private to the user and don't need an admin-visible record. Admin-initiated exports are part of the privacy request workflow and need an audit trail.

## Retention

Per the data retention policy:

* `DataExportJob` rows past their 7-day `expiresAt` are anonymized (fileUrl cleared, status set to "expired") by the `data_export_jobs` retention rule.
* The `DataExportJob` row itself is preserved indefinitely as an audit record of what was exported and when.

## Acceptance criteria

* `GET /api/me/export` returns a complete JSON export of the user's data.
* Export includes all the data categories listed above.
* Export excludes other users' phone/email/exact coordinates.
* Export excludes `adminNotes` fields on reports, appeals, and feedback.
* Export excludes admin-only safety intelligence (SafetyTask, SafetySignal, etc.).
* Export excludes push subscription cryptographic material.
* User's own phone number is partially redacted.
* Export includes a SHA-256 checksum.
* Export includes metadata with `exportedAt`, `userId`, `schema`, and a human-readable note.
* Admin can trigger an export via `POST /api/admin/data-export`.
* Admin-triggered exports create a `DataExportJob` row visible at `/admin/data-export`.
* Expired export jobs (past 7-day window) are anonymized by retention rule.
* Export endpoint requires authentication (401 for unauthenticated).
