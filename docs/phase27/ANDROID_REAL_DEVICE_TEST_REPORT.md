# Android Real Device Test Report

**Phase:** 27C
**Status:** Build-verified; physical device test deferred to beta tester
**Last updated:** 2026-07-06

## Overview

The WalkTogether Android app builds successfully as debug APK (90MB), release APK (23.3MB), and release AAB (23.4MB). The app is ready for installation on a physical Android device for real-device QA.

This report documents what was verified in the build environment and what must be verified on a physical device during closed beta.

## Build environment

| Component | Version |
|---|---|
| Flutter SDK | 3.24.0 (stable) |
| Dart SDK | 3.5.0 |
| Java (JDK) | Temurin 17.0.13 |
| Android SDK | platform-34, build-tools 34.0.0 |
| Gradle | 8.7 |
| Android Gradle Plugin | 8.1.0 |
| Kotlin | 1.9.0 |

## Build verification (passed in build environment)

- ✅ `flutter pub get` — succeeded
- ✅ `dart analyze` — No issues found
- ✅ `dart format .` — 32 files formatted
- ✅ `flutter build apk --debug` — 90MB APK
- ✅ `flutter build apk --release` — 23.3MB APK
- ✅ `flutter build appbundle --release` — 23.4MB AAB
- ✅ APK file type: "Android package (APK), with gradle app-metadata.properties"
- ✅ AAB file type: "Zip archive data" (correct AAB format)
- ✅ Package name: `com.walktogether.app`
- ✅ Version: 1.7.0 (versionCode 27)

## Physical device test checklist

The following must be verified on a physical Android device during closed beta. Testers should install `app-release.apk` and work through this checklist.

### 1. App startup

- [ ] App installs without error
- [ ] App icon appears in launcher with WalkTogether logo
- [ ] App label shows "WalkTogether"
- [ ] Splash screen renders
- [ ] No startup crash
- [ ] Login screen loads within 3 seconds

### 2. Login + OTP

- [ ] Phone number input accepts international format (+prefix)
- [ ] "Send OTP" button works
- [ ] OTP received via SMS (or dev code in dev mode)
- [ ] OTP input field accepts 6 digits
- [ ] "Verify & continue" button works
- [ ] Invalid OTP shows error message
- [ ] Resend cooldown timer works (30s)
- [ ] Session persists after app restart
- [ ] Demo login button NOT visible in release build

### 3. Profile setup

- [ ] Name input works
- [ ] Age range dropdown works
- [ ] Gender dropdown works
- [ ] Bio input works
- [ ] "Continue" button saves + navigates to location

### 4. Location

- [ ] Location permission screen loads
- [ ] "Use my GPS location" button prompts for permission
- [ ] "Enter location manually" shows village/town/city/district/state fields
- [ ] Saving manual location navigates to home
- [ ] City field is required (validation works)

### 5. Home screen

- [ ] Bottom navigation works (Nearby / Groups / Clubs / More)
- [ ] Nearby walkers list loads (or shows empty state if no walkers)
- [ ] Settings icon navigates to Settings
- [ ] Notifications icon navigates to Notifications
- [ ] Pull-to-refresh works on nearby list

### 6. Walker detail + walk request

- [ ] Tapping a walker opens detail screen
- [ ] Walker name, distance, trust score visible
- [ ] Verification badge shows if verified
- [ ] Message input works
- [ ] "Send walk request" button works
- [ ] Success message appears
- [ ] Navigation returns to home

### 7. Requests inbox

- [ ] Incoming tab shows received requests
- [ ] Outgoing tab shows sent requests
- [ ] Accept button works (incoming)
- [ ] Decline button works (incoming)
- [ ] Chat icon appears after acceptance
- [ ] Tapping chat opens chat screen

### 8. Chat

- [ ] Messages load (or empty state)
- [ ] Message input works
- [ ] Send button works
- [ ] Sent message appears immediately (optimistic)
- [ ] "Start walk" button visible after acceptance
- [ ] Tapping start walk navigates to walk session

### 9. Walk session + SOS

- [ ] Walk session screen loads
- [ ] SOS button visible (red, prominent)
- [ ] SOS disclaimer text visible
- [ ] Tapping SOS shows confirmation dialog
- [ ] Confirming SOS triggers safety event
- [ ] "SOS triggered" message appears
- [ ] Safety share toggle works
- [ ] "End walk" button works
- [ ] Navigates to post-walk screen

### 10. Post-walk

- [ ] Star rating works (1-5 stars)
- [ ] "Submit rating" button works
- [ ] Report/block expansion tile works
- [ ] Radio buttons for report reason work
- [ ] "Submit report" button works
- [ ] "Block user" button works
- [ ] "Back to home" navigates to home

### 11. Groups + clubs

- [ ] Groups tab loads
- [ ] Group walk list loads (or empty state)
- [ ] Tapping a group walk opens detail
- [ ] Join/Leave button works
- [ ] Group chat link appears after joining
- [ ] Clubs tab loads
- [ ] Club list loads (or empty state)
- [ ] Tapping a club opens detail
- [ ] Join/Leave club button works

### 12. Settings

- [ ] Settings screen loads
- [ ] Language picker shows 9 languages
- [ ] Selecting a language changes UI
- [ ] Arabic selection flips layout to RTL
- [ ] "Hide me from nearby" toggle works
- [ ] "Download my data" works
- [ ] "Privacy requests" navigates to privacy screen
- [ ] "My appeals" navigates to appeals screen
- [ ] "Delete my account" shows confirmation dialog
- [ ] Confirming deletion starts 14-day grace period
- [ ] "Log out" works + returns to login

### 13. Account status

- [ ] Banned user sees account-status screen
- [ ] Suspended user sees account-status screen
- [ ] Deletion-pending user sees account-status screen
- [ ] Appeal link works
- [ ] Cancel deletion button works (deletion-pending)
- [ ] Logout button works

### 14. Notifications

- [ ] Notifications screen loads
- [ ] Unread notifications highlighted
- [ ] Read notifications show normally

### 15. Offline + error states

- [ ] No internet → error message + retry
- [ ] API unavailable → error message
- [ ] Session expired → redirect to login
- [ ] Empty states show for no walkers/groups/clubs/notifications

## Known limitations

1. **Realtime socket:** Socket.io connection requires the backend socket service running. In beta, chat messages may not arrive in real-time; manual refresh may be needed.
2. **Push notifications:** FCM requires a real `google-services.json` (currently placeholder). Push won't work until real Firebase config is added.
3. **GPS location:** The `geolocator` package is included in pubspec but the location service is currently a stub. GPS-based location will be added once device testing confirms the build is stable.
4. **i18n completeness:** V1.7 includes safety-critical keys for all 9 languages. Full UI translation (518 keys matching web) is planned for V1.8.

## Acceptance criteria

- ✅ Debug APK builds (90MB)
- ✅ Release APK builds (23.3MB)
- ✅ Release AAB builds (23.4MB)
- ✅ App package name correct (`com.walktogether.app`)
- ✅ App version correct (1.7.0, versionCode 27)
- ⏳ Physical device install — to be verified by beta tester
- ⏳ Safety flows on device — to be verified by beta tester
- ✅ No paid/premium language
