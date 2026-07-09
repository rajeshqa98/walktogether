# Security Review Report

**Phase:** 25
**Status:** Implemented
**Last updated:** 2026-07-06
**Owner:** SRE Lead + Security Lead
**Reviewed by:** Product Lead

## Overview

Phase 25 introduces an automated security review at `/admin/security-review` (backed by `GET /api/admin/security-review`) that runs 12 automated checks against the codebase and database. Each check returns `pass`, `fail`, or `warn`, with details, evidence, and recommendations. The review can be re-run at any time and is recommended before every deployment.

This document covers each check, what it looks for, and the current status.

## Checks performed

### 1. Admin APIs require admin role

**What it checks:** Every route file under `src/app/api/admin/*` must call `getCurrentAdmin()` or `requireAdmin()`. Files that don't are flagged.

**Why it matters:** Admin APIs expose sensitive operations (user suspension, ban, data export, audit log access). If any admin route is missing the role check, an unauthenticated user could perform admin actions.

**Current status:** Pass — all admin routes enforce admin role.

### 2. User APIs require authentication

**What it checks:** Every route file under `src/app/api/*` (excluding `/admin/*` and the intentionally-public `/health` and `/ready` routes) must use `withAuth`, `getCurrentUser`, or `getServerSession`.

**Why it matters:** User APIs expose personal data (profile, walks, chats). If any user route is missing the auth check, an unauthenticated user could read another user's data.

**Current status:** Pass with warnings — some routes may be intentionally public (e.g. invite link resolution). Each warning is reviewed manually.

### 3. Suspended/banned users remain blocked

**What it checks:** Counts users with `status: "suspended"` or `status: "banned"` who still have active `LivePresence` or `PushSubscription` rows. Any non-zero count is a warning.

**Why it matters:** A suspended/banned user should not appear in nearby results or receive push notifications. Stale presence or push rows indicate that the suspension workflow didn't fully revoke access.

**Current status:** Pass — no suspended/banned users have active presence or push subscriptions. (Retention rules clean these up automatically.)

### 4. Appeal APIs do not leak other user data

**What it checks:** The user-facing appeals route (`/api/appeals/route.ts`) must filter by `userId: user.id` (or equivalent). If the filter is missing, the route could return other users' appeals.

**Why it matters:** Appeals contain sensitive moderation information. A user should only see their own appeals, never another user's.

**Current status:** Pass — appeals route filters by authenticated user.

### 5. Trust score history is admin-only

**What it checks:** The admin trust-history route (`/api/admin/trust-history/route.ts`) must call `getCurrentAdmin()` or `requireAdmin()`.

**Why it matters:** Trust score history reveals moderation patterns and admin decision-making. Exposing it to non-admins would compromise the integrity of the trust system.

**Current status:** Pass — admin check is present.

### 6. Safety task data is admin-only

**What it checks:** The admin safety-tasks route (`/api/admin/safety-tasks/route.ts`) must call `getCurrentAdmin()` or `requireAdmin()`.

**Why it matters:** Safety tasks contain internal safety review work product. Exposing them to non-admins would reveal safety investigation patterns and could tip off bad actors.

**Current status:** Pass — admin check is present.

### 7. Exact location not exposed in normal APIs

**What it checks:** The walkers route (`/api/walkers/route.ts`) must not expose raw `lat`/`lng` of other users. The check verifies that the route uses `select` with appropriate field exclusion or computes coarse distance server-side.

**Why it matters:** Exact user coordinates are highly sensitive. WalkTogether's location privacy principle is that the API returns coarse distance (e.g. "500m away"), not exact coordinates. Exposing exact coordinates would enable stalking.

**Current status:** Pass — walkers route uses LivePresence for distance computation and returns coarse distance, not raw coordinates.

### 8. Push subscriptions belong to authenticated user

**What it checks:** The push subscription route (`/api/me/push-subscription/route.ts`) must filter by `userId: user.id` (or equivalent).

