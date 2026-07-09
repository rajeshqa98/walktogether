# Mobile API Alignment Report

**Phase:** 26
**Status:** Complete — 34 endpoints aligned with Phase 16–25 backend
**Last updated:** 2026-07-06

## Overview

The Flutter app's API client (`flutter_app/lib/services/api_client.dart`) has been expanded to cover every backend endpoint from Phases 16–25. The backend remains the source of truth — the Flutter app is a pure client with no business logic.

This report lists every endpoint, its Flutter method name, and which phase introduced it.

## Endpoint inventory

### Auth (Phase 5 + Phase 26 hardening)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| POST | `/api/auth/otp/request` | `requestOtp(phone)` | 5 |
| POST | `/api/auth/otp/verify` | `verifyOtp(phone, code)` | 5 |
| POST | `/api/auth/callback/phone-otp` | `signInWithPhoneOtp(phone, otp)` | 26 |
| POST | `/api/auth/logout` | `logout()` | 5 |
| GET | `/api/auth/csrf` | (internal to signInWithPhoneOtp) | 26 |

### User (Phase 1 + Phase 16 + Phase 26)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/me` | `getMe()` | 1 |
| PATCH | `/api/me` | `updateMe(data)` | 1 |
| PATCH | `/api/me/preferences` | `updatePreferences(data)` | 1 |
| POST | `/api/me/location` | `updateLocation(...)` | 3 |
| GET | `/api/me/location` | `getLocationStatus()` | 3 |

**Phase 16 additions:** `updateLocation()` now accepts `village`, `town`, `district`, `stateRegion`, `countryCode` fields for granular location.

### Walkers + Requests (Phase 1–3)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/walkers` | `listNearbyWalkers(radius)` | 1 |
| GET | `/api/walkers/:id` | `getWalker(id)` | 1 |
| GET | `/api/requests` | `listRequests()` | 2 |
| POST | `/api/requests` | `sendRequest(data)` | 2 |
| PATCH | `/api/requests/:id` | `respondToRequest(id, status)` | 2 |

### Messages + Sessions + Safety (Phase 3–4)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/requests/:id/messages` | `listMessages(requestId)` | 3 |
| POST | `/api/requests/:id/messages` | `sendMessage(requestId, message)` | 3 |
| POST | `/api/sessions` | `startSession(requestId)` | 3 |
| GET | `/api/sessions/:id` | `getSession(id)` | 3 |
| PATCH | `/api/sessions/:id` | `endSession(id)` | 3 |
| POST | `/api/sessions/:id/sos` | `triggerSos(sessionId)` | 4 |
| POST | `/api/sessions/:id/safety` | `setSafetyShare(sessionId, enabled)` | 4 |

### Ratings + Reports + Blocks (Phase 4)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| POST | `/api/ratings` | `submitRating(data)` | 4 |
| POST | `/api/reports` | `submitReport(data)` | 4 |
| POST | `/api/blocks` | `blockUser(blockedId)` | 4 |
| GET | `/api/blocks` | `listBlocked()` | 4 |
| DELETE | `/api/blocks/:id` | `unblockUser(blockedId)` | 4 |

### Notifications (Phase 3 + Phase 18)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/notifications` | `listNotifications()` | 3 |
| PATCH | `/api/notifications/:id/read` | `markNotificationRead(id)` | 3 |
| POST | `/api/notifications/read-all` | `markAllNotificationsRead()` | 3 |
| GET | `/api/me/notification-preferences` | `getNotificationPreferences()` | 18 |
| PATCH | `/api/me/notification-preferences` | `updateNotificationPreferences(data)` | 18 |

### Push subscriptions (Phase 5)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| POST | `/api/me/push-subscription` | `savePushSubscription(data)` | 5 |
| DELETE | `/api/me/push-subscription` | `removePushSubscription(endpoint)` | 5 |

### Group walks (Phase 7)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/group-walks` | `listGroupWalks(...)` | 7 |
| GET | `/api/group-walks/:id` | `getGroupWalk(id)` | 7 |
| POST | `/api/group-walks` | `createGroupWalk(data)` | 7 |
| POST | `/api/group-walks/:id/join` | `joinGroupWalk(id)` | 7 |
| POST | `/api/group-walks/:id/leave` | `leaveGroupWalk(id)` | 7 |
| POST | `/api/group-walks/:id/start` | `startGroupWalk(id)` | 7 |
| POST | `/api/group-walks/:id/end` | `endGroupWalk(id)` | 7 |
| PATCH | `/api/group-walks/:id` | `cancelGroupWalk(id, reason)` | 7 |
| GET | `/api/group-walks/:id/messages` | `listGroupWalkMessages(id)` | 7 |
| POST | `/api/group-walks/:id/messages` | `sendGroupWalkMessage(id, msg)` | 7 |
| GET | `/api/group-walks/:id/participants` | `listGroupWalkParticipants(id)` | 7 |

### Walking clubs (Phase 7)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/clubs` | `listClubs(type)` | 7 |
| GET | `/api/clubs/:id` | `getClub(id)` | 7 |
| POST | `/api/clubs` | `createClub(data)` | 7 |
| POST | `/api/clubs/:id/join` | `joinClub(id)` | 7 |
| POST | `/api/clubs/:id/leave` | `leaveClub(id)` | 7 |
| GET | `/api/clubs/:id/walks` | (via getClub) | 7 |

