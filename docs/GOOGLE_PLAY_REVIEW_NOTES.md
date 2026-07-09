# WalkTogether — Google Play Review Notes

## App Information
- **Package Name:** com.walktogether.app
- **Category:** Health & Fitness
- **Content Rating:** Teen (user-generated content with moderation)
- **Target Audience:** 18+ (walking companion app)

---

## Data Safety Form

### Data Collected

| Data Type | Collected | Shared | Purpose |
|-----------|-----------|--------|---------|
| Location (approximate) | ✅ | ❌ Not shared with other users | Find nearby walkers |
| Phone number | ✅ | ❌ | OTP authentication |
| Name | ✅ | ✅ Visible on profile card | Profile |
| Age range | ✅ | ✅ Visible on profile card | Profile |
| Gender | ✅ | ✅ Visible on profile card | Women-only matching |
| Chat messages | ✅ | ✅ Between matched users only | Communication |
| Photos (profile) | Optional | ✅ Visible on profile | Profile |
| Push notification token | ✅ | ❌ | Send notifications |
| Analytics events | ✅ | ❌ | Product improvement |
| Feedback | ✅ | ❌ | Admin review only |

### Data Not Collected
- ❌ Background location (not requested)
- ❌ Exact home address
- ❌ Credit card / payment info
- ❌ Health/medical data
- ❌ Web browsing history
- ❌ Contacts list

### Encryption
All data in transit uses HTTPS/TLS. Data at rest is encrypted by the cloud provider.

### Data Deletion
Users can delete their account in Settings → Account → Delete account. Data is removed within 30 days.

---

## Location Permission Declaration

**Permission requested:** `ACCESS_FINE_LOCATION` + `ACCESS_COARSE_LOCATION`

**Justification:** Location is needed to find nearby walking partners. The app calculates approximate distance labels ("within 300m") and displays them to other users. Exact coordinates are never shared with other users.

**Foreground only:** We do NOT request `ACCESS_BACKGROUND_LOCATION`. Location is used only when the app is in the foreground.

**User-facing explanation (shown before permission request):**
*"WalkTogether uses your location only to find nearby walking partners. Your exact location is hidden until both users agree to walk together."*

---

## Notification Permission

**Permission requested:** `POST_NOTIFICATIONS` (Android 13+)

**Justification:** Notifications are used for walk requests, chat messages, and safety alerts (SOS). Safety alerts cannot be disabled when push is enabled.

**User-triggered:** Permission is requested only after the user taps "Enable" in Settings — not on first launch.

---

## Closed Testing Setup

### For New Developer Accounts (Personal)

Google Play requires:
1. **Minimum 12 testers** opted in to closed testing
2. **14 continuous days** of testing before production access
3. **Closed testing feedback** collection
4. **Production access application** with answers about testing

### Steps

1. **Create closed testing track** in Play Console
2. **Add tester email list** (minimum 12 Gmail addresses)
3. **Upload signed AAB** to closed testing track
4. **Share opt-in URL** with testers
5. **Collect feedback** for 14 days
6. **Apply for production access** with testing summary

### Tester Instructions (include in opt-in email)
```
WalkTogether Closed Testing — Tester Instructions

1. Open this link on your Android phone: [OPT-IN URL]
2. Join the testing program
3. Download WalkTogether from Google Play
4. Use "Continue as demo user" for quick access, OR:
   - Enter your phone number
   - Request OTP (any 4-6 digit code works in dev mode)
   - Verify and complete profile setup
5. Test the following scenarios:
   - Find nearby walkers
   - Send a walk request
   - Accept a walk request
   - Chat with your walking partner
   - Start a walk session
   - Test the SOS button (safe — does NOT call emergency services)
   - Rate your partner after the walk
   - Join a group walk
   - Join a walking club
   - Submit feedback
6. Report bugs to: bugs@walktogether.app
7. Report safety concerns to: safety@walktogether.app
```

---

## Content Rating Questionnaire

1. **Does the app contain user-generated content?** Yes (chat messages, profile bios)
2. **Is the user-generated content moderated?** Yes (auto-moderation + admin review)
3. **Does the app contain violence?** No
4. **Does the app contain sexual content?** No
5. **Does the app contain profanity?** No (auto-moderated)
6. **Does the app contain controlled substances?** No
7. **Does the app contain gambling?** No

**Expected rating:** Teen (12+) — due to user-generated content with moderation

---

## Target Audience

- **Target audience:** 18+ (walking companion app for adults)
- **Does the app attract children?** No — the app is not marketed to or designed for children
- **Is the app on Designed for Families?** No

---

## Ads Declaration

- **Does the app contain ads?** No
- **Does the app use advertising SDKs?** No

---

## Privacy Policy URL

The privacy policy must be hosted at a public URL. Suggested: `https://walktogether.app/privacy`

The privacy policy is included in this repository at `docs/PRIVACY_POLICY.md`.

---

## App Access Instructions

For Google Play reviewers:

**Demo login:** Use "Continue as demo user" button on the login screen.

**Alternative login:**
1. Enter any phone number (e.g., +919876543210)
2. Tap "Send OTP"
3. Enter any 4-6 digit code (e.g., 123456) — dev mode accepts any code
4. Complete profile setup (name, age range, gender, pace, walk types, languages)
5. Select a location (GPS or manual city picker)
6. App will show nearby walkers (seeded demo data)

**Note:** The backend must be running and accessible. Configure the API URL in `lib/core/config.dart`.

---

## Safety Disclosure Notes

1. **This is NOT a dating app.** All positioning emphasizes safety, community, and fitness.
2. **Location privacy:** Exact coordinates are never shown to other users. Only approximate labels ("within 300m") are displayed.
3. **SOS feature:** Does NOT call emergency services. Notifies emergency contact + creates safety event for admin review.
4. **Women-only groups:** Only women can create and join women-only groups.
5. **Verified-only groups:** Only selfie-verified users can join verified-only groups.
6. **Banned/suspended users:** Cannot create new accounts, send requests, or message other users.
7. **Report/block:** Users can report and block other users. Reports are reviewed by admins within 24 hours.
8. **Account deletion:** Available in Settings → Account → Delete account.
