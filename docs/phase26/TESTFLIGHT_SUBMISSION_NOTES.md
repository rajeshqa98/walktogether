# TestFlight Submission Notes

**Phase:** 26
**Status:** Ready — pending macOS + Xcode build + upload
**Last updated:** 2026-07-06
**Bundle ID:** `com.walktogether.app`
**Version:** 1.7.0 (build 26)
**IPA file:** `build/ios/ipa/walktogether.ipa`

## Environment limitation

**The iOS build + upload requires macOS 13+ with Xcode 15+ and an Apple Developer account ($99/year).** This environment does not have macOS. All configuration files are ready; the build + upload must be performed on a Mac.

See `IOS_TESTFLIGHT_CHECKLIST.md` for the exact build commands.

## Pre-submission checklist

### App build

- [ ] `flutter build ipa --release` succeeds on a Mac
- [ ] IPA is signed with a valid Apple Distribution certificate
- [ ] `GoogleService-Info.plist` is placed at `ios/Runner/`
- [ ] APNs authentication key is uploaded to Firebase Console
- [ ] `DEMO_LOGIN=false` dart-define is set in build command

### App Store Connect setup

- [ ] Apple Developer account active ($99/year)
- [ ] App created in App Store Connect with bundle ID `com.walktogether.app`
- [ ] App name: "WalkTogether — Safe Walking Companion"
- [ ] Primary language: English
- [ ] Bundle ID: `com.walktogether.app`
- [ ] SKU: `walktogether2026`

### App Store listing

- [ ] **App name:** WalkTogether — Safe Walking Companion
- [ ] **Subtitle:** Find safe, verified walking partners nearby
- [ ] **Description:** (see below)
- [ ] **Keywords:** walking, walker, companion, safety, partner, group walk, walking club, morning walk
- [ ] **Support URL:** https://walktogether.app/support
- [ ] **Marketing URL:** https://walktogether.app (optional)
- [ ] **Privacy policy URL:** https://walktogether.app/privacy-policy
- [ ] **App icon:** 1024x1024 PNG (no alpha, no rounded corners)
- [ ] **Screenshots:** required for 6.7" (iPhone 15 Pro Max) + optional for other sizes
- [ ] **App preview video:** optional but recommended (15-30 seconds)

### Description (for App Store listing)

```
WalkTogether is a 100% free, safety-first walking companion app. Find verified walking partners nearby, join group walks, and build walking clubs in your city, town, or village.

WHY WALKTOGETHER?

• 100% FREE — No payments, no subscriptions, no premium features, no ads. Safety is not a paid feature — it's a right.

• SAFETY-FIRST — Every walker is phone-verified. SOS button for emergencies. Safety share lets a trusted contact track your walk. Report and block anyone who makes you uncomfortable.

• COMMUNITY-FIRST — Join group walks in your area. Create or join walking clubs (morning walkers, evening walkers, women-only, senior walkers, dog walkers). Become a community host.

• GLOBAL — Available in 9 languages: English, हिन्दी, తెలుగు, தமிழ், ಕನ್ನಡ, বাংলা, Español, العربية, Français.

• CITY / TOWN / VILLAGE — Whether you're in a major city or a small village, WalkTogether works.

FEATURES

• Phone OTP login
• Nearby walker discovery with privacy controls
• Walk requests with safety preferences
• Real-time chat with automatic moderation
• Group walks + walking clubs
• SOS safety button + safety share
• Report + block
• Appeal system for moderation decisions
• Privacy requests: download your data, delete your account
• 14-day account deletion grace period
• Location privacy: exact coordinates never shared

FREE PRODUCT PROMISE

WalkTogether is and will always be free for everyone. No payments. No subscriptions. No premium features. No ads. Safety is not a paid feature — it's a right.

PRIVACY

• Your exact location is never shared with other users
• You can hide from nearby results at any time
• You can download all your data as JSON
• You can delete your account with a 14-day grace period

SUPPORT

Email: support@walktogether.app
Privacy policy: https://walktogether.app/privacy-policy
Terms of service: https://walktogether.app/terms-of-service
```

## Apple privacy labels

Fill out the App Privacy → Data Types form in App Store Connect:

### Data collected

| Data type | Use | Linked to user | Used for tracking |
|---|---|---|---|
| Contact Info — Phone Number | App functionality (login) | Yes | No |
| Contact Info — Email | App functionality (account recovery) | Yes | No |
| Contact Info — Name | App functionality (profile) | Yes | No |
| Location — Coarse | App functionality (nearby matching) | Yes | No |
| Photos or Videos | App functionality (profile photo) | Yes | No |
| User Content — Other User Content (chat) | App functionality | Yes | No |
| Identifiers — Device ID | App functionality (fraud prevention) | Yes | No |
| Usage Data | Analytics | No | No |

### Data NOT collected

- Exact location (only coarse distance)
- Background location
- Contacts
- Financial info
- Health data (beyond age range)
- Browsing history
- Search history
- Sensitive info

### Data practices

- **Encryption:** All data in transit uses HTTPS. Session token stored in iOS Keychain.
- **Data deletion:** Users can delete their account from Settings. 14-day grace period.
- **Data sharing:** No data sold. No advertising SDKs.
- **Tracking:** WalkTogether does NOT track users for advertising.