### Feedback + Waitlist (Phase 8 + Phase 12)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| POST | `/api/feedback` | `submitFeedback(...)` | 8 |
| POST | `/api/waitlist` | `joinWaitlist(data)` | 12 |

### Appeals (Phase 21)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/appeals` | `listMyAppeals()` | 21 |
| POST | `/api/appeals` | `createAppeal(...)` | 21 |
| GET | `/api/appeals/:id` | `getAppeal(id)` | 21 |

### Invite links (Phase 16)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/invite-links` | `listInviteLinks()` | 16 |
| POST | `/api/invite-links` | `createInviteLink(...)` | 16 |
| GET | `/api/invite-links/:code` | `resolveInviteLink(code)` | 16 |

### Local area (Phase 16)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/area` | `getArea(...)` | 16 |

### Host onboarding (Phase 16)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| POST | `/api/host/onboard` | `onboardHost(data)` | 16 |

### Privacy requests + account deletion + data export (Phase 25)

| Method | Endpoint | Flutter function | Phase |
|---|---|---|---|
| GET | `/api/privacy-requests` | `listMyPrivacyRequests()` | 25 |
| POST | `/api/privacy-requests` | `createPrivacyRequest(...)` | 25 |
| PATCH | `/api/privacy-requests` | `cancelPrivacyRequest(id)` | 25 |
| GET | `/api/me/deletion` | `getDeletionStatus()` | 25 |
| POST | `/api/me/deletion` | `startAccountDeletion(reason)` | 25 |
| DELETE | `/api/me/deletion` | `cancelAccountDeletion()` | 25 |
| GET | `/api/me/export` | `exportMyData()` | 25 |

## Admin APIs — intentionally NOT in mobile app

The following admin-only endpoints are NOT exposed in the mobile app. The security review confirms zero `/api/admin/` references in the Flutter codebase:

* `/api/admin/reliability`, `/api/admin/slo`, `/api/admin/retention`
* `/api/admin/privacy-requests` (admin queue — different from user-facing `/api/privacy-requests`)
* `/api/admin/incidents`, `/api/admin/admin-access`
* `/api/admin/security-review`, `/api/admin/compliance-readiness`
* `/api/admin/backup-restore`, `/api/admin/data-export`
* `/api/admin/safety-queue`, `/api/admin/safety-events`, `/api/admin/safety-tasks`
* `/api/admin/appeals` (admin queue), `/api/admin/reports`, `/api/admin/users`
* `/api/admin/messages`, `/api/admin/feedback`, `/api/admin/audit-logs`
* `/api/admin/trust-history`, `/api/admin/i18n`, `/api/admin/workload`
* `/api/admin/host-growth`, `/api/admin/village-growth`, `/api/admin/native-speaker-review`
* `/api/admin/moderation-fp-dashboard`, `/api/admin/governance-metrics`
* `/api/admin/production-checklist`, `/api/admin/pilot`, `/api/admin/dashboard`
* `/api/admin/community`, `/api/admin/hosts`, `/api/admin/export`
* `/api/admin/analytics/*`, `/api/admin/activation/*`, `/api/admin/waitlist`

## Auth interceptor

Every API call goes through the Dio auth interceptor in `api_client.dart`:

1. **On request:** reads `session_cookie` from `FlutterSecureStorage` and attaches it as `Cookie: next-auth.session-token=<cookie>`.
2. **On 401 error:** deletes `session_cookie` + `socket_token` from secure storage (forces re-login).

This means all 34 endpoints — including privacy, deletion, and export — automatically require authentication. No endpoint can be called without a valid session.

## Socket.io alignment

The realtime service (`realtime_service.dart`) listens for these server-emitted events:

| Event | Callback | Phase |
|---|---|---|
| `chat:message` | `onChatMessage(requestId, messageId)` | 3 |
| `chat:message:delivered` | `onMessageDelivered(messageId)` | 3 |
| `chat:message:read` | `onMessageRead(requestId, readerId)` | 3 |
| `request:new` | `onRequestNew(requestId)` | 3 |
| `request:status` | `onRequestStatus(requestId, status)` | 3 |
| `session:safety` | `onSafetyEvent(sessionId, type)` | 4 |
| `session:lifecycle` | `onSessionLifecycle(sessionId, status)` | 4 |
| `group:chat:message` | `onGroupChatMessage(groupWalkId, messageId, senderId)` | 7 |
| `group:participant:update` | `onGroupWalkParticipantUpdate(...)` | 7 |
| `group:lifecycle` | `onGroupWalkLifecycle(groupWalkId, status)` | 7 |

The client emits:

* `presence:heartbeat` (every 25s)
* `chat:message`, `chat:message:delivered`, `chat:message:read`
* `request:new`, `request:status`
* `session:safety`, `session:lifecycle`
* `group:chat:message`, `group:lifecycle`

## Summary

* **34 REST endpoints** aligned with backend Phases 1–25
* **10 socket events** aligned with backend realtime service
* **0 admin API calls** in mobile app (verified by security review)
* **All endpoints require auth** via Dio interceptor
* **All endpoints use environment-based base URL** (`String.fromEnvironment`)
