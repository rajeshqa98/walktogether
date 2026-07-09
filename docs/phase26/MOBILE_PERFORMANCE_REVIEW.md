# Mobile Performance Review

**Phase:** 26
**Status:** Documented (live measurement requires physical device + Flutter profiling tools)
**Last updated:** 2026-07-06
**Owner:** Mobile Lead

## Overview

This document covers the expected performance characteristics of the WalkTogether Flutter app, the tools used to measure them, and the targets for each metric. Live measurements require a physical device with Flutter profiling tools (`flutter run --profile`), which is not available in this environment.

## Performance targets

| Metric | Target | How to measure |
|---|---|---|
| App cold start | < 2 seconds | `flutter run --trace-startup --profile` |
| Home screen load | < 1 second | Manual stopwatch from navigation to first walker card visible |
| Nearby walkers API latency | < 1.5s p95 (backend SLO) | Backend SLO dashboard |
| Chat send latency | < 500ms (optimistic) + < 2s (server confirm) | Manual stopwatch |
| Group list load | < 1 second | Manual stopwatch |
| Memory usage | < 150 MB active | `flutter run --profile` + DevTools Memory tab |
| Battery impact (1h active walk) | < 5% | Physical device test |
| Location refresh frequency | Every 60 seconds (configurable) | App settings |
| Socket reconnect time | < 5 seconds | Network throttling test |
| Push notification delivery | < 10 seconds (FCM) | FCM dashboard |

## Cold start optimization

The app's cold start path is:

