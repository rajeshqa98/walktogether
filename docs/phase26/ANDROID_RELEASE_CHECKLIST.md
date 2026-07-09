# Android Release Checklist

**Phase:** 26
**Status:** Ready for internal testing build
**Last updated:** 2026-07-06
**Package name:** `com.walktogether.app`
**Version:** 1.7.0 (versionCode 26)

## Pre-build checklist

### App identity

- [x] **Package name:** `com.walktogether.app` (set in `build.gradle.kts` → `applicationId` + `namespace`)
- [x] **App name:** "WalkTogether" (set in AndroidManifest.xml → `android:label`)
- [x] **Version code:** 26 (set in `build.gradle.kts` → `versionCode`)
- [x] **Version name:** "1.7.0" (set in `build.gradle.kts` → `versionName`)
- [x] **Min SDK:** 23 (Android 6.0 — covers 99%+ of devices)
- [x] **Target SDK:** 34 (Android 14 — required for Play Store 2024)

### App icon

- [x] **Launcher icon:** `@mipmap/ic_launcher` referenced in AndroidManifest.xml
- [ ] **Final icon assets:** The `mipmap-*` directories exist but are empty. Generate final icons using:
  ```bash
  # Install flutter_launcher_icons (add to pubspec dev_deps if not present)
  flutter pub run flutter_launcher_icons:main
  ```
  Configure `flutter_launcher_icons` in `pubspec.yaml`:
  ```yaml
  flutter_launcher_icons:
    android: true
    ios: true
    image_path: "assets/icons/icon.png"
    min_sdk_android: 23
  ```

### Splash screen

- [x] **Launch theme:** `@style/LaunchTheme` (defined in `res/values/styles.xml`)
- [x] **Normal theme:** `@style/NormalTheme`
- [x] **Launch background:** `@drawable/launch_background` (white background)

### Permissions

- [x] `ACCESS_FINE_LOCATION` (foreground location for nearby matching)
- [x] `ACCESS_COARSE_LOCATION` (approximate location fallback)
- [x] `POST_NOTIFICATIONS` (Android 13+ notification permission)
- [x] `INTERNET` (API calls)
- [x] `ACCESS_NETWORK_STATE` (offline detection)
- [x] `WAKE_LOCK` (FCM background messages)
- [x] `RECEIVE_BOOT_COMPLETED` (FCM bootstrap)
- [x] `VIBRATE` (SOS alert vibration)
- [x] `FOREGROUND_SERVICE` (safety-share during active walk)
- [x] `FOREGROUND_SERVICE_LOCATION` (location foreground service type)

**Not requested:**
- `ACCESS_BACKGROUND_LOCATION` — WalkTogether does not track users in the background
- `READ_CONTACTS` — not needed
- `CAMERA` — handled at runtime for selfie verification (Phase 4)
- `READ_EXTERNAL_STORAGE` — not needed (no file uploads in this phase)

### Network security

- [x] `usesCleartextTraffic="false"` in AndroidManifest.xml
- [x] `network_security_config.xml` present at `res/xml/`
- [x] Base config disallows cleartext (HTTPS only)
- [x] Dev-only exception for `10.0.2.2` + `localhost` (Android emulator / local testing)

### Firebase config

- [x] `google-services.json` placeholder file present at `android/app/`
- [ ] **Replace with real config** before release:
  1. Go to https://console.firebase.google.com/
  2. Create/select WalkTogether Firebase project
  3. Add Android app → package name `com.walktogether.app`
  4. Download `google-services.json`
  5. Replace `flutter_app/android/app/google-services.json`
- [x] `com.google.gms.google-services` plugin applied in `build.gradle.kts`
- [x] FCM notification channel meta-data in AndroidManifest:
  - `walktogether_notifications` (default channel)
  - `walktogether_safety` (high-priority SOS channel)
- [x] Default notification color meta-data (`#4F46E5`)

### ProGuard / R8

- [x] `isMinifyEnabled = true` + `isShrinkResources = true` in release build type
- [x] `proguard-rules.pro` present with keep rules for:
  - Flutter (`io.flutter.**`)
  - Firebase (`com.google.firebase.**`)
  - Socket.io (`io.socket.**`)
  - Geolocator/Geocoding (`com.baseflow.**`)
  - Secure Storage (`com.it_nomads.fluttersecurestorage.**`)

### Demo login gating

- [x] `DEMO_LOGIN=false` resValue in release build type
- [x] Login screen checks `AppConfig.demoLoginEnabled && !AppConfig.isReleaseBuild` before showing demo button
- [x] Build command passes `--dart-define=DEMO_LOGIN=false` explicitly

## Build commands

### Debug build (for local testing)

```bash
cd /home/z/my-project/flutter_app
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Release APK (for direct installation on test devices)

```bash
cd /home/z/my-project/flutter_app
flutter build apk --release \
    --dart-define=API_BASE_URL=https://api.walktogether.app \
    --dart-define=SOCKET_URL=https://socket.walktogether.app \
    --dart-define=DEMO_LOGIN=false
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Release App Bundle (for Play Store)

```bash
cd /home/z/my-project/flutter_app
flutter build appbundle --release \
    --dart-define=API_BASE_URL=https://api.walktogether.app \
    --dart-define=SOCKET_URL=https://socket.walktogether.app \
    --dart-define=DEMO_LOGIN=false
# Output: build/app/outputs/bundle/release/app-release.aab
```

