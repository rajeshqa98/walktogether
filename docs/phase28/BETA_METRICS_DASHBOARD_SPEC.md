# Beta Metrics Dashboard Spec

**Phase:** 28
**Status:** Spec ready — implement via admin dashboard
**Last updated:** 2026-07-06
**Owner:** SRE Lead + Product Lead

## Overview

This spec defines the metrics to track during the closed Android beta. Metrics are collected from the backend database, Play Console, and Firebase Crashlytics. They are reviewed daily during the beta period.

## Metrics categories

### 1. Acquisition + onboarding

| Metric | Source | Target | Alert if |
|---|---|---|---|
| Install count | Play Console | — | — |
| Signup started | AnalyticsEvent "signup_started" | — | — |
| Signup completed | User count | > 80% of installs | < 60% |
| OTP success rate | OtpAttempt (verified / total) | > 95% | < 90% |
| Profile completion rate | User count (isNewUser=false / total) | > 80% | < 60% |
| Location setup success | User count (city != null / total) | > 80% | < 60% |

### 2. Engagement

| Metric | Source | Target | Alert if |
|---|---|---|---|
| Nearby search success | AnalyticsEvent "nearby_search" | — | 0 in 24h (might mean app broken) |
| Walk requests sent | WalkRequest count | — | — |
| Walk requests accepted | WalkRequest (status=accepted / total) | > 30% | < 10% |
| Chat messages sent | Message count | — | — |
| Walks started | WalkSession count | — | — |
| Walks completed | WalkSession (status=ended / total) | > 70% | < 50% |
| Group walk joins | GroupWalkParticipant count | — | — |
| Club joins | WalkingClubMember count | — | — |
| Feedback submissions | UserFeedback count | — | — |

### 3. Safety

| Metric | Source | Target | Alert if |
|---|---|---|---|
| SOS events triggered | SafetyEvent (type=sos_triggered) | — | Any real SOS (not test) |
| Reports filed | Report count | — | > 5 per day (pattern?) |
| Blocks | Block count | — | Multiple blocks on same user |
| Flagged messages | Message (moderationStatus=flagged) | — | — |
| False positive rate | SafetyTask (outcome=false_positive / total) | < 10% | > 20% |
| Appeals submitted | Appeal count | — | — |
| Suspended users | User (status=suspended) | — | — |
| Banned users | User (status=banned) | — | — |
| Safety tasks open | SafetyTask (status=open) | 0 overdue | Any overdue |

### 4. Privacy + account

| Metric | Source | Target | Alert if |
|---|---|---|---|
| Privacy requests | PrivacyRequest count | — | Any overdue |
| Data exports | DataExportJob count | — | — |
| Deletion requests | AccountDeletionRequest count | — | — |
| Deletion cancellations | AccountDeletionRequest (status=cancelled) | — | — |
| Deletions finalized | AccountDeletionRequest (status=anonymized) | — | — |

### 5. Stability

| Metric | Source | Target | Alert if |
|---|---|---|---|
| Crash-free sessions | Play Console → Android Vitals | > 95% | < 90% |
| Crash-free users | Play Console → Android Vitals | > 95% | < 90% |
| ANR rate | Play Console → Android Vitals | < 0.5% | > 2% |
| Uninstall rate | Play Console | < 20% in 7 days | > 40% |
| API error rate | SLO dashboard | < 1% | > 5% |
| Socket disconnect rate | SLO dashboard | < 10% | > 30% |

### 6. Push notifications

| Metric | Source | Target | Alert if |
|---|---|---|---|
| FCM tokens registered | PushSubscription count | — | — |
| Push delivery success | SLO dashboard | > 95% | < 80% |
| Notification taps | AnalyticsEvent "notification_tapped" | — | — |

## Dashboard layout

### Admin dashboard (web)

Add a "Beta Metrics" tab to the existing admin dashboard at `/admin/beta-metrics` showing:

1. **Summary cards** (top of page):
   - Total testers (installed)
   - Active testers (last 24h)
   - Crash-free sessions
   - Open P0 bugs
   - Open safety concerns

