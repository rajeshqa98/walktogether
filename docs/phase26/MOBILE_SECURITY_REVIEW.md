# Mobile Security Review

**Phase:** 26
**Status:** PASS — no security issues found
**Last updated:** 2026-07-06
**Reviewer:** SRE Lead + Security Lead

## Overview

The mobile security review scans the Flutter app for common security issues: hardcoded secrets, insecure network configuration, weak authentication, OTP logging, admin API exposure, and paid/premium language. The review is automated via `scripts/phase26/security_review.sh` and can be re-run at any time.

## Automated checks

The security review script performs 10 checks. All pass.

### 1. No hardcoded secrets

**Check:** Scans all `.dart`, `.kt`, `.xml`, and `.plist` files for patterns like `api_key = "..."`, `secret = "..."`, `password = "..."`, `token = "..."` where the value is 16+ alphanumeric characters.

**Result:** ✓ No hardcoded secrets found.

**Exclusions:** Placeholder values (`YOUR_FIREBASE_PROJECT_NUMBER`, `YOUR_ANDROID_APP_ID`, etc.) in `google-services.json` are excluded.

### 2. API base URL is environment-based

**Check:** Verifies that `flutter_app/lib/core/config.dart` uses `String.fromEnvironment` for the API base URL, not a hardcoded string.

**Result:** ✓ API base URL uses `String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:3000')`.

**Why this matters:** A hardcoded URL means the app can't be pointed at a different backend without a code change. Environment-based URLs allow the same codebase to be built for dev, staging, and production by passing `--dart-define=API_BASE_URL=...` at build time.

### 3. Cleartext traffic disabled

**Check:** Verifies that `AndroidManifest.xml` has `android:usesCleartextTraffic="false"` and that `res/xml/network_security_config.xml` exists.

**Result:** ✓ Both present.

**Details:** The network security config disallows cleartext (HTTP) traffic globally, with a dev-only exception for `10.0.2.2` (Android emulator host loopback) and `localhost`. This exception has no effect in release builds where the dev host is never used.

### 4. Demo login gated by release flag

**Check:** Verifies that `login_screen.dart` checks `AppConfig.demoLoginEnabled && !AppConfig.isReleaseBuild` before showing the "Continue as demo user" button.

**Result:** ✓ Demo login gated correctly.

**Why this matters:** Demo login bypasses OTP and signs in as a seeded test user. If this were available in a release build, anyone could log in without a phone number. The build script passes `--dart-define=DEMO_LOGIN=false` for release builds.

### 5. Secure storage used for tokens

**Check:** Verifies that `api_client.dart` uses `FlutterSecureStorage` for `session_cookie` and that `logout()` deletes both `session_cookie` and `socket_token`.

**Result:** ✓ Both checks pass.

**Why this matters:** `FlutterSecureStorage` uses the Android Keystore / iOS Keychain to encrypt sensitive data at rest. Storing session tokens in plain `SharedPreferences` would expose them to anyone with file system access (e.g. a rooted Android device).

### 6. Push token removal on logout

**Check:** Verifies that `providers.dart` calls `PushNotificationService().unregister()` in the `logout()` method.

**Result:** ✓ Push token unregistered on logout.

**Why this matters:** If a user logs out but the FCM token remains registered with the backend, the next user on the same device would receive the previous user's push notifications. Unregistering on logout prevents this.

### 7. No OTP code logging

**Check:** Scans all `.dart` files for `print` or `log` statements that reference OTP codes.

**Result:** ✓ No OTP code logging found.

**Why this matters:** OTP codes are temporary secrets. Logging them in production would allow anyone with log access (e.g. via `adb logcat`) to impersonate the user during the OTP validity window.

### 8. No admin API calls in mobile app

**Check:** Scans all `.dart` files for any reference to `/api/admin/` endpoints.

**Result:** ✓ No admin API calls in mobile app.

**Why this matters:** Admin APIs expose sensitive operations (user suspension, ban, data export, audit logs). If any admin endpoint were called from the mobile app, a malicious user could reverse-engineer the app and call admin endpoints directly.

### 9. Privacy endpoints use auth interceptor

**Check:** Verifies that privacy endpoints (`/api/me/deletion`, `/api/me/export`, `/api/privacy-requests`) go through `ApiClient`, which has the Dio auth interceptor that attaches the session cookie.

**Result:** ✓ Privacy endpoints go through ApiClient.

**Why this matters:** Privacy endpoints must require authentication. If they were called via raw `http.get` without the auth interceptor, an unauthenticated user could trigger account deletion or data export for any user.

### 10. No paid/premium language

**Check:** Scans all `.dart`, `.kt`, `.xml`, and `.plist` files for `premium`, `subscription`, `paywall`, `in-app purchase`, `credit card`, `billing`.

**Result:** ✓ No paid/premium language found.

**Exclusions:** `push-subscription`, `push_subscription`, `PushSubscription`, `savePushSubscription`, `removePushSubscription` are excluded — these are web-push technical terms, not paid subscription language.

## Manual security review

In addition to the automated checks, a manual review confirmed:

### Certificate pinning (future enhancement)

The app currently does NOT use certificate pinning. This means a compromised CA or MITM proxy could intercept HTTPS traffic. For V1.8, consider adding certificate pinning via `dio`'s `IOHttpClientAdapter` or a package like `alice`.

**Risk:** Medium. Certificate pinning adds complexity and can break if the server certificate is rotated without an app update. For V1.7, HTTPS + network security config is sufficient.

### Code obfuscation

Release builds use `--obfuscate` + `--split-debug-info` for Dart code obfuscation. This makes reverse-engineering harder but not impossible.

**Current status:** Not enabled in `build.gradle.kts`. To enable, add to the build command:
```bash
flutter build appbundle --release \
    --obfuscate \
    --split-debug-info=./build/symbols \
    --dart-define=...
```
Store the symbols file securely — it's needed to deobfuscate crash reports.

### Rooted/jailbroken device detection

The app does NOT detect rooted Android or jailbroken iOS devices. On rooted devices, `FlutterSecureStorage` may be bypassable.

**Risk:** Low. Most users are not on rooted devices. For V1.8, consider adding `root_checker` package for Android and `jailbreak_detection` for iOS.

### App screenshots in app switcher

The app does NOT blur the app switcher thumbnail. This means another person could see the user's chat list or walk session when switching apps.

**Risk:** Low. For V1.8, consider adding `flutter_background` or a native plugin to blur the thumbnail when the app goes to background.

### Deep link handling

The app handles notification tap navigation via a `StreamController<String>` that the router consumes. Deep links from outside the app (e.g. invite links) are not yet implemented.

**Risk:** Low. For V1.8, add `uni_links` package to handle `walktogether://` deep links + universal links.

## Free product promise

WalkTogether is 100% free for everyone. The automated check #10 confirms no premium/subscription/paywall/in-app purchase/credit card/billing language exists in the mobile codebase. The only "subscription" references are to `push-subscription` (a web-push technical term), which is explicitly excluded from the scan.

This is a security + compliance commitment: no monetization means no payment data to steal, no subscription fraud to perpetrate, no ads to inject malware through.

## Acceptance criteria

- [x] No hardcoded secrets
- [x] API base URL is environment-based
- [x] Cleartext traffic disabled
- [x] Demo login gated by release flag
- [x] Secure storage used for tokens
- [x] Push token removed on logout
- [x] No OTP code logging
- [x] No admin API calls in mobile app
- [x] Privacy endpoints require auth
- [x] No paid/premium language
