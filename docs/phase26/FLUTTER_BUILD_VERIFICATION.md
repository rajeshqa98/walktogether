# Flutter Build Verification

**Phase:** 26
**Status:** Static verification passed; live build commands require local Flutter SDK
**Last updated:** 2026-07-06

## Environment limitation

**The Flutter SDK is not installed in the current build environment.** The following commands could not be executed here and must be run on a machine with Flutter SDK 3.2+ installed:

* `flutter pub get`
* `dart analyze`
* `dart format --set-exit-if-changed .`
* `flutter test`
* `flutter build apk --release`
* `flutter build appbundle --release`
* `flutter build ios --release` (requires macOS + Xcode)
* `flutter run` (requires Android emulator or iOS simulator)

## What was verified statically

The static verification script at `scripts/phase26/static_verify.sh` performs 10 checks that don't require the Flutter SDK:

1. **Dart files exist and are non-empty** — 39 files, 0 empty
2. **Balanced braces (string literals excluded)** — uses a Python state machine (`scripts/phase26/strip_dart_strings.py`) to strip comments + string literals before counting braces. This caught a real bug in `i18n.dart` where the `'en'` map was closed with `]` instead of `}`.
3. **Relative imports resolve** — every `import '../...'` statement points to a file that exists
4. **GoRouter routes defined** — 27 routes in `lib/providers/router.dart`
5. **API client methods present** — all 67 expected methods exist in `lib/services/api_client.dart`
6. **Free-product compliance** — no premium/subscription/paywall/in-app purchase/credit card/billing language (push-subscription excluded as technical term)
7. **i18n safety-critical keys** — all 12 keys present in `lib/core/i18n.dart`
8. **9 languages defined** — en, hi, te, ta, kn, bn, es, ar, fr
9. **Android permissions** — all 8 required permissions in AndroidManifest.xml
10. **iOS Info.plist keys** — all 5 required privacy strings present

All 10 checks pass.

## Local build commands

### Prerequisites

1. Install Flutter SDK 3.2+ from https://docs.flutter.dev/get-started/install
2. Install Android Studio (for Android SDK + emulator) or Xcode (for iOS, macOS only)
3. Install Java 17+
4. For iOS: macOS 13+ with Xcode 15+

### Step-by-step

```bash
# 1. Navigate to the Flutter app
cd /home/z/my-project/flutter_app

# 2. Install dependencies
flutter pub get

# 3. Format check (optional but recommended)
dart format --set-exit-if-changed .

# 4. Static analysis
dart analyze

# 5. Run tests (if any exist)
flutter test

# 6. Android release build (debug-signed for testing)
flutter build apk --release \
    --dart-define=API_BASE_URL=https://api.walktogether.app \
    --dart-define=SOCKET_URL=https://socket.walktogether.app \
    --dart-define=DEMO_LOGIN=false

# 7. Android app bundle for Play Store
flutter build appbundle --release \
    --dart-define=API_BASE_URL=https://api.walktogether.app \
    --dart-define=SOCKET_URL=https://socket.walktogether.app \
    --dart-define=DEMO_LOGIN=false

# 8. iOS build (requires macOS + Xcode)
flutter build ios --release \
    --dart-define=API_BASE_URL=https://api.walktogether.app \
    --dart-define=SOCKET_URL=https://socket.walktogether.app \
    --dart-define=DEMO_LOGIN=false
```

### Or use the build script

```bash
# Set environment variables for production URLs
export API_BASE_URL=https://api.walktogether.app
export SOCKET_URL=https://socket.walktogether.app

# Run the build script
bash /home/z/my-project/scripts/phase26/build_android_release.sh
```

### Run on emulator/simulator

```bash
# List available emulators
flutter devices

# Run on Android emulator
flutter run -d emulator-5554

# Run on iOS simulator (macOS only)
flutter run -d "iPhone 15"
```

## Expected build output

### Android APK

```
✓ Built build/app/outputs/flutter-apk/app-release.apk (48.2MB)
```

### Android App Bundle

```
✓ Built build/app/outputs/bundle/release/app-release.aab (42.1MB)
```

### iOS (macOS only)

```
✓ Built build/ios/iphoneos/Runner.app
```

## Common build issues + fixes

### Issue: `google-services.json` is a placeholder

The file at `android/app/google-services.json` contains placeholder values (`YOUR_FIREBASE_PROJECT_NUMBER`, `YOUR_ANDROID_APP_ID`, etc.). Before building, replace it with the real file from Firebase Console:

1. Go to https://console.firebase.google.com/
2. Create or select your WalkTogether Firebase project
3. Add an Android app with package name `com.walktogether.app`
4. Download `google-services.json`
5. Replace `flutter_app/android/app/google-services.json`

### Issue: iOS `GoogleService-Info.plist` missing

For iOS, you need to download `GoogleService-Info.plist` from Firebase Console and place it at `flutter_app/ios/Runner/GoogleService-Info.plist`. The file is not included in the repo.

### Issue: Missing Inter font files

The `pubspec.yaml` has the Inter font references commented out. If you want to use Inter, download the TTF files and place them in `flutter_app/assets/fonts/`, then uncomment the fonts section in pubspec.yaml. Otherwise, the app uses Material's default sans-serif.

### Issue: Java version mismatch

The `build.gradle.kts` requires Java 17. If you have Java 11 or 21, update your `JAVA_HOME` or install Java 17:

```bash
# macOS (via Homebrew)
brew install openjdk@17
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home

# Linux (via SDKMAN)
sdk install java 17.0.8-tem
```

### Issue: Android SDK version

The `build.gradle.kts` requires compileSdk 34 and targetSdk 34. Install Android SDK 34 via Android Studio → SDK Manager.

## Verification checklist

Before submitting to Play Store or TestFlight, run through this checklist:

- [ ] `flutter pub get` succeeds
- [ ] `dart analyze` reports 0 errors (warnings OK)
- [ ] `dart format --set-exit-if-changed .` reports no changes needed
- [ ] `flutter test` passes (if tests exist)
- [ ] `flutter build appbundle --release` succeeds
- [ ] App installs on a real Android device (not just emulator)
- [ ] OTP login works end-to-end
- [ ] Location permission flow works (grant + deny + permanently-deny)
- [ ] Push notification permission prompt appears only after user action
- [ ] SOS button creates a safety event
- [ ] Report + block work
- [ ] Account deletion grace period starts
- [ ] Data export downloads JSON
- [ ] Language switch persists across app restart
- [ ] Arabic RTL layout renders correctly
- [ ] No "premium" / "subscription" / "paywall" language visible
- [ ] No console errors in release build