**Why it matters:** Push subscription endpoints are per-user. If a route doesn't filter by user, an authenticated user could read or delete another user's push subscriptions, enabling notification hijacking.

**Current status:** Pass — push subscription route filters by authenticated user.

### 9. Rate limiting works

**What it checks:** The rate limiter module (`/lib/rate-limiter.ts`) must export `checkRateLimit` or `rateLimit` functions.

**Why it matters:** Rate limiting protects against brute-force attacks on OTP, login, and chat endpoints. Without it, an attacker could spam OTP requests or brute-force login credentials.

**Current status:** Pass — rate limiter module is configured and exported.

### 10. OTP brute-force protection works

**What it checks:** The OTP verify route (`/api/auth/otp/verify/route.ts`) must track `attempts` and implement lockout after 5 failures (or use a configurable `maxAttempts`).

**Why it matters:** Without brute-force protection, an attacker who knows a phone number could try all 10,000 possible 4-digit OTPs until they hit the right one. OTP brute-force protection locks the OTP after 5 failed attempts.

**Current status:** Pass — OTP attempt tracking is present.

### 11. Service worker does not cache API responses

**What it checks:** The service worker file (`public/sw.js`) must have explicit handling for `/api/*` requests (NetworkOnly, bypass, or exclude from cache).

**Why it matters:** Caching API responses would mean users see stale data — including stale safety alerts, stale walk requests, and stale chat messages. For a safety-first app, this is unacceptable.

**Current status:** Pass — service worker has special handling for `/api/*` requests.

### 12. Admin export does not expose exact coordinates

**What it checks:** The admin export route (`/api/admin/export/route.ts`) must either exclude `lat`/`lng` fields, round them, or otherwise handle them appropriately.

**Why it matters:** Admin exports of user data are used for analytics and audits. If they contain exact user coordinates, that data could leak (e.g. via a stolen laptop, a misconfigured S3 bucket). Coordinates should be rounded to coarse precision or excluded entirely.

**Current status:** Pass — admin export route excludes or handles coordinates appropriately. (Manual verification recommended.)

## Running the review

The security review can be run:

1. **Via the admin UI:** Navigate to `/admin/security-review` and click "Re-run".
2. **Via the API:** `GET /api/admin/security-review` (admin-only).
3. **In CI (recommended):** Add a step to the deployment pipeline that calls the API and fails the deployment if any check returns `fail`.

## Review cadence

* **Pre-deployment:** Run before every production deployment.
* **Post-incident:** Run after any security incident to verify no new issues were introduced.
* **Quarterly:** Run as part of the quarterly security audit.
* **Ad-hoc:** Run any time a new admin route, user route, or export endpoint is added.

## What this review does NOT cover

This is an automated review focused on common misconfigurations. It does NOT cover:

* **Application logic vulnerabilities** — e.g. a route that correctly checks auth but exposes data it shouldn't.
* **Dependency vulnerabilities** — use `bun audit` or Dependabot for that.
* **Infrastructure vulnerabilities** — e.g. misconfigured S3 buckets, exposed Redis ports.
* **Social engineering** — e.g. an attacker convincing an admin to perform an action.
* **Insider threats** — e.g. a malicious admin with legitimate access.

For comprehensive security, pair this automated review with:

* Annual penetration test by a third party.
* Continuous dependency scanning.
* Infrastructure security scanning (e.g. AWS Security Hub).
* Admin access governance (Phase 25 `/admin/admin-access`).
* Incident response playbooks (Phase 25 `/admin/incidents`).

## Acceptance criteria

* All 12 checks return `pass` or `warn` (no `fail`).
* The review can be run via the admin UI.
* The review can be run via the API.
* Results include check name, description, status, details, evidence, and recommendation.
* Overall status is `pass` only if all checks pass; `warn` if any check warns; `fail` if any check fails.
* Review is admin-only (401 for unauthenticated, 403 for non-admin).
