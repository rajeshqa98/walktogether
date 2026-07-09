# Firebase Production Setup

**Phase:** 28
**Status:** Ready to execute
**Last updated:** 2026-07-06
**Owner:** Mobile Lead + SRE Lead

## Overview

The WalkTogether Flutter app uses Firebase Cloud Messaging (FCM) for push notifications. This document covers creating a Firebase project, configuring the Android app, downloading the real `google-services.json`, and verifying FCM works.

**The placeholder `google-services.json` in the repo must be replaced with the real file before beta.**

## Step 1: Create a Firebase project

1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Project name: `walktogether-prod` (or your preferred name)
4. Google Analytics: Enable (recommended for crash tracking)
5. Default GCP resource location: Choose your region
6. Click "Create project"

## Step 2: Add an Android app

1. In Firebase Console, click the Android icon ("Add app")
2. **Android package name:** `com.walktogether.app` (must match `applicationId` in `build.gradle`)
3. **App nickname:** WalkTogether (optional)
4. **Debug signing certificate SHA-1:** Optional but recommended for Google Sign-In + Dynamic Links
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep SHA1
   ```
5. Click "Register app"

## Step 3: Download `google-services.json`

1. Firebase Console will prompt you to download `google-services.json`
2. **Download it**
3. Replace the placeholder file at `flutter_app/android/app/google-services.json`
4. **Do NOT commit this file** — `.gitignore` already excludes it

**Verify the file is not committed:**
```bash
git status flutter_app/android/app/google-services.json
# Should show: "nothing to commit" or "not staged" but NOT "tracked"
```

## Step 4: Enable Firebase Cloud Messaging (FCM)

FCM is enabled by default when you add the Firebase Messaging dependency. Verify:

1. In Firebase Console → your project → Engagement → Cloud Messaging
2. You should see "Cloud Messaging API (V1)" is enabled
3. If you see "Legacy API (server key)" — that's deprecated, use V1

**For server-side FCM sending:**
1. Firebase Console → Project Settings → Cloud Messaging
2. Copy the "Server key" (for legacy API) or set up a service account (for V1 API)
3. Add the key to your backend's `.env`:
   ```
   FIREBASE_PROJECT_ID=walktogether-prod
   FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxx@walktogether-prod.iam.gserviceaccount.com
   FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
   ```

## Step 5: Verify FCM token generation

1. Build + install the app on a device:
   ```bash
   cd flutter_app
   flutter run --release
   ```
2. Log in + go to Settings → "Enable push"
3. Grant notification permission
4. The app should call `FirebaseMessaging.instance.getToken()` and register with backend
5. Verify in backend logs that the push subscription was created:
   ```
   push_subscription saved: fcm://token123...
   ```

## Step 6: Verify notification permission (Android 13+)

On Android 13+ (API 33+), the app must request `POST_NOTIFICATIONS` permission:

1. Install the app on an Android 13+ device
2. Go to Settings → "Enable push"
3. The system permission dialog should appear
4. Grant permission
5. Verify the app can receive push notifications

**If permission is denied:**
- The app should show "Permission denied. Enable in settings."
- The user can grant permission from Android Settings → Apps → WalkTogether → Notifications

## Step 7: Verify push notification delivery

**Test push delivery:**

1. Use Firebase Console → Cloud Messaging → "New notification"
2. Compose a test notification:
   - Title: "Test push"
   - Text: "This is a test notification from WalkTogether"
3. Send to a specific device (by FCM token) or all devices
4. Verify the notification appears on the device:
   - **App in foreground:** local notification displayed via `flutter_local_notifications`
   - **App in background:** system notification displayed by FCM
   - **App killed:** system notification displayed by FCM

**Test safety alert push:**

1. Trigger an SOS from a test walk session
2. Verify the safety contact receives a push notification with high priority
3. Verify the notification uses the `walktogether_safety` channel (vibration pattern)

## Step 8: Configure notification channels

The app creates two Android notification channels:

| Channel ID | Name | Priority | Use |
|---|---|---|---|
| `walktogether_notifications` | WalkTogether notifications | Default | Walk requests, chat, group updates |
| `walktogether_safety` | Safety alerts | High | SOS, safety share, critical safety events |

These are created in `PushNotificationService.initLocalNotifications()`.

## Step 9: Verify notification tap navigation

1. Send a test push with data payload:
   ```json
   {
     "notification": { "title": "New walk request", "body": "Alice wants to walk with you" },
     "data": { "url": "/requests", "type": "new_walk_request" }
   }
   ```
2. Tap the notification
3. The app should open and navigate to `/requests`

## Step 10: Set up Firebase Crashlytics (recommended)

1. In Firebase Console → Crashlytics → Get started
2. Add the Crashlytics dependency to `pubspec.yaml`:
   ```yaml
   firebase_crashlytics: ^4.0.0
   ```
3. Initialize Crashlytics in `main.dart`:
   ```dart
   await Firebase.initializeApp();
   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
   ```
4. Crash reports will appear in Firebase Console → Crashlytics

## Security checklist

- [ ] `google-services.json` downloaded and placed in `flutter_app/android/app/`
- [ ] `google-services.json` NOT committed to repo (`.gitignore` protects it)
- [ ] FCM enabled in Firebase Console
- [ ] FCM token generation verified on device
- [ ] Notification permission works on Android 13+
- [ ] Push notification delivery verified (foreground + background + killed)
- [ ] Safety alert push uses high-priority channel
- [ ] Notification tap navigation works
- [ ] Backend has FCM service account credentials in `.env` (not committed)

## Troubleshooting

### "FirebaseApp initialization failed"

**Cause:** `google-services.json` is missing or has wrong package name.

**Fix:**
1. Verify `flutter_app/android/app/google-services.json` exists
2. Open it and verify `package_name` is `com.walktogether.app`
3. Run `flutter clean && flutter pub get`
4. Rebuild

### "No FCM token received"

**Cause:** Notification permission denied or Firebase misconfigured.

**Fix:**
1. Verify notification permission is granted (Android Settings → Apps → WalkTogether → Notifications)
2. Check Firebase Console → Cloud Messaging is enabled
3. Check device has internet connection
4. Check `FirebaseMessaging.instance.getToken()` returns non-null in app logs

### "Push notifications not received in background"

**Cause:** Battery optimization killing the app, or FCM message priority too low.

**Fix:**
1. Set message priority to "high" in FCM payload
2. Add `priority: "high"` to the data payload
3. On some Android devices (Xiaomi, Huawei), disable battery optimization for WalkTogether
