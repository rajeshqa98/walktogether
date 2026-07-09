# iOS TestFlight Checklist

**Phase:** 26
**Status:** Ready — pending macOS + Xcode build
**Last updated:** 2026-07-06
**Bundle identifier:** `com.walktogether.app`
**Version:** 1.7.0 (build 26)

## Environment limitation

**The iOS build (`flutter build ios`) requires macOS 13+ with Xcode 15+ and CocoaPods.** This environment does not have macOS, so the iOS build could not be executed here. However, all iOS configuration files are ready and the build can be run on any Mac with the Flutter SDK installed.

This document covers the complete iOS TestFlight readiness checklist. The actual build + upload must be performed on a Mac.

## Pre-build checklist

### App identity

- [x] **Bundle identifier:** `com.walktogether.app` (set in Xcode → Runner → General → Bundle Identifier; referenced via `$(PRODUCT_BUNDLE_IDENTIFIER)` in Info.plist)
- [x] **App display name:** "WalkTogether" (set in Info.plist → `CFBundleDisplayName`)
- [x] **App name:** "WalkTogether" (set in Info.plist → `CFBundleName`)
- [x] **Version:** 1.7.0 (set in Info.plist → `CFBundleShortVersionString`)
- [x] **Build number:** 26 (set in Info.plist → `CFBundleVersion`)

### Launch screen

- [x] **Launch storyboard:** `LaunchScreen` (referenced in Info.plist → `UILaunchStoryboardName`)
- [ ] **Launch screen design:** The default Flutter launch screen is currently used. To customize, edit `ios/Runner/Base.lproj/LaunchScreen.storyboard` on a Mac.

### Privacy strings (Info.plist)

All required iOS privacy strings are present in `ios/Runner/Info.plist`:

- [x] **`NSLocationWhenInUseUsageDescription`** — "WalkTogether uses your location only to find nearby walking partners within your chosen radius. Your exact location is never shared with other users — only approximate distance is shown. We never track you in the background."
- [x] **`NSUserNotificationsUsageDescription`** — "WalkTogether sends notifications for walk requests, chat messages, group walk updates, and safety alerts. Safety alerts cannot be disabled."
- [x] **`NSUserTrackingUsageDescription`** — "WalkTogether does not track you for advertising. This permission is not used."
- [x] **`NSCameraUsageDescription`** — "WalkTogether uses the camera only for selfie verification to confirm your identity. The photo is never shared with other users."
- [x] **`NSPhotoLibraryUsageDescription`** — "WalkTogether needs photo library access only if you choose to upload a profile photo. We never access your photos without your explicit action."

### App Transport Security

- [x] **`NSAppTransportSecurity`** present
- [x] **`NSAllowsArbitraryLoads`** = `false` (HTTPS only in production)
- [x] **`NSExceptionDomains`** — localhost exception only (for iOS simulator dev testing)

### Background modes

- [x] **`UIBackgroundModes`** = `["fetch", "remote-notification"]`
- [x] **NOT included:** `location` (no background location tracking), `audio` (no background audio), `voip` (no VoIP calls)

### Orientation

- [x] **`UISupportedInterfaceOrientations`** = `["UIInterfaceOrientationPortrait"]` (portrait only on iPhone)
- [x] **`UISupportedInterfaceOrientations~ipad`** = all four orientations (iPad supports rotation)

### Other Info.plist keys

- [x] `LSRequiresIPhoneOS` = `true`
- [x] `UILaunchStoryboardName` = `LaunchScreen`
- [x] `UIMainStoryboardFile` = `Main`
- [x] `CADisableMinimumFrameDurationOnPhone` = `true` (ProMotion support)
- [x] `UIApplicationSupportsIndirectInputEvents` = `true`

### Firebase config

