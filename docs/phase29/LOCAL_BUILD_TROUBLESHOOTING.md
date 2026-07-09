# Local Build Troubleshooting Guide

**Phase:** 29C-Handoff
**Status:** Ready
**Last updated:** 2026-07-06

## Overview

This guide covers common issues encountered when building the WalkTogether Flutter app locally and uploading to Play Console. Each issue includes the error message, root cause, and fix.

## Java version issues

### "Unsupported class file major version 65"

**Cause:** Java 21 is installed, but Gradle 7.x doesn't support Java 21.

**Fix:** Install Java 17 (Temurin):
```bash
# macOS (Homebrew)
brew install openjdk@17
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home

# Linux (SDKMAN)
sdk install java 17.0.13-tem

# Verify
java -version
# Expected: openjdk version "17.x.x"
```

### "Could not find tools.jar"

**Cause:** Java JRE is installed instead of JDK.

**Fix:** Install full JDK (not just JRE):
- Download from https://adoptium.net/temurin/releases/ (select JDK 17)
- Set `JAVA_HOME` to the JDK directory

## Gradle issues

### "Gradle build daemon disappeared unexpectedly"

**Cause:** Not enough memory for Gradle daemon (needs ~2GB).

**Fix:** Reduce Gradle memory in `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx1G -XX:MaxMetaspaceSize=512M
```

Or disable the daemon:
```properties
org.gradle.daemon=false
```

### "Could not download gradle-8.7-bin.zip"

**Cause:** Network timeout during Gradle download.

**Fix:** Pre-download Gradle manually:
```bash
cd android
./gradlew --version
# This downloads Gradle 8.7. If it times out, retry or use a VPN
```

### "Failed to create directory" during build

**Cause:** Insufficient disk space.

**Fix:** Ensure at least 10GB free disk space:
```bash
df -h
# Need at least 10GB free
```

Clean up:
```bash
flutter clean
rm -rf ~/.gradle/caches/transforms-*
rm -rf ~/.gradle/caches/jars-*
cd android && ./gradlew --stop
```

## Android SDK issues

### "Android SDK not found"

**Cause:** `ANDROID_HOME` not set or SDK not installed.

**Fix:**
```bash
# Install Android SDK via Android Studio
# Or install command-line tools:
# https://developer.android.com/studio#command-line-tools-only

# Set environment variables
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Install required packages
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Verify
flutter doctor -v
```

### "compileSdkVersion is not specified"

**Cause:** Plugin can't find Flutter's compileSdkVersion.

**Fix:** Ensure `flutter pub get` ran successfully:
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

## Firebase issues

### "FirebaseApp initialization failed"

**Cause:** `google-services.json` missing or wrong package name.

**Fix:**
1. Verify `flutter_app/android/app/google-services.json` exists
2. Open it and check `package_name` is `com.walktogether.app`
3. If missing: download from Firebase Console → Project Settings → Android app
4. Run `flutter clean && flutter pub get`
5. Rebuild

### "No FCM token received"

**Cause:** Notification permission denied or Firebase misconfigured.

**Fix:**
1. Check notification permission: Android Settings → Apps → WalkTogether → Notifications
2. Verify Firebase Console → Cloud Messaging is enabled
3. Check device has internet connection
4. On Android 13+: ensure `POST_NOTIFICATIONS` permission granted

## Signing issues

### "App not signed correctly" on Play Console

**Cause:** AAB signed with different key than expected.

**Fix:**
1. If first upload: ensure using release keystore (not debug)
2. If previously uploaded: use the SAME keystore for all future uploads
3. If keystore lost: enroll in Play App Signing → request key reset

### "Keystore file not found"

**Cause:** Path in `key.properties` doesn't match actual location.

**Fix:** Use correct path in `android/key.properties`:
```properties
storeFile=/absolute/path/to/walktogether-release-key.jks
# Or relative to android/ directory:
storeFile=../walktogether-release-key.jks
```

### "keystoreProperties is null"

**Cause:** `key.properties` file missing or unreadable.

**Fix:**
1. Verify `android/key.properties` exists
2. Verify file format:
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=walktogether
storeFile=../walktogether-release-key.jks
```
3. Ensure no trailing spaces or extra quotes

## Play Console issues

### "Package name mismatch"

**Cause:** Package name in AAB doesn't match Play Console app.

**Fix:**
1. Check `android/app/build.gradle`:
```gradle
applicationId "com.walktogether.app"
```
2. Check `google-services.json` → `package_name` is `com.walktogether.app`
3. Check Play Console → App → Package name is `com.walktogether.app`

### "VersionCode conflict"

**Cause:** Same versionCode already uploaded.

**Fix:** Increment versionCode in `pubspec.yaml`:
```yaml
version: 1.7.0+28  # was +27, now +28
```
Then rebuild:
```bash
flutter build appbundle --release
```

### "App rejected — policy violation"

**Cause:** Play Console policy issue (content, data safety, permissions).

**Fix:**
1. Check Play Console → Policy status for the rejection reason
2. Common fixes:
   - Complete Data Safety form accurately
   - Ensure privacy policy URL is live
   - Remove unnecessary permissions
   - Complete content rating questionnaire
3. Fix the issue → re-upload AAB → submit for review

## Device install issues

### "App not installed" on device

**Cause:** Signature mismatch with existing install, or insufficient storage.

**Fix:**
```bash
# Uninstall any existing version
adb uninstall com.walktogether.app

# Reinstall
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### "Unknown sources" blocked

**Cause:** Android blocks installation from unknown sources.

**Fix:** Enable "Install unknown apps" for your file manager or browser:
- Android Settings → Apps → Special access → Install unknown apps
- Or: use Play Console Internal Testing (recommended)

### "App crashes on startup"

**Cause:** Missing Firebase config, missing permissions, or code bug.

**Fix:**
1. Check `google-services.json` is present
2. Check `flutter pub get` succeeded
3. Check `dart analyze` has no issues
4. Check device logcat:
```bash
adb logcat | grep -E "AndroidRuntime|flutter|FATAL"
```
5. If crash is in native code: check ProGuard rules
6. Report the crash with logcat output

## Performance issues

### "Build takes too long"

**Cause:** First build downloads Gradle dependencies (~2GB).

**Fix:**
- First build: 10–20 minutes (downloading dependencies)
- Subsequent builds: 2–5 minutes (cached)
- Use `flutter build appbundle --release` (not `--debug` for Play Console)

### "Out of memory during build"

**Cause:** Gradle needs more RAM.

**Fix:** Increase Gradle memory in `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2G -XX:MaxMetaspaceSize=1G
```

## Free product compliance

If any issue mentions "in-app purchase", "subscription", "premium", or "ads":
- These are NOT in the WalkTogether app
- The app is 100% free — no payments, subscriptions, premium features, or ads
- If Play Console asks about monetization: answer "No" to in-app purchases and ads
- If the Data Safety form asks about financial data: "Not collected"
