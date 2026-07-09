# Phase 29B Beta Execution Readiness Report

**Phase:** 29B
**Status:** Build-verified and beta-ready — awaiting real tester execution
**Last updated:** 2026-07-06
**Owner:** Product Lead + Mobile Lead

## Overview

Phase 29B is the real-world execution of the closed Android beta. This report documents what has been verified in the build environment and what must be executed by the product team with real human testers on physical Android devices.

**Important:** Real beta testing cannot be performed by an AI in a sandboxed environment. It requires:
- A physical Android device
- Real human testers (20–50 people)
- A Play Console developer account
- A real Firebase project
- A release keystore

This report confirms the app is **technically ready** for beta and provides the exact checklist for the product team to execute.

## What has been verified ✅

### 1. Flutter app code quality

| Check | Result |
|---|---|
| `flutter pub get` | ✅ Succeeded (47 packages) |
| `dart analyze` | ✅ No issues found (0 errors, 0 warnings, 0 info) |
| `dart format --set-exit-if-changed .` | ✅ 0 files need formatting |
| Free product scan | ✅ 0 forbidden terms in source code |

### 2. Flutter app feature completeness

| Check | Result |
|---|---|
| Screens implemented | ✅ 22 screens |
| Routes defined | ✅ 24 GoRouter routes |
| API client methods | ✅ 40 methods covering Phase 16–25 backend |
| i18n languages | ✅ 9 languages (en, hi, te, ta, kn, bn, es, ar, fr) |
| Arabic RTL | ✅ Directionality wrapper in main.dart |
| Safety flows in code | ✅ SOS, safety share, report, block, appeal, deletion, export |
| Location privacy in code | ✅ Foreground-only, approximate accuracy, manual fallback |
| Demo login gated | ✅ Hidden in release builds (DEMO_LOGIN=false) |

### 3. Android build artifacts

| Artifact | Size | Status |
|---|---|---|
| Debug APK | 90 MB | ✅ Built (app-debug.apk) |
| Release APK | 23 MB | ✅ Built (app-release.apk) |
| Release AAB | 23 MB | ✅ Built (app-release.aab) |

**Note:** These are currently signed with the **debug keystore**. Before Play Console upload, they must be re-signed with a **release keystore** (see "What must be done next" below).

### 4. Android native configuration

| Check | Result |
|---|---|
| Package name | ✅ `com.walktogether.app` |
| Version name | ✅ `1.7.0` |
| Version code | ✅ `27` |
| Min SDK | ✅ 23 (Android 6.0) |
| Target SDK | ✅ 34 (Android 14) |
| AndroidManifest permissions | ✅ 8 permissions (location, notifications, internet, etc.) |
| Network security config | ✅ Cleartext disabled, dev-only localhost exception |
| MainActivity | ✅ Flutter v2 embedding |
| Gradle wrapper | ✅ 8.7 |
| AGP | ✅ 8.1.0 |
| Kotlin | ✅ 1.9.0 |
| Java | ✅ Temurin 17.0.13 |

### 5. Security verification

| Check | Result |
|---|---|
| No secrets in source | ✅ Verified by security review |
| API base URL environment-based | ✅ `String.fromEnvironment` |
| Secure storage for tokens | ✅ FlutterSecureStorage |
| Logout clears tokens | ✅ session_cookie + socket_token deleted |
| Push token removed on logout | ✅ `unregister()` called |
| No OTP code logging | ✅ Verified |
| No admin API calls in mobile | ✅ 0 references to `/api/admin/` |
| Privacy endpoints use auth | ✅ All go through ApiClient interceptor |
| No paid/premium language | ✅ 0 forbidden terms |
| `.gitignore` protects sensitive files | ✅ .env, keystore, google-services.json, etc. |

### 6. GitHub repository

| Check | Result |
|---|---|
| Repository | ✅ https://github.com/rajeshqa98/walktogether |
| Branch | ✅ `main` |
| Total tracked files | ✅ 80 |
| No secrets committed | ✅ .env removed, no keystore, no google-services.json |
| No build artifacts committed | ✅ No APK/AAB/build/ in repo |
| No token in remote URL | ✅ Cleaned after push |
| Commit history | ✅ 5 commits (initial → Phase 27C → security fix → Phase 28 → Phase 29) |

## What must be done next (requires human action) ⏳

### Step 1: Create release keystore (15 min)

**Why:** Play Console requires AAB signed with a release key, not the debug key.

