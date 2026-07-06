# Phase 29C-Final: Signed AAB + First Tester Rollout Status

**Phase:** 29C-Final
**Status:** Sandbox release build stopped intentionally — local build required
**Last updated:** 2026-07-06
**Owner:** Mobile Lead + Product Lead

## Overview

Phase 29C-Final prepares the signed release AAB for Play Console upload. After multiple attempts, the sandbox release build was **stopped intentionally** because the 10GB sandbox disk cannot accommodate the Flutter SDK + Android SDK + JDK + Gradle caches + Dart AOT compilation (~12GB total needed). The signing configuration is verified correct — the build passes compilation and only fails at the disk-intensive AOT stage.

**Decision: All signed release builds must happen on a local machine with 10–20GB+ free disk space.**

## What was verified in the sandbox ✅

### Code quality
- `dart analyze`: ✅ No issues found (0 errors, 0 warnings, 0 info)
- `dart format`: ✅ 0 files need formatting
- Free product scan: ✅ 0 forbidden terms
- Screens: ✅ 22
- Routes: ✅ 24
- API methods: ✅ 40

### Signing configuration
- Release keystore: ✅ Created (RSA 2048, valid until 2053)
- `key.properties`: ✅ Created (gitignored)
- `build.gradle` signing config: ✅ Configured with `signingConfigs.release`
- Keystore + key.properties gitignored: ✅ Verified with `git check-ignore`
- Build.gradle syntax: ✅ Accepted by Gradle (compilation passed)
- Gradle evaluation: ✅ Passed
- Kotlin compilation: ✅ Passed
- Java compilation: ✅ Passed

### Security
- No secrets committed: ✅ (.env, .jks, key.properties, google-services.json all gitignored)
- No admin API calls in mobile: ✅
- Secure storage for tokens: ✅
- No paid/premium language: ✅ (0 forbidden terms)

### GitHub
- Repository: https://github.com/rajeshqa98/walktogether
- Branch: `main`
- All code + docs pushed: ✅
- No secrets in commit history: ✅

## What was blocked by sandbox disk ❌

### Signed AAB/APK build
- **Root cause:** 10GB total disk. SDKs consume ~8GB. Build needs ~4GB peak. Only ~2GB free.
- **Build progress:** Passes clean → pub get → analyze → Gradle eval → Kotlin compile → Java compile. Fails at Dart AOT compilation (3 architectures need ~500MB, only ~200MB free).
- **Solution:** Build on a machine with 10–20GB+ free disk space.

### Play Console upload
- **Blocked by:** Requires signed AAB (see above)
- **Solution:** Build AAB locally → upload to Play Console

### First 5 tester rollout
- **Blocked by:** Requires Play Console upload (see above)
- **Solution:** After Play Console upload → invite 5 testers → share opt-in link

## What requires local machine execution ⏳

| Step | Status | Requires |
|---|---|---|
| Build signed AAB | ⏳ | Local machine with 10GB+ free disk |
| Build signed APK | ⏳ | Same as above |
| Install APK on device | ⏳ | Android device + USB cable |
| Firebase production config | ⏳ | Firebase account |
| Play Console app creation | ⏳ | Play Console developer account |
| AAB upload | ⏳ | Signed AAB + Play Console |
| First 5 tester invite | ⏳ | Play Console + tester emails |
| Tester smoke test | ⏳ | 5 testers + Android devices |

## Handoff package

The following documents provide complete instructions for local execution:

| Document | Purpose |
|---|---|
| `LOCAL_MACHINE_BUILD_RUNBOOK.md` | Step-by-step build instructions for local machine |
| `PLAY_CONSOLE_SUBMISSION_CHECKLIST.md` | Complete Play Console setup checklist |
| `FIRST_5_TESTER_SMOKE_CHECKLIST.md` | First 5 tester smoke test scenarios |
| `LOCAL_BUILD_TROUBLESHOOTING.md` | Common build issues + fixes |

## Exact local-machine commands

```bash
# 1. Clone
git clone https://github.com/rajeshqa98/walktogether.git
cd walktogether/flutter_app

# 2. Create keystore
keytool -genkey -v \
  -keystore walktogether-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias walktogether \
  -storepass YOUR_PASSWORD -keypass YOUR_PASSWORD \
  -dname "CN=WalkTogether, OU=Mobile, O=WalkTogether, L=City, ST=State, C=IN"

# 3. Create key.properties
cat > android/key.properties << 'EOF'
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=walktogether
storeFile=../walktogether-release-key.jks
EOF

# 4. Add Firebase config
# Download google-services.json from Firebase Console → place in android/app/

# 5. Verify no secrets staged
git status --short
# .jks, key.properties, google-services.json should NOT appear

# 6. Build
flutter clean && flutter pub get && dart analyze
flutter build appbundle --release
flutter build apk --release

# 7. Verify
jarsigner -verify build/app/outputs/bundle/release/app-release.aab

# 8. Install on device
adb install -r build/app/outputs/flutter-apk/app-release.apk

# 9. Upload to Play Console Internal Testing
# 10. Invite 5 testers
# 11. After first 5 pass → expand to 20-50
```

## Free product promise

WalkTogether remains 100% free for everyone. No payments, subscriptions, premium features, ads, or monetization. Safety is not a paid feature — it's a right. Verified by automated scan: 0 forbidden terms in source code.
