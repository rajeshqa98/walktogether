# Phase 28 Go/No-Go Criteria

**Phase:** 28
**Status:** Ready for evaluation at end of beta
**Last updated:** 2026-07-06
**Owner:** Product Lead + Safety Lead + Mobile Lead

## Overview

This document defines the criteria for deciding whether WalkTogether is ready for wider release after the closed Android beta. The decision is made by the Product Lead + Safety Lead + Mobile Lead collectively.

**All criteria must be met for a GO decision.** Any single failure results in a NO-GO and the beta is extended.

## Go/No-Go criteria

### 1. No unresolved P0 bugs

**Definition:** P0 = blocker (app crash, safety flow broken, data loss)

**Criteria:** Zero P0 bugs are open at the time of the go/no-go decision.

**Verification:**
- [ ] Check bug board: no P0 bugs with status "New", "Triaged", or "In progress"
- [ ] All P0 bugs from the beta have been fixed + verified + deployed
- [ ] No new P0 bugs reported in the last 48 hours

**If failed:** NO-GO. Fix all P0 bugs + extend beta by 1 week.

### 2. No unresolved safety P1 bugs

**Definition:** Safety P1 = high-severity bug in a safety flow (SOS, report, block, safety share, appeal, deletion)

**Criteria:** Zero safety P1 bugs are open.

**Verification:**
- [ ] Check bug board: no P1 bugs in categories "SOS/safety", "Report/block", "Privacy/export/deletion", "Appeals"
- [ ] All safety P1 bugs have been fixed + verified
- [ ] Safety Lead has signed off on safety readiness

**If failed:** NO-GO. Fix all safety P1 bugs + extend beta by 1 week.

### 3. Crash-free sessions acceptable

**Criteria:** Crash-free sessions ≥ 95% over the last 7 days of beta.

**Verification:**
- [ ] Check Play Console → Android Vitals → Crashes
- [ ] Crash-free sessions ≥ 95%
- [ ] No increasing trend in crashes

**If failed:** NO-GO. Investigate crash causes + fix + extend beta.

### 4. OTP flow reliable

**Criteria:** OTP success rate ≥ 95% over the last 7 days.

