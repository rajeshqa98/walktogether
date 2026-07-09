# V1.7 Mobile Release Notes

**Version:** 1.7.0 (mobile)
**Phase:** 26
**Release date:** 2026-07-06
**Status:** Ready for internal testing

## Overview

WalkTogether V1.7 Mobile is the first production-hardened release of the Flutter Android/iOS app. It aligns with the V1.7 web/PWA/backend platform (Phase 25), adding 14-day account deletion grace period, data export, privacy requests, appeals, local area page, host onboarding, 9-language i18n with Arabic RTL, push notifications, realtime socket, and full safety flows (SOS, report, block).

The app remains 100% free for everyone — no payments, subscriptions, premium features, ads, or monetization.

## What's new

### For users

#### Privacy + data rights

* **Download my data** — Settings → "Download my data" exports your profile, walks, groups, reports, appeals, feedback, and trust score history as JSON. Other users' phone/email/coordinates are excluded. Your own phone number is partially redacted (`+91*****4321`).
* **Delete my account** — Settings → "Delete my account" starts a 14-day grace period. You're immediately hidden from nearby results. After 14 days, your personal data is anonymized. Safety events, reports, appeals, and audit logs are preserved for safety/legal reasons. Cancel any time during the grace period.
* **Privacy requests** — New "Privacy requests" screen (Settings → "Privacy requests") lets you request data correction, appeal history copy, optional profile deletion, push token removal, or location data cleanup. Each request has a tracked SLA.

#### Appeals

* **My appeals** — Settings → "My appeals" shows your appeal history + lets you submit new appeals for account suspension, account ban, host suspension, group walk cancellation, club restriction, trust score review, or message moderation.

#### Local area page

* **Local area** — Settings → "Local area page" shows walkers nearby, total users, group walks, and clubs in your area. Shows "first walker" recommendation if you're the first in your area.

#### Community host

* **Become a host** — Settings → "Become a community host" walks you through a 4-step onboarding (welcome, about you, local area, community guidelines). Hosts can create group walks + clubs. Hosts do NOT get paid — WalkTogether is 100% free.

#### Language selection

* **9 languages** — Settings → "Language" lets you choose from English, हिन्दी, తెలుగు, தமிழ், ಕನ್ನಡ, বাংলা, Español, العربية, Français. Your choice persists across app restarts.
* **Arabic RTL** — when Arabic is selected, the entire app layout flips to right-to-left.

#### Account status screen

* **Banned/suspended/deletion-pending** — if your account is banned, suspended, or has a deletion pending, you'll see a clear account-status screen with the reason, an appeal link, and a cancel-deletion button (if applicable).

### For admins (via backend — not in mobile app)

The V1.7 backend (Phase 25) added 10 new admin pages + 19 new API endpoints. None of these are exposed in the mobile app — they're accessible only via the web admin at `/admin/*`.

## Safety features (preserved from V1.6)

* **SOS button** — creates a safety event visible to the admin safety queue. Does NOT auto-call emergency services — the user is directed to call local emergency number.
* **Safety share** — lets a trusted contact track your walk in real-time.
* **Report user** — available in every chat + walker detail screen.
* **Block user** — prevents further contact.
* **Walk preferences** — women-only, verified-only, daylight-only, public-place-only.
* **Automatic moderation** — 159 banned terms across 10 languages.
* **No auto-ban** — every ban requires admin review.

## Technical details

### Flutter app

* **Version:** 1.7.0+26
* **Min Android SDK:** 23 (Android 6.0)
* **Target Android SDK:** 34 (Android 14)
* **Min iOS:** 14.0
* **Languages:** Dart 3.2+
* **State management:** Riverpod 2.4+
* **Navigation:** GoRouter 13+
* **Networking:** Dio 5.4+ + Socket.io client 2.0+
* **Storage:** FlutterSecureStorage (Android Keystore / iOS Keychain)
* **Location:** Geolocator 10+ + Geocoding 2+
* **Push:** Firebase Cloud Messaging 14+ + flutter_local_notifications 16+
* **i18n:** custom module with 9 languages + RTL support

### Backend compatibility

This mobile app is compatible with the V1.7 backend (Phase 25). It connects to 34 REST endpoints + 10 socket events. All admin APIs are intentionally NOT exposed in the mobile app.

### Permissions

**Android:**
* `ACCESS_FINE_LOCATION` + `ACCESS_COARSE_LOCATION` (foreground only)
* `POST_NOTIFICATIONS` (Android 13+)
* `INTERNET` + `ACCESS_NETWORK_STATE`
* `WAKE_LOCK` + `RECEIVE_BOOT_COMPLETED` (FCM)
* `VIBRATE` (SOS alerts)
* `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_LOCATION` (safety share during active walk)

