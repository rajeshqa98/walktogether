# Real Device Bug Report

**Phase:** 29
**Status:** Template — fill in during beta
**Last updated:** 2026-07-06
**Owner:** Mobile Lead + QA Lead

## Overview

This report tracks all bugs found during the closed Android beta on real physical devices. Bugs are categorized by severity (P0–P3) and category (15 categories). The report feeds into the go/no-go decision.

## Bug summary

| Severity | Reported | Fixed | Verified | Open | Reopened |
|---|---|---|---|---|---|
| P0 (blocker) | [N] | [N] | [N] | [N] | [N] |
| P1 (high) | [N] | [N] | [N] | [N] | [N] |
| P2 (medium) | [N] | [N] | [N] | [N] | [N] |
| P3 (low) | [N] | [N] | [N] | [N] | [N] |
| **Total** | **[N]** | **[N]** | **[N]** | **[N]** | **[N]** |

## Bugs by category

| Category | P0 | P1 | P2 | P3 | Total | Open |
|---|---|---|---|---|---|---|
| Critical crash | [N] | [N] | [N] | [N] | [N] | [N] |
| Login/OTP | [N] | [N] | [N] | [N] | [N] | [N] |
| Location | [N] | [N] | [N] | [N] | [N] | [N] |
| Matching | [N] | [N] | [N] | [N] | [N] | [N] |
| Chat/realtime | [N] | [N] | [N] | [N] | [N] | [N] |
| Push notifications | [N] | [N] | [N] | [N] | [N] | [N] |
| SOS/safety | [N] | [N] | [N] | [N] | [N] | [N] |
| Report/block | [N] | [N] | [N] | [N] | [N] | [N] |
| Group/club | [N] | [N] | [N] | [N] | [N] | [N] |
| Privacy/export/deletion | [N] | [N] | [N] | [N] | [N] | [N] |
| Appeals | [N] | [N] | [N] | [N] | [N] | [N] |
| i18n/RTL | [N] | [N] | [N] | [N] | [N] | [N] |
| UI/UX | [N] | [N] | [N] | [N] | [N] | [N] |
| Performance | [N] | [N] | [N] | [N] | [N] | [N] |
| Play Store install/update | [N] | [N] | [N] | [N] | [N] | [N] |

## Bug detail log

### P0 — Blocker (must fix before wider release)

| Bug ID | Title | Category | Device | Android | Reported | Fixed | Verified | Status |
|---|---|---|---|---|---|---|---|---|
| WT-BUG-P0-001 | [description] | [category] | [device] | [version] | [date] | [date] | [date] | [status] |
| WT-BUG-P0-002 | [description] | [category] | [device] | [version] | [date] | [date] | [date] | [status] |

### P1 — High (fix within 48 hours)

| Bug ID | Title | Category | Device | Android | Reported | Fixed | Verified | Status |
|---|---|---|---|---|---|---|---|---|
| WT-BUG-P1-001 | [description] | [category] | [device] | [version] | [date] | [date] | [date] | [status] |
| WT-BUG-P1-002 | [description] | [category] | [device] | [version] | [date] | [date] | [date] | [status] |

### P2 — Medium (fix in next beta build)

| Bug ID | Title | Category | Device | Android | Reported | Fixed | Verified | Status |
|---|---|---|---|---|---|---|---|---|
| WT-BUG-P2-001 | [description] | [category] | [device] | [version] | [date] | [date] | [date] | [status] |

### P3 — Low (fix in V1.8)

| Bug ID | Title | Category | Device | Android | Reported | Fixed | Verified | Status |
|---|---|---|---|---|---|---|---|---|
| WT-BUG-P3-001 | [description] | [category] | [device] | [version] | [date] | [date] | [date] | [status] |

## P0 bug detail (if any)

### WT-BUG-P0-001: [Title]

**Description:**
[detailed description]

**Steps to reproduce:**
1. [step 1]
2. [step 2]
3. [step 3]

**Expected behavior:**
[what should happen]

**Actual behavior:**
[what actually happens]

**Device:** [model]
**Android version:** [version]
**App version:** 1.7.0
**Tester:** [name/initials]
**Screenshot:** [link or N/A]

**Root cause:**
[technical explanation]

**Fix:**
[what was changed]
Commit: [hash]

**Verification:**
[how it was verified + by whom]

**Status:** [Fixed / Verified / Closed]

---

*(copy template for each P0 bug)*

## Safety-critical bugs

Any bug in the SOS/safety, report/block, privacy/export/deletion, or appeals categories is safety-critical and gets extra scrutiny.

| Bug ID | Title | Severity | Safety impact | Fix | Verified |
|---|---|---|---|---|---|
| [ID] | [title] | P0/P1 | [impact description] | [yes/no] | [yes/no] |

## Fix priority order

Bugs are fixed in this order:

1. **P0 bugs** (all categories) — immediate, same day
2. **Safety P1 bugs** (SOS, report, block, deletion, privacy) — within 24 hours
3. **Auth/location/chat P1 bugs** — within 48 hours
4. **Privacy/export/deletion P2 bugs** — within 1 week
5. **Group/club P2 bugs** — within 1 week
6. **i18n/RTL P2/P3 bugs** — next build
7. **UI polish P3 bugs** — V1.8

## Bug trends

### Bugs found per day

| Day | P0 | P1 | P2 | P3 | Total |
|---|---|---|---|---|---|
| Day 1 | [N] | [N] | [N] | [N] | [N] |
| Day 2 | [N] | [N] | [N] | [N] | [N] |
| ... | ... | ... | ... | ... | ... |
| Day 14 | [N] | [N] | [N] | [N] | [N] |

### Average time to fix

| Severity | Target | Actual |
|---|---|---|
| P0 | 24 hours | [N] hours |
| P1 | 48 hours | [N] hours |
| P2 | 1 week | [N] days |
| P3 | Next release | [N] days |

## Common issues

### Most frequently reported issues

1. **[issue]** — reported by [N] testers
2. **[issue]** — reported by [N] testers
3. **[issue]** — reported by [N] testers

### Device-specific issues

| Device | Issues | Notes |
|---|---|---|
| Samsung Galaxy [model] | [N] | [notes] |
| Pixel [model] | [N] | [notes] |
| Xiaomi [model] | [N] | [notes] |
| OnePlus [model] | [N] | [notes] |

## Acceptance criteria

- [ ] All P0 bugs fixed + verified
- [ ] All safety P1 bugs fixed + verified
- [ ] All other P1 bugs fixed or documented as accepted risk
- [ ] P2/P3 bugs logged for future releases
- [ ] No bug reopen rate > 10%
- [ ] Bug trends decreasing (fewer bugs per day near end of beta)
