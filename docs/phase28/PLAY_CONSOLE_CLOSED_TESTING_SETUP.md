# Play Console Closed Testing Setup

**Phase:** 28
**Status:** Ready to execute
**Last updated:** 2026-07-06
**Owner:** Product Lead + Mobile Lead

## Overview

This document covers the complete Play Console setup for closed Android beta testing — from creating the app listing to uploading the signed AAB to adding testers.

## Prerequisites

- [ ] Google Play Developer account ($25 one-time fee)
- [ ] Signed release AAB (see `RELEASE_KEYSTORE_SETUP.md`)
- [ ] Real `google-services.json` configured (see `FIREBASE_PRODUCTION_SETUP.md`)
- [ ] Privacy policy URL live (e.g. `https://walktogether.app/privacy-policy`)
- [ ] Support email monitored (e.g. `support@walktogether.app`)

## Step 1: Create app in Play Console

1. Go to https://play.google.com/console
2. Click "Create app"
3. **App name:** WalkTogether — Safe Walking Companion
4. **Default language:** English (United States)
5. **App type:** App
6. **Pricing:** Free
7. **Declarations:** Check both "App does not target children" + "App content may be suitable for all ages"
8. Click "Create app"

## Step 2: Complete "App content" section

### Privacy policy

1. Go to App content → Privacy policy
2. URL: `https://walktogether.app/privacy-policy` (must be live)
3. The privacy policy must cover:
   - What data is collected (phone, name, approximate location, chat messages)
   - How data is used (account, matching, safety, support)
   - How data is shared (not sold, no ads, only with user consent)
   - How users can delete their data (account deletion, privacy requests)
   - Data retention policy

### App access

1. Go to App content → App access
2. Select "All functionality is accessible without restrictions"
3. (If login is required, provide test credentials)

### Ads

1. Go to App content → Ads
2. Select "No, my app does not contain ads"

### Content rating

1. Go to App content → Content rating → Start questionnaire
2. Answer:
   - Violence: No
   - Sexual content: No
   - Profanity: No
   - User-generated content: Yes (chat messages, profile photos — moderated)
   - Is content moderated: Yes
   - Drug reference: No
   - Gambling: No
   - In-app purchases: **No**
   - Unwanted software practices: No
3. Expected rating: **Everyone**

### Target audience

1. Go to App content → Target audience
2. Target age: 18+
3. Reason: "App requires phone number verification and is intended for adults seeking walking companions"

### News app

1. Go to App content → News app
2. Select "No"

### Data safety

1. Go to App content → Data safety → Start

**Data collected:**

| Data type | Purpose | Required | Encrypted |
|---|---|---|---|
| Personal info — Phone number | App functionality (login) | Yes | Yes (in transit) |
| Personal info — Email | App functionality (recovery) | No | Yes |
| Personal info — Name | App functionality (profile) | Yes | Yes |
| Personal info — Age range | App functionality (safety) | Yes | Yes |
| Health & fitness — Age range | Safety (18+ requirement) | Yes | Yes |
| Location — Approximate | App functionality (nearby matching) | Yes | Yes |
| Messages — Chat messages | App functionality | Yes | Yes |
| Photos — Profile photo | App functionality | No | Yes |
| App activity — Walk sessions | Safety | Yes | Yes |
| Identifiers — Device ID | Fraud prevention | Yes | Yes |

**Data NOT collected:**
- Exact location (only approximate distance shown to other users)
- Background location (foreground only)
- Contacts
- Camera (only at runtime for verification)
- Financial data
- Browsing history

**Data practices:**
- Data encrypted in transit: Yes
- Data deletion available: Yes (Settings → Delete my account → 14-day grace period)
- Data shared with third parties: No
- Data sold: No
- Data used for advertising: No

### Government apps / Financial features / Privacy Policy URL

- Government apps: No
- Financial features: No
- Privacy Policy URL: `https://walktogether.app/privacy-policy`

## Step 3: Complete "App setup"

### App release

1. Go to Setup → App release
2. Click "Internal testing" → Create release

### Upload AAB

1. Upload `app-release.aab` (signed with release keystore)
2. If you see "App not signed correctly" — see `RELEASE_KEYSTORE_SETUP.md` troubleshooting

### Release notes

