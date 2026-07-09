# WalkTogether — Mobile Release Checklist

## Pre-Build

### Flutter Environment
- [ ] Flutter SDK installed (≥3.2.0 stable)
- [ ] `flutter doctor` passes with no issues
- [ ] `flutter pub get` succeeds
- [ ] `dart analyze` passes with no errors
- [ ] `dart format` applied to all files
- [ ] All dependencies in pubspec.yaml resolved

### Backend
- [ ] Backend API deployed and accessible
- [ ] `API_BASE_URL` set in `lib/core/config.dart` (HTTPS for production)
- [ ] `SOCKET_URL` set in `lib/core/config.dart`
- [ ] `/api/health` returns 200
- [ ] `/api/ready` returns 200
- [ ] Database migrated (PostgreSQL if production)
- [ ] Redis configured (if multi-instance)
- [ ] OTP provider configured (MSG91 or Twilio — NOT dev mode)
- [ ] `PILOT_MODE=invite_only` set for closed testing
- [ ] Seed data loaded (for demo login)

### Firebase
- [ ] Firebase project created
- [ ] Android app added (package: com.walktogether.app)
- [ ] `google-services.json` placed in `android/app/`
- [ ] iOS app added (bundle: com.walktogether.app)
- [ ] `GoogleService-Info.plist` placed in `ios/Runner/`
- [ ] Cloud Messaging enabled
- [ ] (Optional) Crashlytics enabled

---

## Android Build

### Configuration
- [ ] `applicationId` set to `com.walktogether.app` in `android/app/build.gradle`
- [ ] App name set to "WalkTogether" in `android/app/src/main/AndroidManifest.xml`
- [ ] App icon generated (use `flutter_launcher_icons`)
- [ ] Splash screen configured
- [ ] `AndroidManifest.xml` permissions: FINE_LOCATION, COARSE_LOCATION, POST_NOTIFICATIONS, INTERNET, WAKE_LOCK, VIBRATE
- [ ] No `ACCESS_BACKGROUND_LOCATION` permission
- [ ] Network security config (if using HTTP for testing — not for production)

### Signing
- [ ] Generate release keystore: `keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias walktogether`
- [ ] Create `android/key.properties` with keystore path + passwords
- [ ] Configure `build.gradle` to use release signing

### Build
- [ ] `flutter build appbundle --release` succeeds
- [ ] AAB file generated in `build/app/outputs/bundle/release/`
- [ ] Install on physical device and test core flows

### Play Console
- [ ] Create app in Play Console
- [ ] Fill Data Safety form
- [ ] Upload AAB to closed testing track
- [ ] Add tester email list (minimum 12 for new accounts)
- [ ] Share opt-in URL with testers
- [ ] Content rating questionnaire completed
- [ ] Privacy Policy URL set
- [ ] Store listing (title, description, screenshots) filled

---

## iOS Build (requires macOS + Xcode)

### Configuration
- [ ] Bundle identifier set to `com.walktogether.app` in Xcode
- [ ] Display name set to "WalkTogether"
- [ ] App icon generated (1024x1024 + all required sizes)
- [ ] Launch screen configured
- [ ] `Info.plist` includes:
  - `NSLocationWhenInUseUsageDescription` (privacy-safe text)
  - Background modes: `remote-notification`
  - Portrait-only orientation
- [ ] No `NSLocationAlwaysAndWhenInUseUsageDescription` (no background location)
- [ ] `GoogleService-Info.plist` added to Runner target
- [ ] Push notification capability enabled
- [ ] Signing team configured in Xcode

### Build
- [ ] `flutter build ios --release` succeeds
- [ ] Archive in Xcode: Product → Archive
- [ ] Upload to App Store Connect
- [ ] TestFlight build processed

### App Store Connect
- [ ] App record created
- [ ] Screenshots uploaded (6.7", 6.5", 5.5" if required)
- [ ] App description filled
- [ ] Privacy Policy URL set
- [ ] Privacy nutrition labels filled
- [ ] App Review notes filled (see APP_STORE_REVIEW_NOTES.md)
- [ ] Internal testers added
- [ ] External testing group created
- [ ] Build released to TestFlight

---

## Post-Build Verification

### Core Flows
- [ ] OTP login works (real OTP via MSG91/Twilio)
- [ ] Demo login works (dev mode)
- [ ] Profile setup saves correctly
- [ ] GPS location permission flow works
- [ ] Manual location picker works
- [ ] Nearby walkers load with approximate labels
- [ ] Walk request can be sent
- [ ] Walk request can be accepted/declined
- [ ] Chat works (send + receive)
- [ ] Walk session starts with timer
- [ ] SOS button shows confirmation + creates safety event
- [ ] Safety share toggle works
- [ ] Walk can be ended
- [ ] Post-walk rating submits
- [ ] Report/block works
- [ ] Group walk can be created (verified user)
- [ ] Group walk can be joined
- [ ] Group chat works
- [ ] Club can be created and joined
- [ ] Notifications load
- [ ] Push notifications received
- [ ] Settings: hide-me toggle works
- [ ] Settings: push toggle works
- [ ] Settings: feedback submission works
- [ ] Logout works
- [ ] Account deletion path exists

### Safety Verification
- [ ] Exact coordinates NOT visible to other users
- [ ] Approximate distance labels shown (e.g., "within 300m")
- [ ] Verified badge visible on verified users
- [ ] Trust score visible on walker cards
- [ ] Women-only groups not visible to male users
- [ ] Verified-only groups not joinable by unverified users
- [ ] Banned/suspended users cannot log in
- [ ] Chat locked before request acceptance
- [ ] SOS does NOT call emergency services
- [ ] Public meeting point only (no private addresses)
- [ ] Report/block accessible from post-walk + chat

### Compliance
- [ ] Privacy Policy linked in Settings
- [ ] Terms of Service linked in Settings
- [ ] Community Guidelines linked in Settings
- [ ] Account deletion path available
- [ ] Location permission copy is clear
- [ ] Notification permission is user-triggered (not on launch)
- [ ] No exact coordinates exposed to other users
- [ ] Support email visible in Settings

---

## Go/No-Go Criteria for Beta Release

### Must Pass (All Required)
- [ ] App builds without errors on Android
- [ ] App builds without errors on iOS (if macOS available)
- [ ] OTP login works with real SMS provider
- [ ] No crashes on core flows
- [ ] Location privacy preserved (no exact coords to other users)
- [ ] SOS works without calling emergency services
- [ ] Report/block works
- [ ] Push notifications delivered
- [ ] Backend health/ready endpoints pass
- [ ] Privacy Policy + Terms published

### Should Pass (Important)
- [ ] Socket.io realtime works (with polling fallback)
- [ ] Group walk full flow works
- [ ] Club full flow works
- [ ] Admin panel accessible and functional
- [ ] Analytics events tracked
- [ ] Pilot mode (invite-only) enforced

### Nice to Have (Can defer)
- [ ] Offline mode (not implemented in Phase 10)
- [ ] Background location (not requested in Phase 10)
- [ ] Apple Health / Google Fit integration
- [ ] Push notification deep linking