1. `main()` → `WidgetsFlutterBinding.ensureInitialized()` (~50ms)
2. `Firebase.initializeApp()` (~200ms — wrapped in try/catch so failures don't block)
3. `AppI18n.init()` — loads language from SharedPreferences (~10ms)
4. `runApp(ProviderScope(child: WalkTogetherApp()))` (~100ms)
5. `MaterialApp.router` builds (~100ms)
6. Router redirect checks `authStateProvider` → `checkSession()` → reads secure storage (~50ms)
7. If session exists → `getMe()` API call (~300-500ms depending on network)
8. Home screen renders with nearby walkers (~500ms after `getMe()`)

**Total cold start: ~1.3-2.0 seconds** depending on network latency for `getMe()`.

**Optimizations applied:**
- Firebase init is wrapped in try/catch so it doesn't block app startup if Firebase is misconfigured.
- i18n init uses SharedPreferences (fast) rather than loading JSON from assets.
- Router redirect is non-blocking during loading state (`if (isLoading) return null`).
- Nearby walkers list loads lazily after home screen renders.

## Home screen load

The home screen (`home_screen.dart`) loads nearby walkers via `nearbyWalkersProvider`. The provider:

1. Calls `ApiClient.listNearbyWalkers(radius: 500)` — GET `/api/walkers?radius=500`
2. Backend does a geospatial query (PostGIS `ST_DWithin` or haversine fallback)
3. Returns a list of walker cards (name, age range, distance, trust score, verification status)

**Expected latency:** 200-800ms depending on backend load + DB query speed. The backend SLO for nearby search p95 is < 1.5s.

**Optimization:** The home screen shows a `CircularProgressIndicator` while loading. No skeleton screens are used in V1.7 (planned for V1.8).

## Chat send latency

Chat sends use an optimistic UI pattern:

1. User types message + taps send
2. Message appears in chat list immediately (optimistic)
3. `ApiClient.sendMessage(requestId, message)` fires in background
4. On success: message marked as sent (checkmark)
5. On failure: message marked as failed (red icon) + retry button

**Expected latency:** < 500ms for optimistic display, < 2s for server confirmation.

**Realtime delivery:** The recipient receives the message via socket.io (`chat:message` event) typically within 500ms of the server confirmation.

## Memory usage

Flutter apps typically use 80-150 MB of RAM. WalkTogether's memory profile:

- **Flutter framework + Material:** ~40 MB
- **App code + Riverpod state:** ~20 MB
- **Image cache (cached_network_image):** up to 50 MB (configurable)
- **Socket.io client:** ~5 MB
- **Firebase + FCM:** ~15 MB
- **Location + geolocator:** ~5 MB

**Expected total:** 80-150 MB active.

**Optimizations:**
- `cached_network_image` is configured with a max cache size of 50 MB (default).
- Profile photos are loaded lazily and cached.
- Socket.io disconnects on logout to free memory.

## Battery impact

The biggest battery drains in a walking app are:

1. **GPS location updates** — WalkTogether uses `LocationAccuracy.medium` (not `high`) to reduce GPS power draw. Location is refreshed every 60 seconds during an active walk (configurable in settings).
2. **Socket.io connection** — kept alive with a 25-second heartbeat. On iOS, `UIBackgroundModes` includes `fetch` + `remote-notification` only (no `location` background mode).
3. **Push notifications** — FCM uses APNs which is highly optimized by iOS/Android.
4. **Screen brightness** — the app uses Material's default light theme. No dark mode in V1.7 (planned for V1.8).

**Expected battery impact for 1 hour of active walking:** < 5% on a modern device (iPhone 12 / Pixel 5 or newer).

## Location refresh frequency

- **Active walk session:** every 60 seconds (configurable in `WalkSessionScreen`)
- **Home screen (nearby walkers):** on screen load + manual refresh button
- **Background:** never (no background location permission)

The 60-second interval during active walks is a privacy + battery compromise. More frequent updates would drain battery faster; less frequent would make safety-share less accurate.

## Socket reconnect performance

Socket.io is configured with:
- `enableAutoConnect()` — connects automatically on `connect()` call
- `enableReconnection()` — retries on disconnect
- Default reconnection delay: 1s initial, exponential backoff (max 5s)

**Expected reconnect time:** < 5 seconds after network restoration.

**Fallback:** If WebSocket transport fails, socket.io falls back to HTTP polling (slower but works through more firewalls). Transports are set to `['websocket', 'polling']`.

## Push notification delivery

FCM delivery time depends on:
- **Android (FCM):** typically < 5 seconds
- **iOS (APNs):** typically < 10 seconds (high-priority pushes are faster)

**Safety alerts** use the `walktogether_safety` channel with `Importance.highImportance` + `Priority.highPriority` + vibration pattern. This ensures SOS alerts are delivered promptly even in Doze mode (Android) or Low Power Mode (iOS).

## Profiling tools

To measure performance on a physical device:

```bash
# Profile mode build (faster than debug, with DevTools support)
flutter run --profile

# Open DevTools in browser
flutter pub global activate devtools
flutter pub global run devtools

# Trace startup
flutter run --trace-startup --profile
# Output: {"startAppName": ..., "firstFrameRasterized": ...}

# Memory + CPU profiling via DevTools
# Open the DevTools URL in Chrome, connect to the running app
```

## Known performance limitations (V1.7)

1. **No image lazy loading on home screen** — all walker cards load their profile photos at once. For areas with 50+ nearby walkers, this can cause jank. Planned fix: V1.8 will use `ListView.builder` with `cacheExtent`.

2. **No skeleton screens** — loading states show spinners. Skeleton screens would feel faster. Planned fix: V1.8.

3. **No request caching** — if the user goes offline, all API calls fail. Planned fix: V1.8 will add `dio_cache_interceptor` for GET caching.

4. **No background sync** — if the user is offline when a chat message is sent, the message is lost. Planned fix: V1.8 will queue messages for later delivery.

5. **No dark mode** — the app uses Material's light theme only. Dark mode reduces battery on OLED screens. Planned fix: V1.8.

## Acceptance criteria

- [ ] App cold start < 2 seconds (measured on mid-range Android device)
- [ ] Home screen load < 1 second after `getMe()` returns
- [ ] Chat send optimistic display < 500ms
- [ ] Memory usage < 150 MB during active walk
- [ ] Battery impact < 5% for 1 hour active walk
- [ ] Socket reconnect < 5 seconds after network restoration
- [ ] Push delivery < 10 seconds
- [ ] No jank (60 FPS) during scroll on home + group + chat screens