```
WalkTogether V1.7.0 — Closed Beta

What's new:
- Phone OTP login
- Nearby walker discovery with privacy controls
- 1:1 walk requests + chat
- Active walk session with SOS + safety share
- Group walks + walking clubs
- 9-language support (English, Hindi, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic RTL, French)
- Privacy requests: download your data, delete your account
- 14-day account deletion grace period
- Location privacy: exact coordinates never shared

100% FREE — No payments, no subscriptions, no premium features, no ads.
Safety is not a paid feature — it's a right.
```

### Enroll in Play App Signing

1. After first upload, Play Console will prompt to enroll in Play App Signing
2. Click "Enroll" (recommended — Google manages your signing key)

## Step 4: Add testers

### Internal testing (team members)

1. Go to Internal testing → Testers
2. Add by email (up to 100 internal testers)
3. Share opt-in link: `https://play.google.com/apps/internaltest/YOUR_APP_ID`
4. Testers open link on Android device → join testing → install from Play Store

### Closed testing (external beta testers)

1. After internal testing is stable (3+ days)
2. Go to Closed testing → Create release (alpha or beta track)
3. Create email list of 20–50 testers (see `TESTER_RECRUITMENT_LIST_TEMPLATE.md`)
4. Add the email list to the closed testing track
5. Testers receive email invite with opt-in link
6. Testers open link → join testing → install from Play Store

## Step 5: Complete store listing

### Main store listing

1. Go to Grow → Store presence → Main store listing

**App details:**
- **App name:** WalkTogether — Safe Walking Companion
- **Short description (80 chars):** Find safe, verified walking partners nearby. 100% free. Safety-first.
- **Full description:**

```
WalkTogether is a 100% free, safety-first walking companion app. Find verified walking partners nearby, join group walks, and build walking clubs in your city, town, or village.

WHY WALKTOGETHER?

• 100% FREE — No payments, no subscriptions, no premium features, no ads. Safety is not a paid feature — it's a right.

• SAFETY-FIRST — Every walker is phone-verified. SOS button for emergencies. Safety share lets a trusted contact track your walk. Report and block anyone who makes you uncomfortable.

• COMMUNITY-FIRST — Join group walks in your area. Create or join walking clubs (morning walkers, evening walkers, women-only, senior walkers, dog walkers). Become a community host.

• GLOBAL — Available in 9 languages: English, हिन्दी, తెలుగు, தமிழ், ಕನ್ನಡ, বাংলা, Español, العربية, Français.

• CITY / TOWN / VILLAGE — Whether you're in a major city or a small village, WalkTogether works.

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
• Safety events, reports, appeals, and audit logs are preserved for safety and legal reasons

SUPPORT

Email: support@walktogether.app
Privacy policy: https://walktogether.app/privacy-policy
Terms of service: https://walktogether.app/terms-of-service
```

### Graphics

- **App icon:** 512x512 PNG, 32-bit, no alpha
- **Feature graphic:** 1024x500 PNG
- **Phone screenshots:** at least 2, recommended 4-8, 16:9 or 9:16
  - Suggested screenshots: Login, Home (nearby walkers), Walk session (SOS), Settings (language)

## Step 6: Verify

- [ ] AAB uploaded to Internal Testing
- [ ] App content → all sections completed
- [ ] Data Safety form completed
- [ ] Content rating: Everyone
- [ ] Privacy policy URL live
- [ ] Support email monitored
- [ ] Store listing complete (description, icon, screenshots)
- [ ] Internal testers added
- [ ] Opt-in link shared with testers
- [ ] Testers can install + open the app
- [ ] No "In-app purchases" shown on listing
- [ ] No "Ads" shown on listing

## Checklist summary

| Item | Status |
|---|---|
| Play Developer account active | [ ] |
| App created with package `com.walktogether.app` | [ ] |
| Signed AAB uploaded | [ ] |
| Privacy policy URL live | [ ] |
| Support email added | [ ] |
| Data Safety form complete | [ ] |
| Content rating: Everyone | [ ] |
| No in-app purchases declared | [ ] |
| No ads declared | [ ] |
| Store listing complete | [ ] |
| Internal testers added | [ ] |
| Closed testers added (after internal testing) | [ ] |
| Release notes added | [ ] |
| Play App Signing enrolled | [ ] |
