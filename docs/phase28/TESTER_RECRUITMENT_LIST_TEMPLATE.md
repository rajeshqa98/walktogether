# Tester Recruitment List Template

**Phase:** 28
**Status:** Template ready — fill in with actual tester data
**Last updated:** 2026-07-06

## Overview

This template is used to recruit and track 20–50 closed Android beta testers. Testers should represent diverse geographies, device types, and use cases to ensure comprehensive coverage.

## How to use this template

1. Copy this template to a spreadsheet (Google Sheets, Excel, or Notion)
2. Fill in tester information as you recruit
3. Track tester status throughout the beta
4. Do NOT share tester personal data publicly
5. Delete tester data after the beta if requested (per privacy policy)

## Tester spreadsheet columns

| Column | Type | Required | Description |
|---|---|---|---|
| Name | Text | Yes | Tester's full name |
| Email | Email | Yes | For Play Console invite + communication |
| Phone | Phone | Yes | For emergency contact during testing |
| Country | Text | Yes | e.g. "India", "USA" |
| State/Region | Text | Yes | e.g. "Karnataka", "California" |
| City | Text | Yes | e.g. "Bangalore", "San Francisco" |
| Town/Village | Text | No | For rural testers |
| Android Device Model | Text | Yes | e.g. "Samsung Galaxy A52", "Pixel 7" |
| Android Version | Text | Yes | e.g. "13", "14" |
| Preferred Language | Text | Yes | One of: en, hi, te, ta, kn, bn, es, ar, fr |
| Tester Group | Text | Yes | See "Tester groups" below |
| Play Console Email | Email | Yes | Google account email for Play Store access |
| Invite Sent Date | Date | Yes | When Play Console invite was sent |
| Invite Accepted | Boolean | Yes | Did tester join the testing program? |
| App Installed | Boolean | Yes | Did tester install the app? |
| Test Scenarios Completed | Number | Yes | How many scenarios from BETA_TEST_SCENARIOS.md |
| Feedback Submitted | Number | Yes | How many feedback submissions |
| Bugs Reported | Number | Yes | How many bugs reported |
| Status | Text | Yes | "recruited", "active", "completed", "dropped" |
| Notes | Text | No | Any special notes |

## Tester groups

| Group | Target | Description |
|---|---|---|
| City users | 10–15 | Dense urban area, many nearby walkers |
| Small-town users | 5–10 | Smaller population, fewer walkers |
| Village/custom-location | 3–5 | Rural area, manual location entry, first-walker experience |
| Women safety testers | 5–8 | Women testing women-only preferences, safety share, SOS |
| Group walk testers | 3–5 | Test group walk creation, join, chat |
| Host testers | 2–3 | Test host onboarding, group walk hosting |
| Multilingual testers | 5–8 | Test non-English languages (Hindi, Tamil, Arabic RTL, etc.) |
| Low-density area testers | 2–3 | Test empty nearby list, invite flow |

## Sample rows

| Name | Email | Phone | Country | State | City | Device | Android | Lang | Group | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| (example) Priya S | priya@example.com | +91... | India | Karnataka | Bangalore | Samsung A52 | 13 | en | City | recruited |
| (example) Ahmed K | ahmed@example.com | +91... | India | Telangana | Hyderabad | Pixel 7 | 14 | ar | Multilingual | recruited |
| (example) Lakshmi R | lakshmi@example.com | +91... | India | TN | Coimbatore | OnePlus 11 | 13 | ta | Women safety | recruited |

## Recruitment channels

1. **Friends + family** — Start with people you trust
2. **Walking/hiking groups** — Post in local walking groups on WhatsApp/Facebook
3. **University students** — Campus walking groups
4. **Community centers** — Senior walking groups, women's groups
5. **Apartment complexes** — Residents' welfare associations
6. **Social media** — Twitter/Instagram with #WalkTogether hashtag
7. **App testing communities** — Reddit r/AndroidBeta, BetaFamily, etc.

## Recruitment message template

```
Hi [Name]!

I'm building WalkTogether — a 100% free walking companion app that helps people find safe, verified walking partners nearby. It has SOS, safety share, group walks, and is available in 9 languages including Hindi and Arabic.

I'm looking for 20-50 Android beta testers to try the app and give feedback. Testing takes about 1-2 hours over 2 weeks.

Would you be interested? All you need is:
- An Android phone (Android 6.0+)
- A Google account
- 1-2 hours over 2 weeks

The app is 100% free — no payments, no subscriptions, no ads. Safety is not a paid feature.

If interested, please reply with:
- Your Google account email (for Play Store invite)
- Your phone model + Android version
- Your city/town/village
- Your preferred language

Thanks!
[Your name]
```

## Tester agreement

By joining the beta, testers agree to:

1. **Test in good faith** — actually use the app, not just install it
2. **Report bugs** via the in-app feedback screen or email
3. **Respect safety** — do not use the app to meet strangers unsafely during testing
4. **Do not share the APK** with non-testers (Play Console manages access)
5. **Understand it's a beta** — the app may crash, lose data, or behave unexpectedly
6. **Privacy** — your data will be handled per the privacy policy; you can delete your account at any time

## Data retention

- Tester data in this spreadsheet: retained for the duration of the beta + 30 days, then deleted
- Tester data in the app: handled per the privacy policy (account deletion available)
- Play Console tester data: managed by Google; you can remove testers at any time

## Acceptance criteria

- [ ] 20–50 testers recruited
- [ ] All tester groups represented (at least 1 tester per group)
- [ ] Tester spreadsheet filled with complete data
- [ ] Play Console invites sent to all testers
- [ ] Testers have accepted invites + installed the app
