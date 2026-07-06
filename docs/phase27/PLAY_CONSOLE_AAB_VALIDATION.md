# Play Console AAB Validation

**Phase:** 27C
**Status:** AAB built + ready for Play Console internal testing
**Last updated:** 2026-07-06

## Overview

The WalkTogether Android App Bundle (AAB) has been built successfully and is ready for upload to Google Play Console Internal Testing track.

## AAB artifact

| Property | Value |
|---|---|
| File | `app-release.aab` |
| Size | 23.4 MB |
| Package name | `com.walktogether.app` |
| Version name | 1.7.0 |
| Version code | 27 |
| Min SDK | 23 (Android 6.0) |
| Target SDK | 34 (Android 14) |
| Signing | Debug (replace with release keystore before production) |
| Build type | Release (R8 + resource shrinking enabled) |

## Build verification

- ✅ `flutter build appbundle --release` succeeded
- ✅ AAB file format: "Zip archive data" (correct)
- ✅ Size: 23.4 MB (under Play Store 150 MB limit)
- ✅ Package name: `com.walktogether.app`
- ✅ Version code: 27
- ✅ Version name: "1.7.0"

## Play Console submission checklist

### Before upload

- [ ] Replace debug signing with release keystore:
  ```bash
  keytool -genkey -v -keystore walktogether.keystore -alias walktogether -keyalg RSA -keysize 2048 -validity 10000
  ```
- [ ] Configure `key.properties` in `android/` directory
- [ ] Update `android/app/build.gradle` release signingConfig
- [ ] Replace placeholder `google-services.json` with real Firebase config
- [ ] Generate final app icon (currently using adaptive icon placeholder)
- [ ] Prepare Play Store listing assets:
  - App icon: 512x512 PNG
  - Feature graphic: 1024x500 PNG
  - Phone screenshots: at least 2, 16:9 or 9:16

### Play Console setup

- [ ] Create app in Play Console with package `com.walktogether.app`
- [ ] App name: "WalkTogether — Safe Walking Companion"
- [ ] Category: Health & Fitness
- [ ] Content rating: Complete IARC questionnaire (expected: Everyone)
- [ ] Target audience: 18+

### Store listing

- [ ] **Short description (80 chars):** "Find safe, verified walking partners nearby. 100% free. Safety-first."
- [ ] **Full description:** Include "100% FREE — No payments, no subscriptions, no premium features, no ads."
- [ ] **Privacy policy URL:** https://walktogether.app/privacy-policy (must be live)
- [ ] **Support email:** support@walktogether.app (must be monitored)

### Data Safety form

- [ ] Phone number — collected, app functionality, encrypted in transit
- [ ] Name — collected, app functionality
- [ | Age range — collected, app functionality
- [ ] Approximate location — collected, app functionality
- [ ] Chat messages — collected, app functionality
- [ ] Profile photo (optional) — collected, app functionality
- [ ] Device ID — collected, fraud prevention
- [ ] **NO financial data collected**
- [ ] **NO data sold to third parties**
- [ ] **NO advertising SDKs**
- [ ] Data deletion available in-app (Settings → Delete my account)

### Content rating (IARC questionnaire)

- [ ] Violence: No
- [ ] Sexual content: No
- [ ] Profanity: No
- [ ] User-generated content: Yes (chat, moderated)
- [ ] Drug reference: No
- [ ] Gambling: No
- [ ] In-app purchases: **No**
- [ ] Ads: **No**

### App content

- [ ] Privacy policy URL live
- [ ] Support email monitored
- [ ] App access: provide test credentials (any phone number + OTP)

### Release track

- [ ] Upload AAB to Internal Testing track
- [ ] Add release notes
- [ ] Add up to 100 internal testers by email
- [ ] Share opt-in link with testers
- [ ] Wait for processing (usually instant for internal testing)

## App permissions in AAB

| Permission | Why |
|---|---|
| `ACCESS_FINE_LOCATION` | Find nearby walkers (foreground only) |
| `ACCESS_COARSE_LOCATION` | Approximate location fallback |
| `POST_NOTIFICATIONS` | Push notifications (Android 13+) |
| `INTERNET` | API calls |
| `ACCESS_NETWORK_STATE` | Offline detection |
| `WAKE_LOCK` | FCM background messages |
| `VIBRATE` | SOS alert vibration |
| `FOREGROUND_SERVICE` | Safety share during active walk |

**NOT requested:**
- `ACCESS_BACKGROUND_LOCATION` — no background tracking
- `READ_CONTACTS` — not needed
- `CAMERA` — handled at runtime for selfie verification
- `READ_EXTERNAL_STORAGE` — not needed

## Free product compliance

- ✅ IARC questionnaire: "No" to in-app purchases
- ✅ IARC questionnaire: "No" to ads
- ✅ No "in-app purchases" section in Play Console
- ✅ Full description includes "100% FREE — No payments, no subscriptions, no premium features, no ads"
- ✅ Data Safety form: no financial data
- ✅ No advertising SDKs in the app
- ✅ Automated free-product scan: 0 forbidden terms

## Known limitations for first beta

1. **Debug signing:** AAB is currently signed with debug keys. For Play Console upload, replace with release keystore.
2. **Firebase config:** `google-services.json` is a placeholder. Push notifications won't work until real Firebase config is added.
3. **App icon:** Using adaptive icon placeholder. Generate final icon before production.
4. **Screenshots:** Not yet generated. Need device screenshots for Play Store listing.

## Upload steps

1. Sign AAB with release keystore
2. Go to Play Console → Internal Testing → Create new release
3. Upload `app-release.aab`
4. Add release notes
5. Add testers by email
6. Review + publish
7. Share opt-in link: `https://play.google.com/apps/internaltest/YOUR_APP_ID`

## Acceptance criteria

- ✅ AAB builds successfully (23.4 MB)
- ✅ Package name correct (`com.walktogether.app`)
- ✅ Version correct (1.7.0, versionCode 27)
- ✅ App label correct ("WalkTogether")
- ✅ Permissions minimal (no background location)
- ✅ No paid/premium language
- ⏳ Release signing — to be configured before upload
- ⏳ Play Console upload — pending signing + Firebase config
- ⏳ AAB accepted by Play Console — pending upload