**How:** Follow `docs/phase28/RELEASE_KEYSTORE_SETUP.md`:

```bash
keytool -genkey -v \
    -keystore walktogether.keystore \
    -alias walktogether \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass YOUR_PASSWORD \
    -keypass YOUR_PASSWORD
```

**Then:**
1. Create `flutter_app/android/key.properties` (NOT committed — .gitignore protects it)
2. Update `flutter_app/android/app/build.gradle` release signingConfig
3. Rebuild: `flutter build appbundle --release`
4. Verify: `jarsigner -verify build/app/outputs/bundle/release/app-release.aab`

**Verify:**
- [ ] Keystore created
- [ ] Keystore NOT committed to repo
- [ ] `key.properties` NOT committed to repo
- [ ] Signed AAB builds
- [ ] Signed APK builds
- [ ] App installs on physical Android device
- [ ] App opens without crash
- [ ] Version shows 1.7.0

### Step 2: Set up Firebase production config (30 min)

**Why:** Push notifications require a real Firebase project.

**How:** Follow `docs/phase28/FIREBASE_PRODUCTION_SETUP.md`:

1. Go to https://console.firebase.google.com/
2. Create project `walktogether-prod`
3. Add Android app → package name `com.walktogether.app`
4. Download `google-services.json`
5. Replace placeholder at `flutter_app/android/app/google-services.json`
6. Enable Cloud Messaging

**Verify:**
- [ ] Firebase project created
- [ ] Android app registered (package: `com.walktogether.app`)
- [ ] `google-services.json` downloaded + placed locally
- [ ] `google-services.json` NOT committed (gitignored)
- [ ] FCM token generated on device
- [ ] Push notification received on device
- [ ] Notification tap opens app

### Step 3: Upload to Play Console (1 hour)

**Why:** Testers need to install from Play Store, not sideload APK.

**How:** Follow `docs/phase28/PLAY_CONSOLE_CLOSED_TESTING_SETUP.md`:

1. Go to https://play.google.com/console
2. Create app: "WalkTogether — Safe Walking Companion"
3. Complete all App Content sections:
   - Privacy policy URL (must be live)
   - Data Safety form
   - Content rating (IARC questionnaire)
   - Target audience (18+)
   - Ads: No
4. Upload signed AAB to Internal Testing
5. Add store listing (icon, screenshots, description)
6. Add tester emails
7. Generate opt-in link

