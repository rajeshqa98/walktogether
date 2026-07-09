# Closed Android Beta Plan

**Phase:** 28
**Status:** Ready to execute
**Last updated:** 2026-07-06
**Owner:** Product Lead + Mobile Lead + Safety Lead

## Overview

Phase 28 runs a closed Android beta with 20–50 real testers to validate the WalkTogether mobile app in real-world conditions. The beta will test safety flows, location privacy, community features, multilingual support, and overall app stability before wider release.

WalkTogether remains 100% free for everyone throughout the beta — no payments, subscriptions, premium features, ads, or monetization.

## Beta timeline

| Phase | Duration | Activities |
|---|---|---|
| Preparation | 1 week | Release keystore, Firebase config, Play Console setup, tester recruitment |
| Internal testing | 3 days | 5–10 internal testers (team members) |
| Closed testing | 2 weeks | 20–50 external testers |
| Analysis | 3 days | Bug triage, metrics review, go/no-go decision |
| Total | ~4 weeks | |

## Beta goals

1. **Verify safety flows work on real devices** — SOS, report, block, safety share, appeal, deletion
2. **Verify location privacy** — no exact coordinates leaked, foreground-only, manual fallback works
3. **Verify core walk flow** — signup → nearby → request → chat → walk → rate
4. **Verify community features** — group walks, clubs, group chat
5. **Verify multilingual support** — English, Hindi, Arabic RTL, +5 other languages
6. **Verify privacy flows** — data export, account deletion grace period, privacy requests
7. **Measure stability** — crash-free sessions, OTP success rate, ANR rate
8. **Collect feedback** — bugs, UX issues, feature requests, safety concerns

## Tester recruitment target

**20–50 initial Android testers** across these profiles:

| Profile | Target count | Why |
|---|---|---|
| City users | 10–15 | Dense area, many nearby walkers |
| Small-town users | 5–10 | Sparse area, fewer walkers |
| Village/custom-location users | 3–5 | Manual location entry, first-walker experience |
| Women safety testers | 5–8 | Women-only preferences, safety share, SOS |
| Group walk testers | 3–5 | Group walk creation, join, chat |
| Host testers | 2–3 | Host onboarding, group walk hosting |
| Multilingual testers | 5–8 | Hindi, Tamil, Telugu, Arabic RTL, French, Spanish |
| Low-density area testers | 2–3 | Empty nearby list, invite flow |

## Prerequisites

### Release keystore
- [ ] Create release keystore (see `RELEASE_KEYSTORE_SETUP.md`)
- [ ] Store keystore securely (NOT in the repo)
- [ ] Configure signing in `build.gradle`
- [ ] Rebuild release APK + AAB with release signing

### Firebase production config
- [ ] Create Firebase project (see `FIREBASE_PRODUCTION_SETUP.md`)
- [ ] Add Android app with package `com.walktogether.app`
- [ ] Download real `google-services.json`
- [ ] Enable Firebase Cloud Messaging
- [ ] Verify FCM token generation

### Play Console setup
- [ ] Create app listing (see `PLAY_CONSOLE_CLOSED_TESTING_SETUP.md`)
- [ ] Upload signed release AAB
- [ ] Complete Data Safety form
- [ ] Complete content rating (IARC questionnaire)
- [ ] Add privacy policy URL
- [ ] Add support email
- [ ] Add screenshots
- [ ] Add closed tester list
- [ ] Submit for internal/closed testing

### Backend readiness
- [ ] Production-like backend deployed
- [ ] Database healthy
- [ ] Redis enabled
- [ ] Socket server deployed
- [ ] OTP provider configured
- [ ] Admin dashboard available
- [ ] Health + ready endpoints green
- [ ] Privacy policy URL live
- [ ] Support email monitored

## Beta execution

### Week 1: Preparation

1. Create release keystore + rebuild signed AAB
2. Set up Firebase project + download real config
3. Upload AAB to Play Console Internal Testing
4. Complete Play Console listing (Data Safety, content rating, privacy policy)
5. Recruit 20–50 testers (see `TESTER_RECRUITMENT_LIST_TEMPLATE.md`)
6. Send tester onboarding messages (see `TESTER_ONBOARDING_MESSAGE.md`)
7. Prepare admin safety monitoring (see `BETA_SAFETY_MONITORING_SOP.md`)
8. Set up bug triage board (see `BETA_BUG_TRIAGE_BOARD.md`)
9. Set up metrics tracking (see `BETA_METRICS_DASHBOARD_SPEC.md`)

