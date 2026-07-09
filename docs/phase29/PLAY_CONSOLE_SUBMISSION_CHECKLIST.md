# Play Console Submission Checklist

**Phase:** 29C-Handoff
**Status:** Ready for local execution
**Last updated:** 2026-07-06

## Overview

This checklist covers everything needed to submit the WalkTogether app to Google Play Console Internal Testing. Complete each item before uploading the AAB.

## App identity

| Field | Value |
|---|---|
| App name | WalkTogether — Safe Walking Companion |
| Package name | `com.walktogether.app` |
| Version name | 1.7.0 |
| Version code | 27 |
| Min SDK | 23 (Android 6.0) |
| Target SDK | 34 (Android 14) |
| Pricing | **Free** |
| App type | App |
| Default language | English (United States) |
| Category | Health & Fitness |

## Declarations

- [ ] App does NOT target children
- [ ] App content may be suitable for all ages

## App content sections

### Privacy policy

- [ ] Privacy policy URL is live: `https://walktogether.app/privacy-policy` (or your URL)
- [ ] Privacy policy covers: data collected, how it's used, how it's shared, data deletion, retention

### App access

- [ ] Select: "All functionality is accessible without restrictions"
- [ ] (If login required, provide test phone number + OTP instructions)

### Ads

- [ ] Select: "No, my app does not contain ads"

### Content rating (IARC questionnaire)

Answer each question:

| Question | Answer |
|---|---|
| Does your app contain violence? | No |
| Does your app contain sexual content? | No |
| Does your app contain profanity? | No |
| Does your app contain user-generated content? | Yes (chat messages, profile photos) |
| Is user-generated content moderated? | Yes (automated + human review) |
| Does your app contain drug references? | No |
| Does your app contain gambling? | No |
| Does your app contain in-app purchases? | **No** |
| Does your app contain ads? | **No** |

Expected rating: **Everyone**

### Target audience

- [ ] Target age: 18+
- [ ] Reason: App requires phone verification and is for adults seeking walking companions

### News app

- [ ] Select: "No"

### Data Safety form

**Data collected:**

| Data type | Purpose | Required | Encrypted in transit |
|---|---|---|---|
| Personal info — Phone number | App functionality (login) | Yes | Yes |
| Personal info — Email | App functionality (recovery) | No | Yes |
| Personal info — Name | App functionality (profile) | Yes | Yes |
| Personal info — Age range | Safety (18+ requirement) | Yes | Yes |
| Location — Approximate | App functionality (nearby matching) | Yes | Yes |
| Messages — Chat messages | App functionality | Yes | Yes |
| Photos — Profile photo | App functionality | No | Yes |
| App activity — Walk sessions | Safety | Yes | Yes |
| Identifiers — Device ID | Fraud prevention | Yes | Yes |

**Data NOT collected:**
- [ ] Exact location: NOT declared (only approximate distance shown)
- [ ] Background location: NOT declared (foreground only)
- [ ] Financial data: NOT declared
- [ ] Contacts: NOT declared
- [ | Camera: NOT declared (only runtime for verification)
- [ ] Browsing history: NOT declared

**Data practices:**
- [ ] Data encrypted in transit: Yes
- [ ] Data deletion available: Yes (Settings → Delete my account → 14-day grace period)
- [ ] Data shared with third parties: No
- [ ] Data sold: No
- [ ] Data used for advertising: No

### Government apps / Financial features

- [ ] Government apps: No
- [ ] Financial features: No

## Store listing

### App details

- [ ] App name: WalkTogether — Safe Walking Companion
- [ ] Short description (80 chars max): `Find safe, verified walking partners nearby. 100% free. Safety-first.`
- [ ] Full description: (use the description from `docs/phase28/PLAY_CONSOLE_CLOSED_TESTING_SETUP.md`)

### Graphics

- [ ] App icon: 512×512 PNG, 32-bit, no alpha
- [ ] Feature graphic: 1024×500 PNG
- [ ] Phone screenshots: at least 2 (recommended 4–8), 16:9 or 9:16
  - Suggested: Login screen, Home (nearby walkers), Walk session (SOS), Settings (language)

### Contact info

- [ ] Privacy policy URL: `https://walktogether.app/privacy-policy` (must be live)
- [ ] Support email: `support@walktogether.app` (must be monitored)
- [ ] Marketing URL: `https://walktogether.app` (optional)

## Release setup

### Internal Testing track

- [ ] Go to "Internal testing" → "Create release"
- [ ] Upload `app-release.aab` (signed with release keystore)
- [ ] AAB accepted (no signing error, no package mismatch, no versionCode conflict)

### Release notes

```
WalkTogether closed beta is a free safety-first community walking app. This beta includes nearby walkers, walk requests, chat after acceptance, group walks, walking clubs, SOS, report/block, privacy requests, appeals, and multilingual support. All features are free.
```

### Testers

- [ ] Add 5 tester emails (first smoke test group)
- [ ] Generate opt-in link
- [ ] Share opt-in link with testers via email/WhatsApp

## Post-upload verification

- [ ] Build processed (10–30 minutes after upload)
- [ ] Build status: "Active"
- [ ] Opt-in link works: `https://play.google.com/apps/internaltest/YOUR_APP_ID`
- [ ] Tester can open link on Android device
- [ ] Tester can install app from Play Store
- [ ] No "In-app purchases" shown on listing
- [ ] No "Ads" shown on listing
- [ ] Content rating: Everyone
- [ ] No policy warnings

## Free product compliance

- [ ] IARC: "No" to in-app purchases
- [ ] IARC: "No" to ads
- [ ] Pricing: Free
- [ ] Full description includes "100% FREE — No payments, no subscriptions, no premium features, no ads"
- [ ] Data Safety: no financial data
- [ ] No advertising SDKs in the app
- [ ] Automated scan: 0 forbidden terms in source code

## Rollout status

| Step | Status |
|---|---|
| AAB signed + built | [ ] |
| Play Console app created | [ ] |
| All app content sections completed | [ ] |
| Data Safety form completed | [ ] |
| Content rating: Everyone | [ ] |
| AAB uploaded + accepted | [ ] |
| Release notes added | [ ] |
| 5 tester emails added | [ ] |
| Opt-in link generated | [ ] |
| Testers can install | [ ] |
| Ready to expand to 20–50 testers | [ ] |
