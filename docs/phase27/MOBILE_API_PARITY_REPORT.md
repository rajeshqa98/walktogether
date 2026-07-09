# Mobile API Parity Report

**Phase:** 27C
**Status:** Complete — 40 API methods covering all beta flows
**Last updated:** 2026-07-06

## Overview

The Flutter API client (`lib/services/api_client.dart`) covers 40 API methods across all beta-critical backend endpoints. Every screen that needs backend data has a corresponding API method.

## API method audit

### Auth (5 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `requestOtp(phone)` | POST `/api/auth/otp/request` | LoginScreen |
| `verifyOtp(phone, code)` | POST `/api/auth/otp/verify` | AuthNotifier |
| `signInWithPhoneOtp(phone, otp)` | POST `/api/auth/callback/phone-otp` | AuthNotifier |
| `logout()` | POST `/api/auth/logout` | AuthNotifier |
| `hasSession()` | (secure storage check) | AuthNotifier.checkSession |

### User (2 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `getMe()` | GET `/api/me` | AuthNotifier |
| `updateMe(data)` | PATCH `/api/me` | ProfileSetup, Settings, Location |

### Nearby walkers (1 method) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `listNearbyWalkers({radius})` | GET `/api/walkers` | HomeScreen, WalkerDetail |

### Walk requests (3 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `listRequests()` | GET `/api/requests` | RequestsScreen, ChatScreen |
| `sendRequest(data)` | POST `/api/requests` | WalkerDetailScreen |
| `respondToRequest(id, status)` | PATCH `/api/requests/:id` | RequestsScreen |

### Sessions + safety (4 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `startSession(requestId)` | POST `/api/sessions` | ChatScreen |
| `getSession(id)` | GET `/api/sessions/:id` | WalkSession, PostWalk |
| `endSession(id)` | PATCH `/api/sessions/:id` | WalkSessionScreen |
| `triggerSos(sessionId)` | POST `/api/sessions/:id/sos` | WalkSessionScreen |
| `setSafetyShare(sessionId, enabled)` | POST `/api/sessions/:id/safety` | WalkSessionScreen |

### Reports + blocks (2 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `submitReport(data)` | POST `/api/reports` | PostWalkScreen |
| `blockUser(blockedId)` | POST `/api/blocks` | PostWalkScreen |

### Notifications (1 method) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `listNotifications()` | GET `/api/notifications` | NotificationsScreen |

### Group walks (5 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `listGroupWalks()` | GET `/api/group-walks` | GroupsScreen |
| `getGroupWalk(id)` | GET `/api/group-walks/:id` | GroupWalkDetailScreen |
| `joinGroupWalk(id)` | POST `/api/group-walks/:id/join` | GroupWalkDetailScreen |
| `leaveGroupWalk(id)` | POST `/api/group-walks/:id/leave` | GroupWalkDetailScreen |

### Clubs (4 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `listClubs()` | GET `/api/clubs` | ClubsScreen |
| `getClub(id)` | GET `/api/clubs/:id` | ClubDetailScreen |
| `joinClub(id)` | POST `/api/clubs/:id/join` | ClubDetailScreen |
| `leaveClub(id)` | POST `/api/clubs/:id/leave` | ClubDetailScreen |

### Feedback (1 method) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `submitFeedback({category, rating, message})` | POST `/api/feedback` | FeedbackScreen |

### Appeals (2 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `listMyAppeals()` | GET `/api/appeals` | AppealsScreen |
| `createAppeal({actionType, reason, explanation})` | POST `/api/appeals` | AppealsScreen |

### Privacy requests (3 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `listMyPrivacyRequests()` | GET `/api/privacy-requests` | PrivacyRequestsScreen |
| `createPrivacyRequest({requestType, details})` | POST `/api/privacy-requests` | PrivacyRequestsScreen |
| `cancelPrivacyRequest(id)` | PATCH `/api/privacy-requests` | (available for cancel flow) |

### Account deletion (3 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `getDeletionStatus()` | GET `/api/me/deletion` | AccountStatusScreen |
| `startAccountDeletion({reason})` | POST `/api/me/deletion` | SettingsScreen, PrivacyRequestsScreen |
| `cancelAccountDeletion()` | DELETE `/api/me/deletion` | AccountStatusScreen |

### Data export (1 method) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `exportMyData()` | GET `/api/me/export` | SettingsScreen, PrivacyRequestsScreen |

### Area + host (2 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `getArea()` | GET `/api/area` | (available for area screen) |
| `onboardHost(data)` | POST `/api/host/onboard` | (available for host onboarding) |

### Push subscriptions (2 methods) ✅

| Method | Endpoint | Used by |
|---|---|---|
| `savePushSubscription(data)` | POST `/api/me/push-subscription` | PushNotificationService |
| `removePushSubscription(endpoint)` | DELETE `/api/me/push-subscription` | PushNotificationService |

## Auth interceptor

Every API call goes through the Dio auth interceptor:

1. **On request:** reads `session_cookie` from `FlutterSecureStorage` and attaches it as `Cookie: next-auth.session-token=<cookie>`.
2. **On 401:** deletes `session_cookie` + `socket_token` from secure storage (forces re-login).

This means all 40 API methods automatically require authentication.

## API methods NOT exposed (admin-only)

The following admin endpoints are intentionally NOT in the mobile app (verified by security review):

- `/api/admin/reliability`, `/api/admin/slo`, `/api/admin/retention`
- `/api/admin/privacy-requests` (admin queue)
- `/api/admin/incidents`, `/api/admin/admin-access`
- `/api/admin/security-review`, `/api/admin/compliance-readiness`
- `/api/admin/backup-restore`, `/api/admin/data-export`
- All other `/api/admin/*` endpoints

**0 admin API calls** in the mobile app.

## Summary

- **40 API methods** implemented
- **All beta-critical flows covered:** auth, user, walkers, requests, sessions, safety (SOS + safety share), reports, blocks, groups, clubs, feedback, appeals, privacy, deletion, export
- **Auth interceptor** on every request
- **0 admin API calls** in mobile app
- **Environment-based base URL** (`String.fromEnvironment`)