- [ ] **`GoogleService-Info.plist`** — NOT included in repo. Must be downloaded from Firebase Console and placed at `flutter_app/ios/Runner/GoogleService-Info.plist`:
  1. Go to https://console.firebase.google.com/
  2. Create/select WalkTogether Firebase project
  3. Add iOS app → bundle ID `com.walktogether.app`
  4. Download `GoogleService-Info.plist`
  5. Place at `flutter_app/ios/Runner/GoogleService-Info.plist`

### Notification capability

- [x] **APNs key:** Firebase Cloud Messaging uses APNs. You need to:
  1. In Apple Developer Console, create an APNs authentication key (not a certificate — keys don't expire)
  2. Upload the `.p8` key to Firebase Console → Project Settings → Cloud Messaging → iOS
  3. No additional iOS capability needed in Xcode — `remote-notification` background mode is already set

### App icon

- [ ] **App icon assets:** The `ios/Runner/Assets.xcassets/AppIcon.appiconset` directory needs to be populated with icon images. On a Mac, run:
  ```bash
  # Install flutter_launcher_icons (add to pubspec dev_deps)
  flutter pub run flutter_launcher_icons:main
  ```
  This generates all required icon sizes from a single source image.

## Build commands (macOS only)

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later (from Mac App Store)
- CocoaPods (`sudo gem install cocoapods`)
- Flutter SDK 3.2+
- Apple Developer account ($99/year)

### Step-by-step

```bash
# 1. Navigate to the Flutter app
cd /home/z/my-project/flutter_app

# 2. Install dependencies
flutter pub get

# 3. Install iOS pods
cd ios && pod install && cd ..

# 4. Open in Xcode (to configure signing)
open ios/Runner.xcworkspace

# In Xcode:
#   - Select Runner target → Signing & Capabilities
#   - Select your team (Apple Developer account)
#   - Set Bundle Identifier to com.walktogether.app
#   - Xcode will auto-create a provisioning profile

# 5. Build for iOS simulator (testing)
flutter build ios --debug --simulator

# 6. Build for physical device (release)
flutter build ios --release \
    --dart-define=API_BASE_URL=https://api.walktogether.app \
    --dart-define=SOCKET_URL=https://socket.walktogether.app \
    --dart-define=DEMO_LOGIN=false

# 7. Archive for TestFlight (in Xcode)
#   - Open ios/Runner.xcworkspace in Xcode
#   - Product → Archive
#   - Organizer window opens
#   - Distribute App → TestFlight & App Store

# Or via command line:
flutter build ipa --release \
    --dart-define=API_BASE_URL=https://api.walktogether.app \
    --dart-define=SOCKET_URL=https://socket.walktogether.app \
    --dart-define=DEMO_LOGIN=false
# Output: build/ios/ipa/walktogether.ipa

# 8. Upload to App Store Connect
xcrun altool --upload-app \
    -f build/ios/ipa/walktogether.ipa \
    -t ios \
    -u "your-apple-id@example.com" \
    -p "app-specific-password"
# Or use Transporter app from Mac App Store
```

## Apple privacy labels

When submitting to App Store Connect, fill out the App Privacy → Data Types form:

### Data collected

| Data type | Use | Linked to user | Used for tracking |
|---|---|---|---|
| Phone number | App functionality (login) | Yes | No |
| Email address | App functionality (account recovery) | Yes | No |
| Name | App functionality (profile) | Yes | No |
| Coarse location | App functionality (nearby matching) | Yes | No |
| Photos or videos (optional) | App functionality (profile photo) | Yes | No |
| User content (chat messages) | App functionality | Yes | No |
| Identifiers (device ID) | App functionality (fraud prevention) | Yes | No |
| Usage data | Analytics | No | No |

### Data NOT collected

- Exact location (only coarse distance shown to other users)
- Background location (foreground only)
- Contacts
- Financial info
- Health data
- Browsing history
- Search history
- Sensitive info

### Data practices

- **Encryption:** All data in transit uses HTTPS (TLS 1.2+). Session token stored in iOS Keychain.
- **Data deletion:** Users can delete their account from Settings. 14-day grace period before anonymization.
- **Data sharing:** No data sold to third parties. No advertising SDKs.
- **Tracking:** WalkTogether does NOT track users for advertising. `NSUserTrackingUsageDescription` is included for transparency but ATT prompt is never shown.

## TestFlight checklist

1. [ ] Apple Developer account active ($99/year)
2. [ ] App created in App Store Connect with bundle ID `com.walktogether.app`
3. [ ] `GoogleService-Info.plist` placed in `ios/Runner/`
4. [ ] APNs key uploaded to Firebase Console
5. [ ] App icon assets generated
6. [ ] Signing configured in Xcode (Team + Bundle Identifier)
7. [ ] `flutter build ipa --release` succeeds
8. [ ] IPA uploaded to App Store Connect
9. [ ] Build processing complete (10-30 minutes)
10. [ ] TestFlight information filled out:
    - **Test details:** "WalkTogether V1.7.0 — Phase 26 mobile hardening release"
    - **What to test:** OTP login, location permission, push notifications, SOS, chat, group walks, clubs, privacy requests, account deletion
    - **Feedback email:** support@walktogether.app
11. [ ] Internal testers added (up to 25 for internal; up to 10,000 for external)
12. [ ] External testing group created (optional)
13. [ ] Beta App Review submitted (required for first build; usually 24-48 hours)

## App review notes

Include this in the App Review Information section of App Store Connect:

```
WalkTogether is a 100% free, safety-first walking companion app.

LOGIN:
- Enter a real phone number (with country code, e.g. +919876543210)
- Tap "Send OTP" — a 6-digit code will be sent via SMS
- Enter the code to log in
- For review purposes, you may use the test number: +9199999000000
  (contact support@walktogether.app for the current OTP)

LOCATION:
- The app asks for "While Using" location permission only
- We never request "Always" permission (no background tracking)
- If you deny location, you can still use the app with manual city entry

SAFETY:
- SOS button creates a safety event visible to our admin team
- SOS does NOT auto-call emergency services — user must call local number
- Report and Block are available in every chat + walker detail screen

PRIVACY:
- Users can download their data from Settings → "Download my data"
- Users can delete their account from Settings → "Delete my account"
- 14-day grace period before personal data is anonymized
- Safety events, reports, and audit logs are preserved for safety reasons

NO ADS, NO PAYMENTS:
- WalkTogether is 100% free for everyone
- No in-app purchases
- No subscription
- No advertising
- All features are free, including safety features
```

## Support + privacy URLs

- **Support URL:** `https://walktogether.app/support` (must be live before submission)
- **Privacy policy URL:** `https://walktogether.app/privacy-policy` (must be live before submission)
- **Marketing URL:** `https://walktogether.app` (optional)

These must be set in App Store Connect → App Information.

## Reviewer/tester credentials

For App Review, provide a test account in the review notes:

- **Phone:** `+919999900000` (demo number)
- **OTP:** Contact support@walktogether.app for the current dev OTP
- Or use any real phone number — OTP will be sent via SMS

## iOS build limitation

**The iOS build cannot be run in this environment** because it requires macOS + Xcode. The configuration files (`Info.plist`, etc.) are ready. To build:

1. Copy the `flutter_app/` directory to a Mac
2. Install Flutter SDK + Xcode + CocoaPods
3. Place `GoogleService-Info.plist` in `ios/Runner/`
4. Run `flutter build ipa --release`
5. Upload via Xcode Organizer or `xcrun altool`

See the "Build commands (macOS only)" section above for the exact commands.

## Acceptance criteria

- [ ] `flutter build ios --release` succeeds on a Mac
- [ ] App installs on a real iPhone (iOS 14+)
- [ ] OTP login works end-to-end
- [ ] Location permission flow works (grant + deny)
- [ ] Push notification permission prompt appears only after user action
- [ ] SOS button creates a safety event
- [ ] App passes Apple Beta App Review
- [ ] TestFlight build is available to internal testers
- [ ] No "premium" / "subscription" / "paywall" language visible
- [ ] No crash on cold start
