# Phase 29D Execution Guide

**Phase:** 29D
**Status:** BLOCKED — requires real tester data
**Last updated:** 2026-07-06
**Owner:** Product Lead + Safety Lead + Mobile Lead

## ⚠️ Important

**Phase 29D cannot be completed in the sandbox.** It requires:
- Real human testers (20–50 people) who have installed the app
- Real feedback from those testers
- Real bug reports from physical device testing
- Real safety monitoring of actual user activity
- Real metrics from actual app usage

**Do not mark Phase 29D complete until all of the above are collected and the go/no-go decision is made with real data.**

## Prerequisites (must be done first)

Before Phase 29D can begin, the product team must complete:

1. ✅ Build signed AAB on local machine (see `LOCAL_MACHINE_BUILD_RUNBOOK.md`)
2. ✅ Upload AAB to Play Console Internal Testing (see `PLAY_CONSOLE_SUBMISSION_CHECKLIST.md`)
3. ✅ First 5 testers pass smoke test (see `FIRST_5_TESTER_SMOKE_CHECKLIST.md`)
4. ⏳ Expand to 20–50 testers (this is where Phase 29D begins)

## Step 1: Expand Tester Group

After first 5 testers pass smoke test:

### Tester recruitment target

| Group | Target | Invite from |
|---|---|---|
| City users | 10–15 | Walking groups in major cities |
| Small-town users | 5–10 | Community centers, local groups |
| Village/manual-location | 3–5 | Rural contacts, village WhatsApp groups |
| Women safety testers | 5–8 | Women's walking groups, safety advocates |
| Host testers | 2–3 | People interested in organizing walks |
| Group walk testers | 3–5 | People who want group activities |
| Multilingual testers | 5–8 | Non-English speakers (Hindi, Tamil, Arabic, etc.) |
| Low-density area testers | 2–3 | People in areas with no other walkers |

### Actions

1. Add 20–50 tester emails to Play Console Closed Testing track
2. Send each tester the onboarding message (`docs/phase28/TESTER_ONBOARDING_MESSAGE.md`)
3. Share the Play Console opt-in link
4. Track in `docs/phase29/TESTER_PARTICIPATION_REPORT.md`

### Track per tester

| Field | Where to record |
|---|---|
| Invited date | TESTER_PARTICIPATION_REPORT.md |
| Accepted invite | TESTER_PARTICIPATION_REPORT.md |
| Installed app | TESTER_PARTICIPATION_REPORT.md |
| Completed signup | TESTER_PARTICIPATION_REPORT.md |
| Completed profile | TESTER_PARTICIPATION_REPORT.md |
| Completed test scenarios | TESTER_PARTICIPATION_REPORT.md |
| Submitted feedback | TESTER_PARTICIPATION_REPORT.md |
| Reported bugs | REAL_DEVICE_BUG_REPORT.md |

## Step 2: Daily Beta Monitoring

**Frequency:** Every day during the 2-week beta period
**Time:** Morning (before 10 AM) + evening (after 6 PM)
**Duration:** 15–30 minutes per check

### Update daily in CLOSED_BETA_EXECUTION_LOG.md

| Metric | Source |
|---|---|
| Installs | Play Console → Statistics |
| Signups | Backend: `SELECT COUNT(*) FROM User WHERE createdAt > today` |
| OTP success rate | Backend: `SELECT verified/total FROM OtpAttempt WHERE createdAt > today` |
| Profile completion | Backend: `SELECT COUNT(*) FROM User WHERE isNewUser = false AND createdAt > today` |
| Location setup | Backend: `SELECT COUNT(*) FROM User WHERE city IS NOT NULL AND createdAt > today` |
| Nearby searches | Backend: AnalyticsEvent count |
| Walk requests sent | Backend: `SELECT COUNT(*) FROM WalkRequest WHERE createdAt > today` |
| Requests accepted | Backend: `SELECT COUNT(*) FROM WalkRequest WHERE status = 'accepted' AND createdAt > today` |
| Chat messages | Backend: `SELECT COUNT(*) FROM Message WHERE createdAt > today` |
| Walks started | Backend: `SELECT COUNT(*) FROM WalkSession WHERE startTime > today` |
| Walks completed | Backend: `SELECT COUNT(*) FROM WalkSession WHERE status = 'ended' AND startTime > today` |
| Group joins | Backend: `SELECT COUNT(*) FROM GroupWalkParticipant WHERE joinedAt > today` |
| Club joins | Backend: `SELECT COUNT(*) FROM WalkingClubMember WHERE joinedAt > today` |
| Feedback submitted | Backend: `SELECT COUNT(*) FROM UserFeedback WHERE createdAt > today` |
| Crashes | Play Console → Android Vitals → Crashes |
| ANRs | Play Console → Android Vitals → ANRs |

## Step 3: Safety Monitoring

**Frequency:** Every day during beta (including weekends)
**Owner:** Safety Lead

### Daily safety checklist

Update `docs/phase29/SAFETY_MONITORING_REPORT.md` daily:

- [ ] Check SOS events (all tests? any real emergencies?)
- [ ] Check reports filed (review each within SLA)
- [ ] Check blocks (any pattern — multiple users blocking same person?)
- [ ] Check flagged messages (false positive rate?)
- [ ] Check appeals submitted (review within SLA)
- [ ] Check safety review tasks (any overdue?)
- [ ] Check privacy requests (process within SLA)
- [ ] Check deletion requests (grace period tracking)
- [ ] Check feedback tagged "safety concern" (review within 1 hour)