**Verification:**
- [ ] Check backend: `SELECT verified / total FROM OtpAttempt WHERE createdAt > 7 days ago`
- [ ] Success rate ≥ 95%
- [ | No common failure patterns

**If failed:** NO-GO. Investigate OTP provider + fix + extend beta.

### 5. Location flow reliable

**Criteria:**
- Location setup success rate ≥ 80% (users who complete location setup)
- No reports of wrong location detection
- No reports of exact location leakage

**Verification:**
- [ ] Check backend: % of users with city or village set
- [ ] No bug reports about location accuracy
- [ ] No bug reports about location privacy (exact coordinates visible to other users)
- [ ] Manual verification: nearby walkers show approximate distance, not exact coordinates

**If failed:** NO-GO. Fix location flow + extend beta.

### 6. SOS/report/block verified on device

**Criteria:** All safety flows have been verified working on at least 3 different physical devices by 3 different testers.

**Verification:**
- [ ] SOS: at least 3 testers successfully triggered SOS + safety event was created in admin
- [ ] Report: at least 3 testers successfully filed a report + it appeared in admin queue
- [ ] Block: at least 3 testers successfully blocked a user + blocked user could not contact them
- [ ] Safety share: at least 3 testers toggled safety share during a walk
- [ ] Appeal: at least 1 tester submitted an appeal + it appeared in admin queue

**If failed:** NO-GO. Fix safety flows + extend beta.

### 7. Privacy/export/deletion flows work

**Criteria:**
- Data export: tester can download their data as JSON
- Account deletion: tester can start deletion + cancel during grace period
- Privacy requests: tester can submit + it appears in admin queue

**Verification:**
- [ ] At least 3 testers successfully downloaded their data
- [ ] At least 1 tester started account deletion + saw the account-status screen
- [ ] At least 1 tester cancelled deletion + returned to normal app usage
- [ ] At least 3 testers submitted privacy requests + they appeared in admin queue
- [ ] Data export does NOT contain other users' private data (phone, email, coordinates)
- [ ] Data export partially redacts the user's own phone number

**If failed:** NO-GO. Fix privacy flows + extend beta.

### 8. No exact location leak

**Criteria:** No instance of exact user coordinates being exposed to other users.

**Verification:**
- [ ] Security review: no `/api/walkers` response contains lat/lng of other users
- [ ] Security review: no admin export contains exact coordinates
- [ ] Security review: no chat message contains coordinates
- [ ] No tester reported seeing exact coordinates of another user
- [ ] No log file contains exact coordinates (redaction works)

**If failed:** NO-GO. This is a critical privacy violation. Fix immediately + extend beta.

### 9. Admin monitoring works

**Criteria:** Admin safety monitoring SOP has been followed throughout the beta.

**Verification:**
- [ ] Daily safety checklist completed every day (check worklog)
- [ ] All SOS events reviewed
- [ ] All reports reviewed within SLA
- [ ] All safety concerns from feedback reviewed within 1 hour
- [ ] Weekly safety reviews documented
- [ ] No safety incidents unresolved

**If failed:** NO-GO. Review what was missed + extend beta with proper monitoring.

### 10. Testers can complete core walk flow

**Criteria:** At least 50% of active testers have completed the core walk flow:
- Send walk request → accepted → chat → start walk → end walk → rate

**Verification:**
- [ ] Check backend: at least 50% of active testers have a completed WalkSession
- [ ] At least 50% have submitted a rating
- [ ] No common failure in the walk flow (check bug board)

**If failed:** NO-GO. Investigate where testers are dropping off + fix + extend beta.

### 11. Play Console has no policy blocker

**Criteria:** No Play Console policy violations or warnings.

**Verification:**
- [ ] Check Play Console → Policy status: no violations
- [ ] No "App rejected" or "App suspended" notices
- [ ] No warnings about content, data safety, or permissions
- [ ] Content rating confirmed (Everyone)
- [ ] Data Safety form approved
- [ ] No user reports that could trigger policy review

**If failed:** NO-GO. Resolve Play Console issues before wider release.

### 12. All features remain free

**Criteria:** No paid features, subscriptions, premium features, or ads have been introduced.

**Verification:**
- [ ] Automated free-product compliance scan: 0 forbidden terms
- [ ] No payment gateway integrations in codebase
- [ ] No subscription models
- [ ] No premium feature flags
- [ ] No ad SDK integrations
- [ ] Play Console listing: "No" to in-app purchases, "No" to ads
- [ ] App description includes "100% FREE — No payments, no subscriptions, no premium features, no ads"

**If failed:** NO-GO. This violates the core product promise. Remove any paid features.

## Decision matrix

| Criterion | Status | Notes |
|---|---|---|
| 1. No unresolved P0 bugs | [ ] GO / [ ] NO-GO | |
| 2. No unresolved safety P1 bugs | [ ] GO / [ ] NO-GO | |
| 3. Crash-free sessions ≥ 95% | [ ] GO / [ ] NO-GO | |
| 4. OTP success rate ≥ 95% | [ ] GO / [ ] NO-GO | |
| 5. Location flow reliable | [ ] GO / [ ] NO-GO | |
| 6. SOS/report/block verified | [ ] GO / [ ] NO-GO | |
| 7. Privacy/export/deletion work | [ ] GO / [ ] NO-GO | |
| 8. No exact location leak | [ ] GO / [ ] NO-GO | |
| 9. Admin monitoring works | [ ] GO / [ ] NO-GO | |
| 10. Core walk flow completes | [ ] GO / [ ] NO-GO | |
| 11. Play Console no blocker | [ ] GO / [ ] NO-GO | |
| 12. All features free | [ ] GO / [ ] NO-GO | |

## Final decision

**GO for wider release:** ALL 12 criteria are GO.

**NO-GO:** ANY criterion is NO-GO. Extend beta by 1–2 weeks, fix issues, re-evaluate.

### Sign-off

| Role | Name | Signature | Date |
|---|---|---|---|
| Product Lead | | | |
| Safety Lead | | | |
| Mobile Lead | | | |
| SRE Lead | | | |

## If GO: next steps

1. Promote build from Closed Testing to Open Testing (beta track)
2. Expand tester list from 50 to 500+ via opt-in link
3. Monitor for 1–2 more weeks
4. If stable: promote to Production with staged rollout (10% → 50% → 100%)

## If NO-GO: next steps

1. Document which criteria failed + why
2. Create fix plan with timelines
3. Extend beta by 1–2 weeks
4. Re-evaluate at end of extended beta
5. Do NOT expand tester count until all criteria pass

## Free product promise

Regardless of the go/no-go decision, WalkTogether remains 100% free for everyone. No payments, subscriptions, premium features, ads, or monetization will ever be introduced. Safety is not a paid feature — it's a right.
