# V1.8 Beta Patch Release Notes

**Version:** 1.8.0 (or 1.7.1 / 1.7.2 patch)
**Phase:** 29
**Release date:** [DATE — to be determined after beta fixes]
**Status:** Draft — will be finalized after beta bug fixes

## Overview

This release fixes bugs found during the closed Android beta (Phase 29). The app remains 100% free for everyone — no payments, subscriptions, premium features, ads, or monetization.

## Versioning

| Version | Build | Reason |
|---|---|---|
| 1.7.0 | versionCode 27 | Initial beta release |
| 1.7.1 | versionCode 28 | Patch 1 — P0/P1 bug fixes (if needed) |
| 1.7.2 | versionCode 29 | Patch 2 — additional fixes (if needed) |
| 1.8.0 | versionCode 30 | Post-beta release with all fixes + improvements |

## What's new in this patch release

### Bug fixes

#### P0 fixes (critical)

* **[WT-BUG-P0-001]:** [description of fix]
  - **Impact:** [what was broken]
  - **Fix:** [what was changed]
  - **Files:** [list of files changed]

* **[WT-BUG-P0-002]:** [description of fix]
  - **Impact:** [what was broken]
  - **Fix:** [what was changed]

#### P1 fixes (high priority)

* **[WT-BUG-P1-001] (safety):** [description of fix]
  - **Impact:** [safety impact]
  - **Fix:** [what was changed]
  - **Safety Lead sign-off:** ✓

* **[WT-BUG-P1-002] (auth):** [description of fix]
  - **Impact:** [what was broken]
  - **Fix:** [what was changed]

* **[WT-BUG-P1-003] (chat):** [description of fix]
  - **Impact:** [what was broken]
  - **Fix:** [what was changed]

#### P2 fixes (medium)

* **[WT-BUG-P2-001]:** [description of fix]
* **[WT-BUG-P2-002]:** [description of fix]
* **[WT-BUG-P2-003]:** [description of fix]

#### P3 fixes (low / UI polish)

* **[WT-BUG-P3-001]:** [description of fix]
* **[WT-BUG-P3-002]:** [description of fix]

### Improvements

* **[Improvement 1]:** [description] — based on tester feedback
* **[Improvement 2]:** [description] — based on tester feedback
* **[Improvement 3]:** [description] — based on tester feedback

### Safety flow verifications

All safety flows have been verified on real devices during the beta:

* ✅ SOS button creates safety event in backend
* ✅ SOS disclaimer visible in confirmation dialog
* ✅ SOS does NOT auto-call emergency services
* ✅ Safety share toggle works during active walk
* ✅ Report user creates report in admin queue
* ✅ Block user prevents further contact
* ✅ Appeal submission creates appeal in admin queue
* ✅ Account deletion starts 14-day grace period
* ✅ Cancel deletion restores account
* ✅ Data export excludes other users' private data
* ✅ Data export partially redacts own phone number

### Location privacy verifications

* ✅ Foreground location only (no background tracking)
* ✅ Approximate accuracy (~50-100m, not exact)
* ✅ No exact coordinates in nearby walker API
* ✅ No exact coordinates in walker detail UI
* ✅ No exact coordinates in data export
* ✅ No exact coordinates in logs (redaction works)
* ✅ "Hide me from nearby" toggle works
* ✅ Manual village/town location fallback works

### Free product compliance

* ✅ Automated scan: 0 forbidden terms (premium, subscription, paywall, in-app purchase, credit card, billing)
* ✅ No payment gateway integrations
* ✅ No subscription models
* ✅ No premium feature flags
* ✅ No ad SDK integrations
* ✅ Play Console: "No" to in-app purchases, "No" to ads
* ✅ App description includes "100% FREE"

## What's NOT changing

### Free product promise
WalkTogether remains 100% free for everyone. No payments. No subscriptions. No premium features. No ads. Safety is not a paid feature — it's a right.

### Safety-first principles
* Every walker is phone-verified
* SOS button for emergencies (does NOT call emergency services)
* Safety share lets a trusted contact track your walk
* Report and block available in every chat + walker detail
* No auto-ban without admin review
* All safety features are free

### Community-first principles
* Group walks + walking clubs remain free
* Community hosts are not paid — hosting is voluntary
* Invite links are free to create + share

### 9-language support
* English, हिन्दी, తెలుగు, தமிழ், ಕನ್ನಡ, বাংলা, Español, العربية, Français
* Arabic RTL layout

## Known issues (deferred to V1.9)

These issues were found during beta but are not blockers. They will be fixed in a future release:

* **[WT-BUG-P2-XXX]:** [description] — workaround: [description]
* **[WT-BUG-P3-XXX]:** [description] — cosmetic, no user impact
* **Full i18n translation:** V1.7 includes 12 safety-critical keys. Full 518-key translation planned for V1.9.
* **Dark mode:** Not yet implemented. Planned for V1.9.
* **Offline caching:** API calls fail when offline. Planned for V1.9.

## Upgrade path

Testers updating from 1.7.0:

1. Open Play Store
2. Search "WalkTogether"
3. Tap "Update"
4. App updates to [1.7.x / 1.8.0]
5. Existing sessions preserved (no re-login needed)
6. Existing preferences preserved (language, hide me, etc.)

## Play Console release

### Internal Testing
- [ ] AAB uploaded to Internal Testing
- [ ] Internal testers update + verify

### Closed Testing
- [ ] Promoted to Closed Testing
- [ ] All beta testers can update
- [ ] Release notes visible in Play Console

### Open Testing (if GO for wider release)
- [ ] Promoted to Open Testing
- [ ] Public opt-in link activated
- [ ] Up to 500+ testers

### Production (if GO after Open Testing)
- [ ] Promoted to Production
- [ ] Staged rollout: 10% → 25% → 50% → 100%
- [ ] Monitor at each stage

## Tester acknowledgment

Thank you to all beta testers who helped find bugs, suggest improvements, and verify safety flows. Your feedback has made WalkTogether safer and better for everyone.

Special thanks to testers who:
* Tested the SOS flow and confirmed it works safely
* Tested in low-density areas and reported the "first walker" experience
* Tested Arabic RTL and reported layout issues
* Tested privacy flows (data export, account deletion)
* Reported bugs with detailed reproduction steps

## Stay safe, walk together

WalkTogether is and will always be free for everyone. Safety is not a paid feature — it's a right. We will never charge for safety.

If you have feedback or find a bug:
* In-app: More tab → Give feedback
* Email: support@walktogether.app

---

**Version:** [1.7.x / 1.8.0]
**Build:** [versionCode]
**Date:** [date]
**Package:** com.walktogether.app
**Min Android:** 6.0 (API 23)
**Target Android:** 14 (API 34)