### Safety rules

1. **Every real safety issue gets manual review** — no automation-only punishment
2. **No exact location exposure** — verify via security review
3. **All admin decisions documented** — audit log every action
4. **Any real safety concern blocks beta expansion** — do not add more testers until resolved

### Escalation

| Severity | Example | Response time |
|---|---|---|
| Critical | Real SOS, data leak, child safety | Immediate |
| High | Harassment report, threat pattern | 1 hour |
| Medium | Inappropriate message, minor dispute | 24 hours |
| Low | Profile photo violation | 72 hours |

## Step 4: Bug Triage

**Owner:** Mobile Lead + QA Lead

### Classify bugs in REAL_DEVICE_BUG_REPORT.md

| Severity | Definition | Fix target |
|---|---|---|
| P0 | Crash, login impossible, SOS/report failure, privacy leak | Same day |
| P1 | Core walk/chat/location/safety flow broken | 48 hours |
| P2 | Non-blocking feature issue | 1 week |
| P3 | UI/copy/polish | Next release |

### Fix priority order

1. P0 bugs (all categories)
2. Safety P1 bugs (SOS, report, block, deletion, privacy)
3. Auth/location/chat P1 bugs
4. Privacy/export/deletion bugs
5. Group/club bugs
6. i18n/RTL bugs
7. UI polish

### Bug tracking template

For each bug, record in `REAL_DEVICE_BUG_REPORT.md`:
- Bug ID (e.g. WT-BUG-P0-001)
- Title
- Severity (P0/P1/P2/P3)
- Category (15 categories — see bug triage board)
- Description
- Steps to reproduce
- Expected vs actual behavior
- Device model + Android version
- Tester name
- Screenshot (if available)
- Status (New → Triaged → In progress → Fixed → Verified → Closed)

## Step 5: Patch Release (if needed)

If P0/P1 bugs are fixed during beta:

1. Increment versionCode in `pubspec.yaml` (27 → 28)
2. Update release notes in `V1_8_BETA_PATCH_RELEASE_NOTES.md`
3. Rebuild signed AAB on local machine:
   ```bash
   flutter build appbundle --release
   ```
4. Upload patch to Play Console Internal/Closed Testing
5. Notify testers (email or WhatsApp)
6. Testers update app + retest fixed flows
7. Record in `CLOSED_BETA_FIXES_REPORT.md`

## Step 6: Final Go/No-Go Decision

**After 2 weeks of beta testing, fill `PHASE_29_GO_NO_GO_DECISION.md` with real data.**

### GO only if ALL 12 criteria pass:

| # | Criterion | Target | How to verify |
|---|---|---|---|
| 1 | No open P0 bugs | 0 open | Check REAL_DEVICE_BUG_REPORT.md |
| 2 | No open safety P1 bugs | 0 open | Check REAL_DEVICE_BUG_REPORT.md |
| 3 | Crash-free sessions ≥ 95% | ≥ 95% | Play Console → Android Vitals |
| 4 | OTP success rate ≥ 95% | ≥ 95% | Backend OtpAttempt query |
| 5 | Location flow reliable | ≥ 80% setup, 0 leaks | Backend + security review |
| 6 | SOS/report/block verified | 3+ devices each | Tester verification |
| 7 | Privacy/export/deletion work | 3+ testers each | Tester verification |
| 8 | No exact location leak | 0 instances | Security review + tester reports |
| 9 | Admin monitoring works | 100% daily | Worklog + safety report |
| 10 | Core walk flow completes | ≥ 50% of testers | Backend WalkSession count |
| 11 | Play Console no blocker | No issues | Play Console → Policy status |
| 12 | All features free | 0 forbidden terms | Automated scan |

### Decision

- **GO:** All 12 criteria pass → promote to Open Testing → then Production
- **NO-GO:** Any criterion fails → fix issues → extend beta 1–2 weeks → re-evaluate

### Sign-off required

| Role | Must sign |
|---|---|
| Product Lead | Yes |
| Safety Lead | Yes |
| Mobile Lead | Yes |
| SRE Lead | Yes |

## Step 7: Update GitHub Docs

After collecting real beta data:

```bash
# Update all Phase 29 docs with real numbers
# Then commit only docs (no secrets, no build artifacts)

git add docs/phase29/
git commit -m "Phase 29D closed beta monitoring results"
git push origin main
```

**Do not commit:**
- `.jks` keystore
- `key.properties`
- `google-services.json`
- APK/AAB files
- build folders
- `.env`

## Acceptance criteria checklist

- [ ] 20–50 testers invited (or rollout blocker documented)
- [ ] Real tester installs tracked in TESTER_PARTICIPATION_REPORT.md
- [ ] Real feedback collected (count in BETA_METRICS_REVIEW.md)
- [ ] Bugs triaged in REAL_DEVICE_BUG_REPORT.md (P0/P1/P2/P3)
- [ ] Safety monitoring completed in SAFETY_MONITORING_REPORT.md
- [ ] Patch release prepared if needed (CLOSED_BETA_FIXES_REPORT.md)
- [ ] Go/no-go decision filled with real data in PHASE_29_GO_NO_GO_DECISION.md
- [ ] WalkTogether remains 100% free (automated scan: 0 forbidden terms)

## Free product promise

WalkTogether is and will always be 100% free for everyone. No payments, subscriptions, premium features, ads, or monetization. Safety is not a paid feature — it's a right. This is verified by the automated free-product compliance scan throughout the beta.
