# Mobile Push + Realtime QA

**Phase:** 26
**Status:** Implemented; live testing requires physical device + FCM project
**Last updated:** 2026-07-06
**Owner:** Mobile Lead + SRE Lead

## Overview

WalkTogether uses Firebase Cloud Messaging (FCM) for push notifications and Socket.io for realtime communication. This document covers the push notification flow, realtime socket flow, and QA checklist for both.

## Push notifications

### Architecture

1. **App startup:** `main.dart` calls `PushNotificationService().setupForegroundHandler()` (wrapped in try/catch so Firebase misconfiguration doesn't crash the app).
2. **Permission:** `requestPermission()` is called ONLY after the user taps "Enable push" in Settings. The prompt is NOT shown on app launch.
3. **Token:** `FirebaseMessaging.instance.getToken()` returns the FCM token. The token is registered with the backend via `POST /api/me/push-subscription` with `endpoint: 'fcm://$token'`.
4. **Token refresh:** `_fcm.onTokenRefresh.listen()` re-registers the new token with the backend.
5. **Foreground messages:** `FirebaseMessaging.onMessage.listen()` shows a local notification via `flutter_local_notifications`.
6. **Background messages:** `FirebaseMessaging.onMessageOpenedApp.listen()` handles notification taps when the app is in background.
7. **Terminated:** `FirebaseMessaging.instance.getInitialMessage()` handles notification taps when the app was killed.
8. **Logout:** `PushNotificationService().unregister()` calls `DELETE /api/me/push-subscription?endpoint=fcm://$token` then clears the local token.

### Notification channels (Android)

Two channels are created in `initLocalNotifications()`:

| Channel ID | Name | Importance | Use |
|---|---|---|---|
| `walktogether_notifications` | WalkTogether notifications | Default | Walk requests, chat, group updates |
| `walktogether_safety` | Safety alerts | High | SOS, safety share, critical safety events |

Safety alerts use high importance + high priority + vibration pattern to ensure they're delivered promptly even in Doze mode.

### Notification types

| Type | Channel | Title | Body | Tap action |
|---|---|---|---|---|
| `new_walk_request` | default | "New walk request" | "{name} wants to walk with you" | Navigate to /requests |
| `request_accepted` | default | "Request accepted" | "{name} accepted your walk request" | Navigate to /chat/{requestId} |
| `request_declined` | default | "Request declined" | "{name} declined your walk request" | Navigate to /requests |
| `new_chat_message` | default | "{name}" | "{message preview}" | Navigate to /chat/{requestId} |
| `group_message` | default | "{group name}" | "{name}: {message}" | Navigate to /group-chat/{id} |
| `walk_started` | default | "Walk started" | "Your walk with {name} has started" | Navigate to /walk-session/{id} |
| `walk_ended` | default | "Walk ended" | "Your walk has ended. Rate your experience." | Navigate to /post-walk/{id} |
| `sos_triggered` | safety | "SOS triggered" | "{name} triggered SOS during your walk" | Navigate to /walk-session/{id} |
| `safety_share_activated` | safety | "Safety share on" | "{name} activated safety share" | Navigate to /walk-session/{id} |

### Notification tap navigation

The `PushNotificationService` uses a `StreamController<String>` (`_navigationSink`) that the router subscribes to. When a notification is tapped:

1. `_handleNotificationTap(data)` reads `data['url']` (e.g. `"/requests"`, `"/chat/clxxx..."`)
2. Pushes the URL to `_navigationSink`
3. The router's listener calls `context.go(url)` or `context.push(url)`

This decouples the push service from the router, avoiding circular dependencies.

### Disabled notification preferences

The backend respects notification preferences set via `PATCH /api/me/notification-preferences`:

- `pushEnabled` (master switch)
- `walkRequestPush` (walk request notifications)
- `chatMessagePush` (chat message notifications)
- **Safety alerts ALWAYS sent** — cannot be disabled (server-side enforcement)

If `pushEnabled` is false, the backend does not send any pushes (including safety). If `pushEnabled` is true but `chatMessagePush` is false, chat pushes are suppressed but safety pushes are still sent.

### QA checklist — push notifications

- [ ] Permission prompt appears ONLY after tapping "Enable push" in Settings
- [ ] If user denies permission, no crashes; Settings shows "Permission denied"
- [ ] After granting permission, FCM token is registered with backend
- [ ] Walk request notification appears when another user sends a request
- [ ] Chat message notification appears when a matched user sends a message
- [ ] Group message notification appears when a group member sends a message
- [ ] SOS notification appears with high priority + vibration
- [ ] Tapping a notification navigates to the correct screen
- [ ] Tapping a notification when app is killed opens the app + navigates
- [ ] Disabling push in Settings stops all non-safety notifications
- [ ] Safety alerts are always delivered (cannot be disabled)
- [ ] On logout, FCM token is removed from backend
- [ ] On re-login with same account, token is re-registered
- [ ] On switching accounts (same device), old token is removed + new one registered

## Realtime (Socket.io)

### Architecture

1. **Connect:** `RealtimeService.connect()` reads `socket_token` from secure storage, connects to `AppConfig.socketUrl/?XTransformPort=3003` with `setAuth({'token': sessionToken})`.
2. **Transports:** `['websocket', 'polling']` — tries WebSocket first, falls back to HTTP polling.
3. **Heartbeat:** every 25 seconds, emits `presence:heartbeat` to keep the connection alive.
4. **Reconnection:** `enableReconnection()` — auto-reconnects with exponential backoff.
5. **Disconnect:** `disconnect()` cancels the heartbeat timer, disconnects the socket, disposes it.

### Events listened for

| Event | Callback | Triggered when |
|---|---|---|
| `chat:message` | `onChatMessage(requestId, messageId)` | Partner sends a chat message |
| `chat:message:delivered` | `onMessageDelivered(messageId)` | Partner's device receives the message |
| `chat:message:read` | `onMessageRead(requestId, readerId)` | Partner reads the message |
| `request:new` | `onRequestNew(requestId)` | Someone sends a walk request to you |
| `request:status` | `onRequestStatus(requestId, status)` | Walk request accepted/declined |
| `session:safety` | `onSafetyEvent(sessionId, type)` | SOS triggered or safety share toggled |
| `session:lifecycle` | `onSessionLifecycle(sessionId, status)` | Walk session started/ended |
| `group:chat:message` | `onGroupChatMessage(groupWalkId, messageId, senderId)` | Group walk chat message |
| `group:participant:update` | `onGroupWalkParticipantUpdate(...)` | Someone joins/leaves a group walk |
| `group:lifecycle` | `onGroupWalkLifecycle(groupWalkId, status)` | Group walk started/ended/cancelled |

### Events emitted

| Event | When |
|---|---|
| `presence:heartbeat` | Every 25 seconds (heartbeat) |
| `chat:message` | When sending a chat message (after server confirm) |
| `chat:message:delivered` | When a received message is marked delivered |
| `chat:message:read` | When a received message is marked read |
| `request:new` | When sending a walk request (notifies receiver) |
| `request:status` | When accepting/declining a walk request |
| `session:safety` | When triggering SOS or toggling safety share |
| `session:lifecycle` | When starting/ending a walk session |
| `group:chat:message` | When sending a group chat message |
| `group:lifecycle` | When starting/ending a group walk |

### Reconnection behavior

- **Auto-reconnect:** enabled via `enableReconnection()`
- **Initial delay:** 1 second
- **Backoff:** exponential (socket.io default)
- **Max delay:** 5 seconds
- **Max attempts:** unlimited

On reconnect:
1. `onConnect` fires → `_connected = true` → `onConnectionChange?.call(true)`
2. Heartbeat timer restarts
3. The app should re-fetch any missed messages via REST API (the server doesn't replay missed socket events)

**Known limitation:** V1.7 does NOT replay missed events on reconnect. If a chat message was sent while the user was disconnected, it won't appear until the user manually refreshes. Planned fix: V1.8 will re-fetch messages with `?since=lastReceivedAt` on reconnect.

### Fallback polling

If WebSocket transport fails (e.g. corporate firewall blocks ws://), socket.io automatically falls back to HTTP polling. This is slower (higher latency) but works through most firewalls.

**Polling interval:** 2-5 seconds (socket.io default, adaptive).

### Duplicate message prevention

The server includes a unique `messageId` in every `chat:message` event. The chat screen should track displayed message IDs and ignore duplicates. This is handled in `chat_screen.dart` via a `Set<String> displayedMessageIds`.

**Known limitation:** V1.7's duplicate prevention is best-effort. If the same message arrives via socket AND a REST fetch, it may appear twice. Planned fix: V1.8 will use a proper deduplication cache.

### QA checklist — realtime

- [ ] Socket connects on login
- [ ] Socket disconnects on logout
- [ ] Chat messages arrive in real-time (< 1 second)
- [ ] Walk request notifications arrive in real-time
- [ ] Request status updates (accept/decline) arrive in real-time
- [ ] SOS event is received by the partner in real-time
- [ ] Safety share toggle is received by the partner in real-time
- [ ] Walk session lifecycle (start/end) is received by the partner
- [ ] Group chat messages arrive in real-time
- [ ] Group participant join/leave updates in real-time
- [ ] Socket reconnects within 5 seconds after network restoration
- [ ] Socket falls back to polling when WebSocket is blocked
- [ ] No duplicate chat messages (deduplication works)
- [ ] No stale state after reconnect (UI reflects current state)
- [ ] Heartbeat keeps connection alive during long idle periods

## Offline + error states

### No internet

- Home screen shows "No internet connection" banner
- API calls fail with `DioExceptionType.connectionError`
- Socket disconnects; reconnect attempts deferred
- Cached data (if any) is shown with a "stale" indicator
- User can still view previously-loaded screens

### API unavailable (5xx)

- API calls fail with `DioExceptionType.badResponse`
- Error message shown: "Something went wrong. Please try again."
- Retry button on error states

### Session expired (401)

- Dio interceptor detects 401 response
- Clears `session_cookie` + `socket_token` from secure storage
- Router redirects to `/login`
- User sees "Your session has expired. Please log in again."

### Socket disconnected

- `onConnectionChange?.call(false)` fires
- Chat screen shows "Reconnecting…" indicator
- Messages can still be sent (queued for delivery on reconnect)
- User can manually retry by pulling to refresh

### Account suspended/banned

- `AuthState.fromUser()` sets `gate = AccountGate.suspended` or `banned`
- Router redirects to `/account-status`
- Account status screen shows clear message + appeal link

### Deletion pending

- `AuthState.fromUser()` sets `gate = AccountGate.deletionPending`
- Router redirects to `/account-status`
- Account status screen shows grace period end date + cancel button

## Acceptance criteria

- [x] FCM permission prompt only after user action
- [x] Token registration with backend
- [x] Token removal on logout
- [x] Local notification display for foreground messages
- [x] Two notification channels (default + safety)
- [x] Notification tap navigation
- [x] Disabled notification preferences respected (server-side)
- [x] Socket auth via secure storage token
- [x] Socket auto-reconnect with backoff
- [x] Fallback to HTTP polling
- [x] Duplicate message prevention (best-effort)
- [x] Offline + error states implemented
- [ ] Missed event replay on reconnect (planned V1.8)
- [ ] Proper deduplication cache (planned V1.8)