**iOS:**
* `NSLocationWhenInUseUsageDescription` (foreground only)
* `NSUserNotificationsUsageDescription`
* `NSCameraUsageDescription` (selfie verification)
* `NSPhotoLibraryUsageDescription` (profile photo, optional)
* `UIBackgroundModes`: `fetch` + `remote-notification` only

### Network security

* HTTPS only (`usesCleartextTraffic="false"` + network security config)
* Dev-only exception for `10.0.2.2` + `localhost` (emulator/simulator testing)
* Session token stored in secure storage (Android Keystore / iOS Keychain)
* No OTP codes logged
* No admin API calls in mobile app

### Demo login

* Demo login is available in debug builds only
* Release builds pass `--dart-define=DEMO_LOGIN=false` to disable it
* Login screen checks `AppConfig.demoLoginEnabled && !AppConfig.isReleaseBuild` before showing the demo button

## Known limitations

1. **iOS build requires macOS** — the iOS IPA must be built on a Mac with Xcode. The configuration files are ready; the build must be run on a Mac.
2. **Partial i18n** — V1.7 includes safety-critical + frequently-used keys for all 9 languages. Full UI translation (518 keys matching the web/PWA) is planned for V1.8.
3. **No dark mode** — V1.7 uses Material's light theme only. Dark mode planned for V1.8.
4. **No offline caching** — API calls fail when offline. Caching planned for V1.8.
5. **No certificate pinning** — HTTPS without certificate pinning. Pinning planned for V1.8.
6. **No deep links** — invite links from outside the app are not yet handled. Deep linking planned for V1.8.

## Free product promise

WalkTogether is and will always be free for everyone. This is verified by:

1. **Automated free-product compliance scan** (`scripts/phase26/static_verify.sh` check #6) — scans all Dart/Kotlin/XML/Plist files for `premium`, `subscription`, `paywall`, `in-app purchase`, `credit card`, `billing`. The only matches are `push-subscription` (a web-push technical term), which is explicitly excluded.
2. **Security review** (`scripts/phase26/security_review.sh` check #10) — same scan, same exclusions.
3. **Play Store / App Store listing** — explicitly states "100% FREE — No payments, no subscriptions, no premium features, no ads."
4. **IARC questionnaire** — answers "No" to in-app purchases and ads.
5. **Apple privacy labels** — no financial data collected.

No payments. No subscriptions. No premium features. No ads. No monetization. All features remain free, including safety features.

## Release tracks

### Android (Play Store)

1. **Internal testing** — up to 100 testers, no review required
2. **Closed testing** (alpha) — up to 100 testers per email list
3. **Open testing** (beta) — unlimited testers via opt-in link
4. **Production** — staged rollout (10% → 50% → 100% over 7 days)

### iOS (TestFlight)

1. **Internal testers** — up to 25 Apple Developer team members
2. **External testers** — up to 10,000 testers per group, Beta App Review required
3. **App Store** — full review, staged rollout

## Upgrade path

Existing V1.0 Flutter app users (if any) will be prompted to update. The V1.7 app is backwards-compatible with V1.0 backend APIs — no backend migration required.

## Documentation

* `MOBILE_HARDENING_REPORT.md` — overall hardening summary
* `FLUTTER_BUILD_VERIFICATION.md` — build commands + verification
* `MOBILE_API_ALIGNMENT_REPORT.md` — 34 endpoint alignment with backend
* `ANDROID_RELEASE_CHECKLIST.md` — Android Play Store readiness
* `IOS_TESTFLIGHT_CHECKLIST.md` — iOS TestFlight readiness
* `MOBILE_SECURITY_REVIEW.md` — 10-check security review
* `MOBILE_PERFORMANCE_REVIEW.md` — performance targets + profiling
* `MOBILE_I18N_RTL_QA.md` — 9-language + RTL QA
* `MOBILE_PUSH_REALTIME_QA.md` — push + socket QA
* `PLAY_STORE_SUBMISSION_NOTES.md` — Play Store listing + data safety
* `TESTFLIGHT_SUBMISSION_NOTES.md` — TestFlight + Apple privacy labels
* `PHASE_26_COMPLETION_REPORT.md` — phase completion summary

## Looking ahead

Phase 27 (future) may include:
* Full 518-key i18n translation
* Dark mode
* Offline caching + message queuing
* Certificate pinning
* Deep links (`walktogether://` + universal links)
* Background sync
* Voice / video calls (with end-to-end encryption)

For now, WalkTogether V1.7 Mobile is ready for internal testing on Android (Play Store) and iOS (TestFlight). Stay safe, walk together.
