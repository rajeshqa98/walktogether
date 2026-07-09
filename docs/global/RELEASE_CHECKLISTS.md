# WalkTogether — Android Release Checklist (Global)

## Pre-Build
- [ ] Flutter SDK ≥3.2.0 installed
- [ ] `flutter pub get` succeeds
- [ ] `dart analyze` passes
- [ ] `API_BASE_URL` set to production HTTPS URL in `lib/core/config.dart`
- [ ] `SOCKET_URL` set to production socket.io URL
- [ ] `google-services.json` updated with production Firebase project
- [ ] OTP provider set to MSG91/Twilio (NOT dev)
- [ ] Backend `/api/health` returns 200
- [ ] Backend `/api/ready` returns 200
- [ ] Backend `/api/feature-flags` returns correct values
- [ ] `PILOT_MODE=invite_only` in backend env
- [ ] `SOS_TEST_MODE=false` in backend env

## Build Configuration
- [ ] `applicationId` = `com.walktogether.app`
- [ ] App name = "WalkTogether"
- [ ] App icon generated (all densities)
- [ ] Splash screen configured
- [ ] `AndroidManifest.xml` permissions: FINE_LOCATION, COARSE_LOCATION, POST_NOTIFICATIONS, INTERNET, WAKE_LOCK, VIBRATE
- [ ] No `ACCESS_BACKGROUND_LOCATION` permission
- [ ] Network security config uses HTTPS for production
- [ ] ProGuard/R8 minification enabled for release
- [ ] Release keystore generated and configured
- [ ] `key.properties` file created with keystore credentials

## Build & Sign
- [ ] `flutter build appbundle --release` succeeds
- [ ] AAB file generated in `build/app/outputs/bundle/release/`
- [ ] AAB signed with release keystore
- [ ] Install on physical Android device and verify core flows

## Google Play Console
- [ ] App created in Play Console (package: com.walktogether.app)
- [ ] App name: "WalkTogether — Find Safe Walking Partners"
- [ ] Category: Health & Fitness
- [ ] Content rating: Teen (UGC with moderation)
- [ ] Target audience: 18+
- [ ] Ads declaration: No ads, no ad SDKs
- [ ] Data Safety form completed (see GOOGLE_PLAY_REVIEW_NOTES.md)
- [ ] Privacy Policy URL set: https://walktogether.app/privacy
- [ ] Support email: support@walktogether.app
- [ ] Store listing copy filled (see STORE_LISTING_COPY.md)
- [ ] Screenshots uploaded (minimum 2, recommended 6)
- [ ] Feature graphic uploaded (1024x500)
- [ ] App icon uploaded (512x512)

## Country Availability
- [ ] Set country availability: ALL countries (global launch)
- [ ] Or selectively enable: India, US, UK, Singapore, UAE, Australia (+ expand weekly)

## Closed Testing → Production
- [ ] 14-day closed testing completed (Phase 11)
- [ ] Minimum 12 testers participated
- [ ] Feedback collected and documented
- [ ] Production access application submitted (if new account)
- [ ] Production access approved
- [ ] Production release created from signed AAB
- [ ] Staged rollout: start at 10%, increase to 100% over 7 days

## Post-Launch Monitoring
- [ ] Crash reporting: Firebase Crashlytics enabled
- [ ] ANR monitoring: Play Vitals checked daily
- [ ] Review monitoring: Play Console reviews checked daily
- [ ] Feedback monitoring: /admin/feedback checked daily
- [ ] Safety monitoring: /admin/safety-events checked daily
- [ ] Analytics: /admin/analytics checked daily

---

# WalkTogether — iOS Release Checklist (Global)

## Status: ⚠️ DEFERRED

iOS build requires macOS + Xcode, which is not available in this development environment. The Flutter source code is complete and ready to build. When a macOS environment is available, follow this checklist.

## Pre-Build (requires macOS)
- [ ] macOS with Xcode 15+
- [ ] Flutter SDK ≥3.2.0
- [ ] `flutter pub get` succeeds
- [ ] `dart analyze` passes
- [ ] `API_BASE_URL` set to production HTTPS URL (iOS requires HTTPS)
- [ ] `GoogleService-Info.plist` added to `ios/Runner/`
- [ ] Firebase project configured for iOS
- [ ] APNs key configured in Firebase (for FCM on iOS)

## Xcode Configuration
- [ ] Bundle identifier: `com.walktogether.app`
- [ ] Display name: "WalkTogether"
- [ ] App icon generated (all required sizes: 29pt, 40pt, 60pt, 76pt, 87pt, 80pt, 120pt, 152pt, 167pt, 180pt, 1024pt)
- [ ] Launch screen configured
- [ ] `Info.plist` includes:
  - `NSLocationWhenInUseUsageDescription` with privacy-safe text
  - `UIBackgroundModes`: `remote-notification`
  - Portrait-only orientation
- [ ] No `NSLocationAlwaysAndWhenInUseUsageDescription` (no background location)
- [ ] Signing team configured
- [ ] Push notification capability enabled
- [ ] Signing & Capabilities: Automatic signing or manual with provisioning profile

## Build & Archive
- [ ] `flutter build ios --release` succeeds
- [ ] Open `ios/Runner.xcworkspace` in Xcode
- [ ] Product → Archive
- [ ] Archive succeeds without errors
- [ ] Upload to App Store Connect: Distribute App → App Store Connect

## App Store Connect
- [ ] App record created
- [ ] App name: "WalkTogether — Find Safe Walking Partners"
- [ ] Category: Health & Fitness
- [ ] Screenshots uploaded:
  - 6.7" (iPhone 15 Pro Max): 1290 x 2796 px
  - 6.5" (iPhone 11 Pro Max): 1242 x 2688 px
  - 5.5" (if required): 1242 x 2208 px
- [ ] App description filled (see STORE_LISTING_COPY.md)
- [ ] Keywords: walking partner, walking buddy, safe walk, community walks
- [ ] Support URL: https://walktogether.app/support
- [ ] Privacy Policy URL: https://walktogether.app/privacy
- [ ] Privacy nutrition labels filled (see APP_STORE_REVIEW_NOTES.md)
- [ ] App Review notes filled (see APP_STORE_REVIEW_NOTES.md)
- [ ] Reviewer demo credentials provided

## Privacy Nutrition Labels
- **Data Used to Track You:** None
- **Data Linked to You:**
  - Contact Info: Phone Number (authentication)
  - Location: Precise Location (nearby matching — NOT shared with other users)
  - User Content: Chat messages (between matched users only)
  - Identifiers: Push notification token
  - Usage Data: Analytics events

## TestFlight
- [ ] Build uploaded and processed
- [ ] Internal testers added (Apple Developer team)
- [ ] External testing group created: "Global Pilot"
- [ ] Tester onboarding message sent (see BETA_TESTING_PLAN.md)
- [ ] Build released to TestFlight

## Country Availability (App Store Connect)
- [ ] Set availability: ALL countries (global launch)
- [ ] Or selectively enable: India, US, UK, Singapore, UAE, Australia

## App Review Preparation
- [ ] Reviewer demo credentials documented
- [ ] Location privacy model explained in review notes
- [ ] SOS testing instructions provided (does NOT call emergency services)
- [ ] UGC moderation explanation provided
- [ ] Account deletion path documented
- [ ] Notification permission explanation provided

## Post-Approval
- [ ] App approved by Apple Review
- [ ] Release version set in App Store Connect
- [ ] Phased rollout: Day 1 (1%), Day 2-7 (gradual increase to 100%)
- [ ] Monitor: crash reports, reviews, feedback, safety events
