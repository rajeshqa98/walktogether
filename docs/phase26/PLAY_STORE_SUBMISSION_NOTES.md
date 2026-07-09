# Play Store Submission Notes

**Phase:** 26
**Status:** Ready for internal testing submission
**Last updated:** 2026-07-06
**Package:** `com.walktogether.app`
**Version:** 1.7.0 (versionCode 26)
**AAB file:** `build/app/outputs/bundle/release/app-release.aab`

## Pre-submission checklist

### App bundle

- [ ] `flutter build appbundle --release` succeeds
- [ ] App bundle is signed with release keystore (not debug)
- [ ] App bundle is < 150 MB (current size: ~42 MB)
- [ ] `google-services.json` is the real Firebase config (not placeholder)
- [ ] `DEMO_LOGIN=false` dart-define is set in build command

### Play Console setup

- [ ] Play Console developer account active ($25 one-time fee)
- [ ] App created with package name `com.walktogether.app`
- [ ] App name: "WalkTogether — Safe Walking Companion"
- [ ] App category: Health & Fitness
- [ ] Content rating: Everyone (after IARC questionnaire)
- [ ] Target audience: 18+ (adults only)

### Store listing

- [ ] **App name:** WalkTogether — Safe Walking Companion
- [ ] **Short description (80 chars):** Find safe, verified walking partners nearby. 100% free. Safety-first.
- [ ] **Full description:** (see below)
- [ ] **App icon:** 512x512 PNG, 32-bit PNG with alpha
- [ ] **Feature graphic:** 1024x500 PNG
- [ ] **Phone screenshots:** at least 2, max 8, 16:9 or 9:16, min 320px each side
- [ ] **Privacy policy URL:** https://walktogether.app/privacy-policy
- [ ] **Support email:** support@walktogether.app

### Full description (for Play Store listing)

```
WalkTogether is a 100% free, safety-first walking companion app. Find verified walking partners nearby, join group walks, and build walking clubs in your city, town, or village.

WHY WALKTOGETHER?

• 100% FREE — No payments, no subscriptions, no premium features, no ads. Safety is not a paid feature — it's a right.

• SAFETY-FIRST — Every walker is phone-verified. SOS button for emergencies. Safety share lets a trusted contact track your walk. Report and block anyone who makes you uncomfortable.

• COMMUNITY-FIRST — Join group walks in your area. Create or join walking clubs (morning walkers, evening walkers, women-only, senior walkers, dog walkers). Become a community host.

• GLOBAL — Available in 9 languages: English, हिन्दी, తెలుగు, தமிழ், ಕನ್ನಡ, বাংলা, Español, العربية, Français.

• CITY / TOWN / VILLAGE — Whether you're in a major city or a small village, WalkTogether works. Be the first walker in your area and invite friends.

FEATURES

• Phone OTP login — no password to remember
• Nearby walker discovery with privacy controls
• Walk requests with safety preferences (women-only, verified-only, daylight-only, public-place-only)
• Real-time chat with automatic moderation
• Group walks with host guidance
• Walking clubs with rules + member management
• SOS safety button + safety share
• Report + block
• Appeal system for moderation decisions
• Privacy requests: download your data, delete your account
• 14-day account deletion grace period
• Location privacy: exact coordinates never shared with other users

FREE PRODUCT PROMISE

WalkTogether is and will always be free for everyone. No payments. No subscriptions. No premium features. No ads. Safety is not a paid feature — it's a right. We will never charge for safety.

PRIVACY

• Your exact location is never shared with other users — only approximate distance
• You can hide from nearby results at any time
• You can download all your data as JSON
• You can delete your account with a 14-day grace period
• Safety events, reports, and audit logs are preserved for safety and legal reasons

SUPPORT

Email: support@walktogether.app
Privacy policy: https://walktogether.app/privacy-policy
Terms of service: https://walktogether.app/terms-of-service
```

## Data safety form

### Data collected

| Data type | Purpose | Required | Encrypted in transit |
|---|---|---|---|
| Personal info (name, phone, email) | Account | Required | Yes |
| Health & fitness (age range) | Safety (18+) | Required | Yes |
| Financial info | NONE | N/A | N/A |
| Messages (chat) | App functionality | Required | Yes |
| Photos (profile) | App functionality | Optional | Yes |
| Location (approximate) | Nearby matching | Required | Yes |
| App activity (walk sessions) | Safety | Required | Yes |
| Identifiers (device) | Fraud prevention | Required | Yes |

### Data NOT collected

