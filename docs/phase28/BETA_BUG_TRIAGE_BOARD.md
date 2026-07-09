# Beta Bug Triage Board

**Phase:** 28
**Status:** Active throughout beta
**Last updated:** 2026-07-06
**Owner:** Mobile Lead + QA Lead

## Overview

This document defines the bug triage process for the closed Android beta. Bugs are categorized by type and severity, then prioritized for fixing.

## Bug categories

| Category | Description | Examples |
|---|---|---|
| Critical crash | App crashes or freezes | App crashes on startup, crash during SOS, crash during walk |
| Login/OTP | Authentication issues | OTP not received, OTP verify fails, session expires unexpectedly |
| Location | Location-related issues | GPS permission denied, wrong location detected, manual entry fails |
| Matching | Nearby walker issues | No walkers shown, wrong distance, walker not found |
| Chat/realtime | Chat + socket issues | Messages not sent, messages not received, socket disconnects |
| Push notifications | FCM + notification issues | No push received, notification tap doesn't navigate, permission denied |
| SOS/safety | Safety flow issues | SOS button not working, safety share fails, report/block fails |
| Report/block | Report + block issues | Report not submitted, block doesn't prevent contact |
| Group/club | Group walk + club issues | Join fails, leave fails, group chat not working |
| Privacy/export/deletion | Privacy flow issues | Data export fails, deletion doesn't start, can't cancel deletion |
| Appeals | Appeal issues | Appeal not submitted, appeal status not updating |
| i18n/RTL | Language + RTL issues | Missing translation, RTL layout broken, language doesn't persist |
| UI/UX | Interface issues | Text overflow, button not tappable, wrong color |
| Performance | Speed + memory issues | Slow load, high memory, battery drain |
| Play Store install/update | Distribution issues | Can't install from Play Store, update fails |

## Severity levels

| Severity | Definition | Response time | Fix target |
|---|---|---|---|
| **P0** | Blocker — app crash, safety flow broken, data loss | Immediate (same day) | Fix + deploy within 24 hours |
| **P1** | High — core feature broken, no workaround | 48 hours | Fix within 2 days |
| **P2** | Medium — feature partially broken, workaround exists | 1 week | Fix in next beta build |
| **P3** | Low — cosmetic, minor inconvenience | Next release | Fix in V1.8 |

## Triage process

### 1. Bug reported

Bugs are reported via:
- In-app feedback (More → Give feedback, category = "bug")
- Email to support@walktogether.app
- Play Console crash reports
- Admin observing issues during safety monitoring

### 2. Bug logged

For each bug, create an entry in the bug tracker (spreadsheet or GitHub Issues):

| Field | Description |
|---|---|
| Bug ID | Auto-incremented (e.g. WT-BUG-001) |
| Title | Short description |
| Category | One of the 15 categories above |
| Severity | P0, P1, P2, or P3 |
| Reported by | Tester name or "admin" |
| Reported date | When the bug was reported |
| Description | Detailed description |
| Steps to reproduce | Exact steps to trigger the bug |
| Expected behavior | What should happen |
| Actual behavior | What actually happens |
| Screenshots | If available |
| Device | Phone model + Android version |
| App version | 1.7.0 |
| Status | New / Triaged / In progress / Fixed / Verified / Closed |
| Assigned to | Developer assigned |
| Fix commit | Git commit hash |
| Verified by | Who verified the fix |

### 3. Bug triaged

The Mobile Lead triages bugs daily:

1. **Read the bug report** — understand what happened
2. **Reproduce** — try to reproduce on a test device
3. **Categorize** — assign to one of the 15 categories
4. **Severity** — assign P0/P1/P2/P3 based on impact
5. **Assign** — assign to a developer
6. **Status** → "Triaged"

### 4. Bug fixed

The assigned developer:

1. **Investigate** — find the root cause
2. **Fix** — implement the fix
3. **Test** — verify the fix works
4. **Commit** — commit with message "fix: WT-BUG-XXX description"
5. **Status** → "Fixed"

### 5. Bug verified

The QA Lead (or Mobile Lead):

1. **Reproduce** — try to reproduce on a test device with the fix
2. **Verify** — confirm the fix works + no new issues
3. **Status** → "Verified" → "Closed"

### 6. Bug deployed

For P0/P1 bugs:
1. Build new release APK + AAB
2. Upload to Play Console Internal Testing
3. Notify testers to update
4. Verify fix on tester devices

For P2/P3 bugs:
1. Fix in next scheduled beta build (weekly)
2. Include in release notes

## Bug board template

| ID | Title | Category | Severity | Status | Assigned | Reported | Fixed |
|---|---|---|---|---|---|---|---|
| WT-BUG-001 | (example) App crashes on SOS tap | SOS/safety | P0 | Fixed | Dev1 | 2026-07-07 | 2026-07-07 |
| WT-BUG-002 | (example) Hindi text overflow on login | i18n/RTL | P3 | New | — | 2026-07-07 | — |
| WT-BUG-003 | (example) Chat messages not received in real-time | Chat/realtime | P1 | In progress | Dev2 | 2026-07-08 | — |

## P0 criteria

A bug is P0 if ANY of the following are true:

- App crashes on startup
- App crashes during SOS (safety-critical)
- App crashes during active walk session
- Login is completely broken (no one can log in)
- Data loss (user data deleted without user action)
- Location data leaked to other users (privacy violation)
- SOS fails to create safety event (safety-critical)
- Any safety flow is completely broken

**P0 bugs block beta expansion.** All P0 bugs must be fixed + verified before adding more testers.

## P1 criteria

A bug is P1 if ANY of the following are true:

- Core feature broken (nearby search, walk request, chat, walk session) with no workaround
- OTP delivery unreliable (>5% failure rate)
- Push notifications not delivered (>20% failure rate)
- Report/block doesn't work
- Account deletion doesn't start
- Data export fails
- Appeal submission fails
- Socket disconnects frequently (>30% disconnect rate)

**P1 bugs should be fixed within 48 hours.** Safety P1 bugs block beta expansion.

## Weekly bug review

Every Friday, the Mobile Lead + QA Lead conduct a weekly bug review:

1. **Open bugs:** How many? By severity? By category?
2. **Fixed this week:** How many? Verified?
3. **P0/P1 bugs:** All resolved? Any new?
4. **Trends:** Are bugs increasing or decreasing?
5. **Tester feedback:** Any common themes?

Document the review in the worklog.

## Bug metrics to track

- Total bugs reported
- Bugs by severity (P0/P1/P2/P3)
- Bugs by category
- Average time to fix (by severity)
- Bug reopen rate (bugs that came back after "fix")
- Crash-free sessions (from Play Console → Android Vitals)
- ANR rate (Application Not Responding)

## Acceptance criteria

- [ ] Bug tracker set up (spreadsheet or GitHub Issues)
- [ ] All reported bugs logged within 24 hours
- [ ] All P0 bugs fixed within 24 hours
- [ ] All P1 bugs fixed within 48 hours
- [ ] Weekly bug review conducted
- [ ] No unresolved P0 bugs before beta expansion
- [ ] No unresolved safety P1 bugs before beta expansion