**Verify:**
- [ ] AAB accepted by Play Console
- [ ] All App Content sections completed
- [ ] Data Safety form completed
- [ ] Content rating: Everyone
- [ ] Privacy policy URL live
- [ ] Support email added
- [ | Screenshots uploaded
- [ ] Internal testing track active
- [ ] Tester emails added (start with 5–10 internal)
- [ ] Play testing link generated
- [ ] Testers can install from link

### Step 4: Recruit testers (1–2 weeks)

**Target:** 20–50 Android testers across 8 profiles.

**How:** Use `docs/phase28/TESTER_RECRUITMENT_LIST_TEMPLATE.md`:

1. Copy the template to a spreadsheet
2. Recruit from: friends/family, walking groups, university students, community centers, social media
3. Collect: name, email, phone, location, device model, Android version, preferred language, tester group
4. Add tester emails to Play Console
5. Send onboarding message (`docs/phase28/TESTER_ONBOARDING_MESSAGE.md`)

**Tester groups to recruit:**

| Group | Target | Status |
|---|---|---|
| City users | 10–15 | [ ] Recruited |
| Small-town users | 5–10 | [ ] Recruited |
| Village/manual-location | 3–5 | [ ] Recruited |
| Women safety testers | 5–8 | [ ] Recruited |
| Host testers | 2–3 | [ ] Recruited |
| Group walk testers | 3–5 | [ ] Recruited |
| Multilingual testers | 5–8 | [ ] Recruited |
| Low-density area testers | 2–3 | [ ] Recruited |

**Verify:**
- [ ] 20+ testers recruited
- [ ] All 8 groups represented
- [ ] Play Console invites sent
- [ ] Testers accepted invites
- [ ] Testers installed app

### Step 5: Execute beta test scenarios (2 weeks)

**How:** Send testers the `docs/phase28/BETA_TEST_SCENARIOS.md` checklist.

Each tester completes:

**Basic (15 min):**
- [ ] Install app
- [ ] Signup/login (OTP)
- [ ] Profile setup
- [ ] GPS location
- [ ] Manual village/town location
- [ ] Settings
- [ ] Logout

**Walk flow (30 min — needs 2 testers):**
- [ ] View nearby walker
- [ ] Send walk request
- [ ] Accept/reject request
- [ ] Chat
- [ ] Start walk
- [ ] Safety share toggle
- [ ] SOS test (with disclaimer)
- [ ] End walk
- [ ] Rating
- [ ] Report/block

**Community (15 min):**
- [ ] Group walk list/detail
- [ ] Join group walk
- [ ] Group chat
- [ ] Club list/detail
- [ ] Join club

**Privacy (15 min):**
- [ ] Privacy request
- [ ] Data export
- [ ] Account deletion request
- [ ] Appeal screen

**Language (10 min):**
- [ ] English
- [ ] Hindi
- [ ] One regional language
- [ ] Arabic RTL (if possible)

### Step 6: Monitor safety daily (2 weeks)

**How:** Follow `docs/phase28/BETA_SAFETY_MONITORING_SOP.md` + update `docs/phase29/SAFETY_MONITORING_REPORT.md` daily.

Daily checklist:
- [ ] Check SOS events (all tests? any real?)
- [ ] Check reports filed
- [ ] Check blocks
- [ ] Check flagged messages
- [ ] Check appeals
- [ ] Check safety review tasks
- [ ] Check privacy requests
- [ ] Check deletion requests
- [ ] Check safety feedback

**Rules:**
- Manually review every safety issue
- No automation-only punishment
- Confirm no exact location leakage
- Document any real incident

### Step 7: Triage bugs (ongoing)

**How:** Update `docs/phase29/REAL_DEVICE_BUG_REPORT.md` as bugs come in.

Fix priority:
1. P0 (crash, SOS broken, privacy leak) — same day
2. Safety P1 (safety flow broken) — 24 hours
3. Auth/location/chat P1 — 48 hours
4. Privacy/export/deletion — 1 week
5. Group/club — 1 week
6. i18n/RTL — next build
7. UI polish — V1.8

### Step 8: Release patch if needed

If P0/P1 bugs are fixed:
1. Increment versionCode (27 → 28)
2. Update release notes (`docs/phase29/V1_8_BETA_PATCH_RELEASE_NOTES.md`)
3. Rebuild signed AAB
4. Upload patch to Play Console
5. Notify testers
6. Retest fixed flows

### Step 9: Collect metrics (daily)

**How:** Fill `docs/phase29/BETA_METRICS_REVIEW.md` with real data.

Track:
- Installs, signups, OTP success rate
- Walk requests, chats, walks completed
- SOS tests, reports, blocks
- Group joins, club joins, feedback
- Crashes, ANRs, uninstall rate

### Step 10: Make go/no-go decision

**How:** Fill `docs/phase29/PHASE_29_GO_NO_GO_DECISION.md` with real beta data.

**GO only if ALL 12 criteria pass:**
1. No open P0 bugs
2. No open safety P1 bugs
3. Crash-free sessions ≥ 95%
4. OTP success rate ≥ 95%
5. Location flow reliable
6. SOS/report/block verified on device
7. Privacy/export/deletion work
8. No exact location leak
9. Admin monitoring works
10. Core walk flow completes (≥ 50% of testers)
11. Play Console has no blocker
12. All features remain free

## Summary

| Category | Status |
|---|---|
| App code quality | ✅ Verified (dart analyze: 0 issues) |
| App feature completeness | ✅ Verified (22 screens, 24 routes, 40 API methods) |
| Build artifacts | ✅ Verified (debug APK, release APK, release AAB) |
| Security | ✅ Verified (no secrets, no admin APIs, free product scan clean) |
| GitHub repository | ✅ Verified (pushed, no secrets committed) |
| Release keystore | ⏳ Requires human action |
| Firebase production config | ⏳ Requires human action |
| Play Console upload | ⏳ Requires human action |
| Tester recruitment | ⏳ Requires human action |
| Real device testing | ⏳ Requires human action |
| Safety monitoring | ⏳ Requires human action |
| Bug triage with real bugs | ⏳ Requires human action |
| Metrics with real data | ⏳ Requires human action |
| Go/no-go decision | ⏳ Requires real beta data |

## Free product promise

WalkTogether is and will always be 100% free for everyone. No payments, subscriptions, premium features, ads, or monetization. Safety is not a paid feature — it's a right. Verified by automated scan: 0 forbidden terms in source code.
