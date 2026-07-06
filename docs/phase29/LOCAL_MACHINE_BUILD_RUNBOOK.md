# Local Machine Build Runbook

**Phase:** 29C-Handoff
**Status:** Ready for local execution
**Last updated:** 2026-07-06
**Owner:** Mobile Lead

## Overview

This runbook provides step-by-step instructions for building the signed WalkTogether Android release AAB + APK on a local development machine. The sandbox environment cannot complete the build due to disk-space limitations (10GB total, ~2GB free after SDK installs). A local machine with 10–20GB+ free disk space is required.

## Prerequisites

### Required tools

| Tool | Version | How to install |
|---|---|---|
| Flutter SDK | 3.24.0+ (stable) | https://docs.flutter.dev/get-started/install |
| Android Studio | Latest | https://developer.android.com/studio |
| Android SDK | API 34 + build-tools 34.0.0 | Via Android Studio SDK Manager |
| Java (JDK) | 17 (Temurin or Oracle) | https://adoptium.net/temurin/releases/ |
| Git | Latest | https://git-scm.com/downloads |
| Google Play Console | Developer account ($25) | https://play.google.com/console |
| Firebase account | Free | https://console.firebase.google.com/ |

### Disk space requirement

**Minimum:** 10GB free disk space
**Recommended:** 20GB+ free disk space

Breakdown:
- Flutter SDK: ~2GB
- Android SDK: ~3GB
- Gradle caches: ~2GB
- Build outputs: ~1GB
- Dart AOT compilation (3 architectures): ~500MB
- Buffer: ~1.5GB

### Verify environment

```bash
# Check disk space (need 10GB+ free)
df -h

# Check Flutter
flutter --version
# Expected: Flutter 3.24.0+ on channel stable

# Check Java (must be 17)
java -version
# Expected: openjdk version "17.x.x"

# Check Android SDK
flutter doctor -v
# Expected: ✓ Android toolchain - develop for Android devices (Android SDK version 34.x.x)

# Check connected devices
adb devices
# Expected: List of devices attached (your Android device should appear)
```

If `flutter doctor` shows issues, fix them before proceeding.

## Step 1: Clone the repository

```bash
git clone https://github.com/rajeshqa98/walktogether.git
cd walktogether/flutter_app
```

## Step 2: Verify code quality

```bash
flutter clean
flutter pub get
dart analyze
# Expected: "No issues found!"

dart format --set-exit-if-changed .
# Expected: "Formatted N files (0 changed)" — no changes needed
```

## Step 3: Create release keystore

```bash
keytool -genkey -v \
  -keystore walktogether-release-key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias walktogether \
  -storepass YOUR_STORE_PASSWORD \
  -keypass YOUR_KEY_PASSWORD \
  -dname "CN=WalkTogether, OU=Mobile, O=WalkTogether, L=YourCity, ST=YourState, C=IN"
```

**Replace:**
- `YOUR_STORE_PASSWORD` — strong password for the keystore file
- `YOUR_KEY_PASSWORD` — strong password for the key (can be same as store)
- `YourCity`, `YourState` — your location

**Security:**
- ✅ The `.gitignore` already protects `*.jks` — it will NOT be committed
- ✅ Store the keystore + passwords in a password manager (1Password, Bitwarden, etc.)
- ✅ Back up the keystore in at least 2 secure locations
- ⚠️ If you lose the keystore, you CANNOT update the app on Play Store

## Step 4: Create signing config

```bash
cat > android/key.properties << 'EOF'
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=walktogether
storeFile=../walktogether-release-key.jks
EOF
```

**Security:**
- ✅ The `.gitignore` already protects `key.properties` — it will NOT be committed

**Verify:**
```bash
git status --short
# The .jks and key.properties files should NOT appear in git status
# If they do, stop and check .gitignore
```

## Step 5: Set up Firebase (for push notifications)

1. Go to https://console.firebase.google.com/
2. Click "Add project" → name it "WalkTogether"
3. Add an Android app:
   - Package name: `com.walktogether.app` (must match `applicationId` in `build.gradle`)
   - App nickname: WalkTogether (optional)
   - Debug SHA-1: run `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep SHA1`
4. Download `google-services.json`
5. Place it at: `flutter_app/android/app/google-services.json`

**Security:**
- ✅ The `.gitignore` already protects `google-services.json` — it will NOT be committed

**Verify:**
```bash
git status --short
# google-services.json should NOT appear in git status
```

6. In Firebase Console → Cloud Messaging → enable FCM

## Step 6: Build signed release AAB + APK

```bash
flutter clean
flutter pub get
dart analyze

# Build signed release AAB (for Play Console upload)
flutter build appbundle --release

# Build signed release APK (for direct device install)
flutter build apk --release
```

**Expected output:**
```
✓ Built build/app/outputs/bundle/release/app-release.aab (23.4MB)
✓ Built build/app/outputs/flutter-apk/app-release.apk (23.3MB)
```

## Step 7: Verify build artifacts

```bash
# Check AAB exists + is signed
ls -lh build/app/outputs/bundle/release/app-release.aab
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
# Expected: "jar verified."

# Check APK exists + is signed
ls -lh build/app/outputs/flutter-apk/app-release.apk
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
# Expected: "jar verified."
```

## Step 8: Install APK on Android device

```bash
# Connect your Android device via USB (enable USB debugging in Developer Options)
adb devices
# Your device should appear

# Install the release APK
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Open the app
adb shell am start -n com.walktogether.app/.MainActivity
```

**Verify on device:**
- [ ] App opens without crash
- [ ] Login screen loads
- [ ] WalkTogether logo visible
- [ ] "100% free • safety-first • community-first" text visible
- [ ] Settings opens (tap settings icon)
- [ ] Feedback screen opens (More → Give feedback)
- [ ] Version shows 1.7.0 in Settings

## Step 9: Upload AAB to Play Console

1. Go to https://play.google.com/console
2. Click "Create app"
   - App name: WalkTogether — Safe Walking Companion
   - Default language: English
   - App type: App
   - Pricing: Free
3. Complete all "App content" sections (see `PLAY_CONSOLE_SUBMISSION_CHECKLIST.md`)
4. Go to "Internal testing" → "Create release"
5. Upload `build/app/outputs/bundle/release/app-release.aab`
6. Add release notes
7. Add 5 tester emails
8. Review + publish
9. Share opt-in link with testers

## Step 10: Invite first 5 testers

Add 5 tester emails to Play Console Internal Testing:

| # | Tester type | What they test |
|---|---|---|
| 1 | City user | Nearby walkers, walk request |
| 2 | Small-town user | Fewer walkers, invite |
| 3 | Village/manual-location | Manual village/town, first-walker |
| 4 | Safety-focused tester | SOS, safety share, report/block |
| 5 | Group/club tester | Group walk join, club join, group chat |

Send each tester:
1. The Play Console opt-in link
2. The onboarding message from `docs/phase28/TESTER_ONBOARDING_MESSAGE.md`
3. The test scenarios from `docs/phase28/BETA_TEST_SCENARIOS.md`

**Only after all 5 pass the smoke test → expand to 20–50 testers.**

## Troubleshooting

See `LOCAL_BUILD_TROUBLESHOOTING.md` for common issues + fixes.

## Free product promise

WalkTogether is 100% free for everyone. No payments, subscriptions, premium features, ads, or monetization. Safety is not a paid feature — it's a right.