- Exact GPS coordinates (only coarse distance)
- Background location
- Contacts
- Camera (only at runtime for verification)
- Microphone
- Financial data
- Health data (beyond age range)
- Browsing history
- Search history

### Data sharing

- No data sold to third parties
- No advertising SDKs
- No data shared for analytics beyond internal app improvement

### Data deletion

- Users can delete their account from Settings
- 14-day grace period before anonymization
- Safety events, reports, appeals preserved for safety/legal reasons

## Content rating (IARC questionnaire)

Answer the IARC questionnaire as follows:

| Question | Answer |
|---|---|
| Does your app contain violence? | No |
| Does your app contain sexual content? | No |
| Does your app contain profanity? | No |
| Does your app contain user-generated content? | Yes (chat messages, profile photos) |
| Is user-generated content moderated? | Yes (automated + human review) |
| Does your app contain drug references? | No |
| Does your app contain gambling? | No |
| Does your app contain in-app purchases? | No |
| Does your app contain ads? | No |
| Is your app intended for children? | No (18+ only) |

Expected rating: **Everyone** (or 12+ depending on user-generated content classification).

## Target audience

| Setting | Value |
|---|---|
| Target audience age | 18+ |
| Target audience | All genders |
| Contains content not suitable for children | Yes (user-generated chat) |

## App content

### Privacy policy

URL: `https://walktogether.app/privacy-policy`

The privacy policy must be live before submission. It should cover:
- What data is collected (phone, email, name, approximate location, chat messages)
- How data is used (account, matching, safety, support)
- How data is shared (not sold, no ads, only with user consent)
- How users can delete their data (account deletion, privacy requests)
- Data retention policy (safety events preserved, operational data expired per rule)

### Support email

`support@walktogether.app` — must be monitored. Response time target: 48 hours.

### App access

If your app requires login, provide test credentials:
- Phone: any real phone number (OTP sent via SMS)
- For review: contact support@walktogether.app for a test number

## Release tracks

### Track 1: Internal testing (recommended first)

- Up to 100 testers
- No review required (instant availability)
- Use for: team + close beta testers

### Track 2: Closed testing (alpha)

- Up to 100 testers per email list
- No review required for existing testers
- Use for: broader beta testing

### Track 3: Open testing (beta)

- Up to unlimited testers via opt-in link
- Pre-registration review required
- Use for: public beta before production launch

### Track 4: Production

- Full review required (1-7 days)
- Staged rollout recommended (start with 10%, increase to 100% over 7 days)

## Submission steps

1. [ ] Upload signed app bundle to Play Console → Internal testing → Create new release
2. [ ] Add release notes (use V1_7_MOBILE_RELEASE_NOTES.md as reference)
3. [ ] Add testers by email (up to 100)
4. [ ] Share opt-in link with testers: `https://play.google.com/apps/internaltest/YOUR_APP_ID`
5. [ ] Testers install + test for at least 7 days
6. [ ] Fix any issues, bump versionCode to 27, re-upload
7. [ ] After 14 days of stable internal testing, promote to Closed testing
8. [ ] After 14 days of stable closed testing, promote to Open testing
9. [ ] After 14 days of stable open testing, promote to Production (staged rollout)

## Post-submission monitoring

After production release:

- [ ] Monitor crash reports in Play Console → Android Vitals
- [ ] Monitor ANR (Application Not Responding) rates
- [ ] Monitor user reviews + respond within 48 hours
- [ ] Monitor Play Console → Feedback for bug reports
- [ ] Monitor backend SLO dashboard for API error rates
- [ ] Monitor push notification delivery rate

## Free product compliance

WalkTogether is 100% free. The Play Store listing must reflect this:

- **No "in-app purchases" section** — the IARC questionnaire answers "No" to in-app purchases
- **No "ads" section** — the IARC questionnaire answers "No" to ads
- **No "offers in-app purchases" label** on the store listing
- **Full description includes** "100% FREE — No payments, no subscriptions, no premium features, no ads"

If Google Play review asks about monetization, the response is: "WalkTogether is a free community app. There are no in-app purchases, no subscriptions, and no ads. The app is funded by grants and donations."

## Acceptance criteria

- [ ] App bundle builds + signs successfully
- [ ] Play Console listing is complete
- [ ] Data safety form is filled out
- [ ] Content rating questionnaire is complete
- [ ] Privacy policy URL is live
- [ ] Support email is monitored
- [ ] Test credentials are provided
- [ ] Internal testing track is populated
- [ ] No paid/premium language in listing or app