## App review information

### Review notes

```
WalkTogether is a 100% free, safety-first walking companion app.

LOGIN:
- Enter a real phone number with country code (e.g. +919876543210)
- Tap "Send OTP" — a 6-digit code will be sent via SMS
- Enter the code to log in
- For review: use test number +919999900000 (contact support@walktogether.app for OTP)

LOCATION:
- App asks for "While Using" location only
- Never requests "Always" permission (no background tracking)
- If denied, manual city entry is available

SAFETY:
- SOS button creates a safety event visible to admin team
- SOS does NOT auto-call emergency services — user must call local number
- Report and Block available in chat + walker detail screens

PRIVACY:
- Download data from Settings → "Download my data"
- Delete account from Settings → "Delete my account" (14-day grace period)
- Safety events preserved for safety/legal reasons

NO ADS, NO PAYMENTS:
- 100% free for everyone
- No in-app purchases
- No subscription
- No advertising
- All features free, including safety
```

### Reviewer credentials

- **Phone:** `+919999900000` (demo number — contact support for OTP)
- **Or:** any real phone number (OTP sent via SMS)

### Contact info

- **Support email:** support@walktogether.app
- **Support URL:** https://walktogether.app/support
- **Privacy policy URL:** https://walktogether.app/privacy-policy

## TestFlight setup

### Internal testers

- Up to 25 internal testers (Apple Developer team members)
- No beta app review required
- Instant availability after upload

### External testers

- Up to 10,000 external testers per testing group
- Beta app review required for first build of each version (24-48 hours)
- Testers receive email invite with TestFlight code

### TestFlight information

Fill out in App Store Connect → TestFlight → Test Information:

- **Test details:** "WalkTogether V1.7.0 — Phase 26 mobile hardening release"
- **What to test:** OTP login, location permission, push notifications, SOS, chat, group walks, clubs, privacy requests, account deletion
- **Feedback email:** support@walktogether.app
- **Privacy policy URL:** https://walktogether.app/privacy-policy

## Submission steps

1. [ ] Build IPA on a Mac: `flutter build ipa --release --dart-define=...`
2. [ ] Upload to App Store Connect:
   ```bash
   xcrun altool --upload-app \
       -f build/ios/ipa/walktogether.ipa \
       -t ios \
       -u "your-apple-id@example.com" \
       -p "app-specific-password"
   ```
   Or use the Transporter app from Mac App Store.
3. [ ] Wait for build processing (10-30 minutes)
4. [ ] In App Store Connect → TestFlight → select the build
5. [ ] Fill out test information
6. [ ] Add internal testers (team members)
7. [ ] Submit for Beta App Review (first build only)
8. [ ] After approval, add external testing group
9. [ ] Testers receive TestFlight invite email
10. [ ] Collect feedback via in-app feedback screen
11. [ ] Fix issues, bump build number to 27, re-upload
12. [ ] After 14 days of stable TestFlight testing, submit to App Review for production

## App Store review (production)

After TestFlight testing is complete:

1. [ ] Submit to App Review from App Store Connect → App Store → Submit for Review
2. [ ] Answer App Review questions (ads, age rating, etc.)
3. [ ] Wait for review (typically 24-48 hours, can be up to 7 days)
4. [ ] If rejected, address feedback and resubmit
5. [ ] If approved, release immediately or schedule staged rollout

## Common rejection reasons + prevention

### Rejection: "App uses location in background"

**Prevention:** WalkTogether only uses foreground location. `UIBackgroundModes` does NOT include `location`. The location service uses `whileInUse` permission only.

### Rejection: "App requires login but no test account provided"

**Prevention:** Provide test credentials in the review notes section. Use `+919999900000` + contact support for OTP.

### Rejection: "App contains user-generated content without moderation"

**Prevention:** WalkTogether has automated moderation (159 banned terms across 10 languages) + human review. Mention this in the review notes.

### Rejection: "App does not explain why it needs location"

**Prevention:** `NSLocationWhenInUseUsageDescription` clearly explains: "WalkTogether uses your location only to find nearby walking partners within your chosen radius. Your exact location is never shared with other users — only approximate distance is shown. We never track you in the background."

### Rejection: "App contains paid features"

**Prevention:** WalkTogether has NO paid features. The app description, review notes, and IARC questionnaire all clearly state "100% free, no in-app purchases, no subscriptions."

## Free product compliance

WalkTogether is 100% free. The App Store listing must reflect this:

- **No "In-App Purchases" section** on the App Store listing
- **Description includes** "100% FREE — No payments, no subscriptions, no premium features, no ads"
- **Apple privacy labels** show no financial data collected
- **Review notes** explicitly state "No in-app purchases, no subscription, no advertising"

If Apple App Review asks about monetization, the response is: "WalkTogether is a free community app. There are no in-app purchases, no subscriptions, and no ads. The app is funded by grants and donations."

## Acceptance criteria

- [ ] IPA builds + signs successfully on a Mac
- [ ] App Store Connect listing is complete
- [ ] Apple privacy labels are filled out
- [ ] Review notes + test credentials are provided
- [ ] TestFlight build is uploaded + processed
- [ ] Internal testers are added
- [ ] Beta App Review is submitted
- [ ] No paid/premium language in listing or app