Or use the build script:
```bash
export API_BASE_URL=https://api.walktogether.app
export SOCKET_URL=https://socket.walktogether.app
bash /home/z/my-project/scripts/phase26/build_android_release.sh
```

## Release signing

### Generate a release keystore (one-time)

```bash
keytool -genkey -v \
    -keystore walktogether.keystore \
    -alias walktogether \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass YOUR_STORE_PASSWORD \
    -keypass YOUR_KEY_PASSWORD
```

Store the keystore file in a secure location (NOT in the repo). Back it up — if you lose it, you cannot update the app on Play Store.

### Configure signing in build.gradle.kts

Create `flutter_app/android/key.properties` (DO NOT commit this file):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=walktogether
storeFile=/absolute/path/to/walktogether.keystore
```

Update `build.gradle.kts` release build type:

```kotlin
val keystoreProperties = Properties()
val keystoreFile = rootProject.file("key.properties")
if (keystoreFile.exists()) {
    keystoreProperties.load(keystoreFile.inputStream())
}

android {
    // ...
    buildTypes {
        release {
            signingConfig = SigningConfig(
                storeFile = file(keystoreProperties["storeFile"] as String),
                storePassword = keystoreProperties["storePassword"] as String,
                keyAlias = keystoreProperties["keyAlias"] as String,
                keyPassword = keystoreProperties["keyPassword"] as String,
            )
            // ...
        }
    }
}
```

The current `build.gradle.kts` uses debug signing for testing. **Replace with release signing before Play Store submission.**

## Play Store data safety answers

When submitting to Play Console, answer the Data Safety form as follows:

### Data collected

| Data type | Purpose | Required |
|---|---|---|
| Phone number | Account registration + OTP login | Required |
| Email (optional) | Account recovery | Optional |
| Name | Profile display | Required |
| Age range | Safety (18+ requirement) | Required |
| Gender | Matching preferences | Required |
| Approximate location (city/neighborhood) | Nearby walker matching | Required |
| Profile photo (optional) | Profile display | Optional |
| Bio (optional) | Profile display | Optional |
| Walk session metadata | Safety (active walk tracking) | Required |
| Chat messages | Communication between matched walkers | Required |
| Push notification token | Delivery of safety + chat alerts | Required |
| Device identifier | Fraud prevention | Required |

### Data NOT collected

- Exact GPS coordinates (only coarse distance shown to other users)
- Background location (foreground only)
- Contacts list
- Camera (only used at runtime for selfie verification, not stored)
- Microphone
- Financial data
- Health data
- Browsing history

### Data encryption

- [x] All data in transit: HTTPS (TLS 1.2+)
- [x] Session token: stored in FlutterSecureStorage (Android Keystore)
- [x] No data sold to third parties
- [x] No advertising SDKs

### Data deletion

- [x] Users can delete their account from Settings → "Delete my account"
- [x] 14-day grace period before anonymization
- [x] Safety events, reports, appeals, audit logs preserved for safety/legal reasons

## Play Store content rating

Fill out the IARC questionnaire in Play Console:

- **Violence:** None
- **Sexual content:** None
- **Profanity:** None (chat is moderated)
- **User-generated content:** Yes (chat messages, profile photos) — moderated
- **Drug reference:** None
- **Gambling:** None
- **In-app purchases:** No
- **Ads:** No

Expected rating: **Everyone** (or 12+ depending on user-generated content classification)

## Play Store closed testing checklist

1. [ ] Upload signed app bundle to Play Console
2. [ ] Create new release in "Internal testing" track
3. [ ] Add release notes (use V1_7_MOBILE_RELEASE_NOTES.md as reference)
4. [ ] Add testers by email (up to 100 for internal testing)
5. [ ] Wait for Play Store review (usually 1-3 days for first submission)
6. [ ] Testers receive opt-in link: `https://play.google.com/apps/internaltest/YOUR_APP_ID`
7. [ ] Testers install app, verify OTP login, location, push, SOS, chat, groups, clubs
8. [ ] Collect feedback via in-app feedback screen
9. [ ] Fix any issues, bump versionCode, re-upload
10. [ ] Promote to "Closed testing" track (alpha) for broader testing
11. [ ] After 14 days of stable closed testing, promote to "Open testing" (beta)
12. [ ] After 14 days of stable open testing, promote to "Production"

## Support + privacy URLs

- **Support email:** `support@walktogether.app` (set in `AppConfig.supportEmail`)
- **Privacy policy URL:** `https://walktogether.app/privacy-policy` (set in `AppConfig.privacyPolicyUrl`)
- **Terms of service URL:** `https://walktogether.app/terms-of-service` (set in `AppConfig.termsOfServiceUrl`)

These must be set in Play Console → App content → Privacy policy + Support email.

## Reviewer/tester credentials

For Play Store review, provide a test account:

- **Phone:** `+919999900000` (demo number — only works if demo login is enabled)
- **OTP:** Use the dev OTP bypass (only in dev builds)

For release builds (demo login disabled), reviewers must use a real phone number + OTP. Provide instructions in the review notes.

## Acceptance criteria

- [ ] `flutter build appbundle --release` succeeds
- [ ] App bundle is signed with release keystore
- [ ] App installs on real Android device (Android 6.0+)
- [ ] OTP login works end-to-end
- [ ] All permissions requested correctly
- [ ] No "premium" / "subscription" / "paywall" language visible
- [ ] No crash on cold start
- [ ] No sensitive data in logs
- [ ] Privacy policy URL is live
- [ ] Support email is monitored