2. **Acquisition funnel** (chart):
   - Installs → Signups → Profile setup → Location setup → First nearby search

3. **Engagement chart** (line chart, last 14 days):
   - Walk requests sent
   - Chat messages sent
   - Walks started
   - Walks completed

4. **Safety table**:
   - SOS events (last 7 days)
   - Reports (last 7 days)
   - Blocks (last 7 days)
   - Flagged messages (last 7 days)
   - Appeals (last 7 days)

5. **Stability table**:
   - Crash-free sessions (from Play Console)
   - ANR rate
   - Uninstall rate

6. **Privacy table**:
   - Privacy requests (open + completed)
   - Data exports (completed)
   - Deletion requests (pending grace + finalized)

## Data collection

### From backend database

Most metrics can be queried directly from the Prisma database:

```sql
-- Signup completion rate
SELECT
  COUNT(*) AS total_users,
  SUM(CASE WHEN "isNewUser" = false THEN 1 ELSE 0 END) AS completed_signup,
  ROUND(100.0 * SUM(CASE WHEN "isNewUser" = false THEN 1 ELSE 0 END) / COUNT(*), 1) AS completion_pct
FROM "User";

-- OTP success rate (last 24h)
SELECT
  COUNT(*) AS total_attempts,
  SUM(CASE WHEN verified = true THEN 1 ELSE 0 END) AS verified,
  ROUND(100.0 * SUM(CASE WHEN verified = true THEN 1 ELSE 0 END) / COUNT(*), 1) AS success_pct
FROM "OtpAttempt"
WHERE "createdAt" > NOW() - INTERVAL '24 hours';

-- Walk flow funnel (last 7 days)
SELECT
  (SELECT COUNT(*) FROM "WalkRequest" WHERE "createdAt" > NOW() - INTERVAL '7 days') AS requests_sent,
  (SELECT COUNT(*) FROM "WalkRequest" WHERE status = 'accepted' AND "createdAt" > NOW() - INTERVAL '7 days') AS requests_accepted,
  (SELECT COUNT(*) FROM "WalkSession" WHERE "startTime" > NOW() - INTERVAL '7 days') AS walks_started,
  (SELECT COUNT(*) FROM "WalkSession" WHERE status = 'ended' AND "startTime" > NOW() - INTERVAL '7 days') AS walks_completed;
```

### From Play Console

- Install count, uninstall rate, crash rate, ANR rate
- Manually check Play Console → Statistics + Android Vitals daily
- (Optional: automate via Play Developer API)

### From Firebase Crashlytics

- Crash reports, non-fatal errors, affected users
- Check Firebase Console → Crashlytics daily

## Daily metrics review

The Product Lead reviews metrics daily:

1. **Morning (before 10 AM):**
   - Check summary cards (any red flags?)
   - Review acquisition funnel (drop-off?)
   - Check safety table (any SOS? reports?)
   - Check stability (crashes? ANRs?)

2. **Evening (after 6 PM):**
   - Update metrics for the day
   - Compare to previous day
   - Note any trends

## Weekly metrics report

Every Friday, the Product Lead compiles a weekly report:

1. **Tester engagement:** How many active? How many completed scenarios?
2. **Funnel performance:** Where are users dropping off?
3. **Safety:** Any incidents? Any patterns?
4. **Stability:** Crash rate? ANR rate?
5. **Bugs:** How many reported? How many fixed?
6. **Go/no-go progress:** Are we on track for wider release?

## Alert thresholds

If any of the following thresholds are crossed, alert the Product Lead + SRE Lead immediately:

- Crash-free sessions < 90%
- OTP success rate < 90%
- Any real SOS (not a test)
- > 5 reports in 24 hours
- Push delivery < 80%
- Socket disconnect > 30%
- Any data leak suspicion

## Acceptance criteria

- [ ] Beta metrics dashboard accessible at `/admin/beta-metrics`
- [ ] All 6 metric categories tracked
- [ ] Daily metrics review by Product Lead
- [ ] Weekly metrics report compiled
- [ ] Alert thresholds configured
- [ ] Metrics feed into go/no-go decision