### Week 2: Internal testing (5–10 testers)

1. Add 5–10 internal testers (team members) to Play Console Internal Testing
2. Testers install app + complete test scenarios (see `BETA_TEST_SCENARIOS.md`)
3. Daily safety monitoring by admin
4. Collect bugs + feedback
5. Fix P0/P1 bugs
6. Verify no safety incidents

### Weeks 3–4: Closed testing (20–50 testers)

1. Promote build to Closed Testing track
2. Add 20–50 external testers
3. Testers complete test scenarios over 2 weeks
4. Daily safety monitoring by admin
5. Collect bugs + feedback daily
6. Triage bugs weekly (see `BETA_BUG_TRIAGE_BOARD.md`)
7. Fix P0 bugs immediately, P1 bugs within 48h
8. Track metrics daily (see `BETA_METRICS_DASHBOARD_SPEC.md`)

### Week 5: Analysis + go/no-go

1. Compile all bugs + feedback
2. Review metrics
3. Safety review — any real safety concerns?
4. Go/no-go decision (see `PHASE_28_GO_NO_GO_CRITERIA.md`)
5. If GO: prepare for wider release
6. If NO-GO: fix issues + extend beta

## Safety monitoring during beta

**Daily admin checklist** (see `BETA_SAFETY_MONITORING_SOP.md` for full SOP):

- [ ] Check SOS events
- [ ] Check reports filed
- [ ] Check blocks
- [ ] Check flagged messages
- [ ] Check appeal submissions
- [ ] Check suspended/banned users
- [ ] Check safety review tasks
- [ ] Check privacy requests
- [ ] Check deletion requests
- [ ] Check feedback tagged "safety concern"

**Any real safety concern must be reviewed before expanding beta.**

## Bug triage

**Severity levels** (see `BETA_BUG_TRIAGE_BOARD.md`):

| Severity | Definition | Response time |
|---|---|---|
| P0 | Blocker — app crash, safety flow broken, data loss | Immediate (same day) |
| P1 | High — core feature broken, no workaround | 48 hours |
| P2 | Medium — feature partially broken, workaround exists | 1 week |
| P3 | Low — cosmetic, minor inconvenience | Next release |

**Categories:** critical crash, login/OTP, location, matching, chat/realtime, push notifications, SOS/safety, report/block, group/club, privacy/export/deletion, appeals, i18n/RTL, UI/UX, performance, Play Store install/update

## Metrics to track

**Daily metrics** (see `BETA_METRICS_DASHBOARD_SPEC.md`):

- Install count
- Signup completion rate
- OTP success rate
- Profile completion rate
- Location setup success rate
- Nearby search success rate
- Walk requests sent/accepted
- Chat messages sent
- Walks started/completed
- SOS test count
- Report/block count
- Group joins
- Club joins
- Feedback submissions
- Crashes + ANRs
- Uninstall rate

## Go/No-Go criteria

**GO for wider release only if ALL of the following are true** (see `PHASE_28_GO_NO_GO_CRITERIA.md`):

- No unresolved P0 bugs
- No unresolved safety P1 bugs
- Crash-free sessions > 95%
- OTP success rate > 95%
- Location flow reliable
- SOS/report/block verified on device
- Privacy/export/deletion flows work
- No exact location leak
- Admin monitoring works
- Testers can complete core walk flow
- Play Console has no policy blocker
- All features remain free

## Free product promise

WalkTogether is and will always be 100% free for everyone. Throughout the beta:
- No payments, no subscriptions, no premium features, no ads
- All features free, including safety features
- No data sold to third parties
- No advertising SDKs

This is verified by the automated free-product compliance scan and the IARC questionnaire (No to in-app purchases, No to ads).

## Acceptance criteria

- [ ] Signed release AAB uploaded to Play Console internal/closed testing
- [ ] Tester onboarding materials ready
- [ ] Beta test scenarios ready
- [ ] Safety monitoring SOP ready
- [ ] Bug triage process ready
- [ ] Beta metrics dashboard ready
- [ ] Go/no-go criteria documented
- [ ] WalkTogether remains 100% free for everyone
