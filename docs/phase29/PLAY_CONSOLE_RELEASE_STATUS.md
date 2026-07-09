# Play Console Release Status

**Phase:** 29
**Status:** Template — fill in during beta
**Last updated:** 2026-07-06
**Owner:** Product Lead + Mobile Lead

## Overview

This report tracks the Play Console release status throughout the closed Android beta — from initial upload through patch releases to the final wider release decision.

## Release timeline

| Date | Event | Build | Track | Status |
|---|---|---|---|---|
| [date] | Initial AAB upload | 1.7.0 (vc 27) | Internal Testing | [status] |
| [date] | Internal testers added | 1.7.0 | Internal Testing | [status] |
| [date] | Promoted to Closed Testing | 1.7.0 | Closed Testing | [status] |
| [date] | External testers added | 1.7.0 | Closed Testing | [status] |
| [date] | Patch 1 uploaded | 1.7.1 (vc 28) | Closed Testing | [status] |
| [date] | Patch 2 uploaded | 1.7.2 (vc 29) | Closed Testing | [status] |
| [date] | Go/No-Go decision | — | — | [GO/NO-GO] |
| [date] | Promoted to Open Testing (if GO) | 1.7.x | Open Testing | [status] |
| [date] | Production release (if GO) | 1.7.x | Production | [status] |

## Current release status

| Item | Value |
|---|---|
| Current build | [1.7.x] |
| Version code | [N] |
| Active track | [Internal / Closed / Open / Production] |
| Total installs | [N] |
| Active installs | [N] |
| Uninstalls | [N] |
| Crash-free sessions | [N]% |
| ANR rate | [N]% |
| Policy status | [No issues / Warning / Rejected] |

## AAB upload verification

### Initial upload — Build 1.7.0 (versionCode 27)

- [ ] AAB signed with release keystore
- [ ] AAB uploaded to Play Console successfully
- [ ] Play Console accepted the AAB (no signing errors)
- [ ] Play App Signing enrolled
- [ ] Build processed (10–30 minutes)
- [ ] Build available to testers

### Patch 1 — Build 1.7.1 (versionCode 28) — if applicable

- [ ] AAB signed with same release keystore
- [ ] AAB uploaded successfully
- [ ] Build processed
- [ ] Testers notified of update
- [ ] Testers updated to new build

### Patch 2 — Build 1.7.2 (versionCode 29) — if applicable

- [ ] AAB signed
- [ ] Uploaded successfully
- [ ] Build processed
- [ ] Testers updated

## Play Console setup verification

### App content (all sections)

| Section | Status | Notes |
|---|---|---|
| Privacy policy | [✓/✗] | URL: https://walktogether.app/privacy-policy |
| App access | [✓/✗] | [notes] |
| Ads | [✓/✗] | No ads |
| Content rating | [✓/✗] | Everyone |
| Target audience | [✓/✗] | 18+ |
| News app | [✓/✗] | No |
| Data safety | [✓/✗] | Completed |
| Government apps | [✓/✗] | No |
| Financial features | [✓/✗] | No |

### Store listing

| Item | Status | Notes |
|---|---|---|
| App name | [✓/✗] | WalkTogether — Safe Walking Companion |
| Short description | [✓/✗] | 80 chars max |
| Full description | [✓/✗] | Includes "100% FREE" |
| App icon | [✓/✗] | 512x512 PNG |
| Feature graphic | [✓/✗] | 1024x500 PNG |
| Phone screenshots | [✓/✗] | At least 2 |
| Privacy policy URL | [✓/✗] | Live URL |
| Support email | [✓/✗] | support@walktogether.app |

### Data Safety form

| Data type | Declared | Purpose | Encrypted |
|---|---|---|---|
| Phone number | [✓] | App functionality | [✓] |
| Email | [✓] | App functionality | [✓] |
| Name | [✓] | App functionality | [✓] |
| Age range | [✓] | Safety | [✓] |
| Approximate location | [✓] | App functionality | [✓] |
| Chat messages | [✓] | App functionality | [✓] |
| Profile photo | [✓] | App functionality | [✓] |
| Device ID | [✓] | Fraud prevention | [✓] |
| Financial data | [✗ NOT declared] | — | — |
| Exact location | [✗ NOT declared] | — | — |
| Background location | [✗ NOT declared] | — | — |

- [ ] Data deletion available: Yes (in-app)
- [ ] Data shared with third parties: No
- [ ] Data sold: No
- [ ] Data used for ads: No

### Content rating (IARC)

| Question | Answer |
|---|---|
| Violence | No |
| Sexual content | No |
| Profanity | No |
| User-generated content | Yes (moderated) |
| Drug reference | No |
| Gambling | No |
| In-app purchases | **No** |
| Ads | **No** |

**Resulting rating:** Everyone

## Tester distribution

### Internal Testing

| Item | Value |
|---|---|
| Internal testers added | [N] |
| Opt-in link | https://play.google.com/apps/internaltest/[APP_ID] |
| Testers who joined | [N] |
| Testers who installed | [N] |

### Closed Testing

| Item | Value |
|---|---|
| Email lists created | [N] |
| External testers added | [N] |
| Opt-in link | https://play.google.com/apps/testing/[PACKAGE] |
| Testers who joined | [N] |
| Testers who installed | [N] |
| Active testers (last 7 days) | [N] |

## Policy + review status

| Item | Status |
|---|---|
| Policy status | [No issues / Warning / Rejected] |
| Last review date | [date] |
| Review outcome | [Approved / Pending / Rejected] |
| Any warnings | [None / list] |
| Any appeals needed | [None / list] |

### If rejected or warned

**Reason:**
[reason from Play Console]

**Action taken:**
[what was fixed/appealed]

**Resolution:**
[outcome]

## Install statistics

| Metric | Value |
|---|---|
| Total installs | [N] |
| Active installs | [N] |
| Uninstalls | [N] |
| Uninstall rate | [N]% |
| Install growth rate | [trend] |

## Crash + ANR statistics (from Play Console)

| Metric | Value | Target |
|---|---|---|
| Crash-free sessions | [N]% | ≥ 95% |
| Crash-free users | [N]% | ≥ 95% |
| ANR rate | [N]% | < 0.5% |
| Top crash | [crash description] | — |
| Top ANR | [ANR description] | — |

## Free product compliance on Play Console

- [ ] "In-app purchases" NOT shown on listing
- [ ] "Ads" NOT shown on listing
- [ ] Full description includes "100% FREE"
- [ ] Data Safety form: no financial data
- [ ] IARC: "No" to in-app purchases, "No" to ads
- [ ] No monetization SDKs detected by Play Console

## Wider release readiness

### Open Testing (beta) — if GO

- [ ] Promote build from Closed Testing to Open Testing
- [ ] Create opt-in link for public beta
- [ ] Monitor for 1–2 weeks
- [ ] Track installs + crashes at larger scale

### Production — if GO after Open Testing

- [ ] Promote build to Production
- [ ] Staged rollout: 10% → 25% → 50% → 100%
- [ ] Monitor crash rate at each stage
- [ ] Pause rollout if crash rate spikes
- [ ] Full rollout after 7 days stable at 100%

## Acceptance criteria

- [ ] AAB uploaded + accepted by Play Console
- [ ] All app content sections completed
- [ ] Data Safety form completed
- [ ] Content rating: Everyone
- [ ] No policy violations
- [ ] Testers can install from Play testing link
- [ ] Patch builds uploaded as needed
- [ ] Crash-free sessions ≥ 95%
- [ ] No "In-app purchases" or "Ads" on listing
- [ ] Ready for wider release (if GO decision)
