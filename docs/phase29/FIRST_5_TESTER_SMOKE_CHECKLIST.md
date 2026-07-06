# First 5 Tester Smoke Checklist

**Phase:** 29C-Handoff
**Status:** Ready for execution after Play Console upload
**Last updated:** 2026-07-06

## Overview

Before inviting all 20–50 beta testers, invite **5 testers first** to verify the app installs, opens, and core flows work. Only after all 5 pass this smoke test should you expand to the full beta group.

## Tester mix

| # | Tester type | Profile | Focus areas |
|---|---|---|---|
| 1 | City user | Lives in a dense urban area | Nearby walkers list, walker detail, send walk request |
| 2 | Small-town user | Lives in a smaller town | Fewer walkers, empty states, invite flow |
| 3 | Village/manual-location user | Rural area, no GPS | Manual village/town/city entry, first-walker experience |
| 4 | Safety-focused tester | Priority: safety features | SOS button, safety share, report/block, safety disclaimer |
| 5 | Group/club tester | Interested in group walks | Group walk list, join, group chat, club list, join |

## Smoke test scenarios

Each tester completes this checklist (estimated 15–20 minutes):

### 1. Install

- [ ] Open Play Console opt-in link on Android device
- [ ] Tap "Join testing"
- [ ] Search "WalkTogether" in Play Store
- [ ] Install app (free — no payment required)
- [ ] App icon appears in launcher

### 2. App opens

- [ ] Tap app icon
- [ ] Splash screen displays (WalkTogether logo + "100% free • safety-first • community-first")
- [ ] App does NOT crash on startup
- [ ] Login screen loads within 5 seconds

### 3. Signup / login

- [ ] Phone number input visible
- [ ] Enter phone number with country code (e.g. +919876543210)
- [ ] Tap "Send OTP"
- [ ] OTP received via SMS (within 60 seconds)
- [ ] Enter OTP code
- [ ] Tap "Verify & continue"
- [ ] App navigates to profile setup

### 4. Profile setup

- [ ] Name input visible
- [ ] Enter name
- [ ] Age range dropdown works
- [ ] Gender dropdown works
- [ ] Bio input (optional)
- [ ] Tap "Continue"
- [ ] Navigates to location setup

### 5. Manual village/town location

- [ ] Location permission screen loads
- [ ] "Enter location manually" option visible
- [ ] Tap "Enter location manually"
- [ ] Village field appears (optional)
- [ ] Town field appears (optional)
- [ ] City field appears (required)
- [ ] District field appears (optional)
- [ ] State field appears (optional)
- [ ] Enter city
- [ ] Tap "Save and continue"
- [ ] Navigates to home screen

### 6. Home loads

- [ ] Home screen displays
- [ ] Bottom navigation visible (Nearby / Groups / Clubs / More)
- [ ] Nearby tab shows walkers list OR "No walkers nearby yet" message
- [ ] No crash
- [ ] Settings icon visible (top right)

### 7. Walker detail opens

- [ ] If walkers exist: tap a walker → detail screen opens
- [ ] Walker name visible
- [ ] Distance visible (approximate — NOT exact coordinates)
- [ ] "Send walk request" button visible
- [ ] If no walkers: skip this step

### 8. Settings opens

- [ ] Tap settings icon (or More → Settings)
- [ ] Settings screen loads
- [ ] Language picker visible (9 languages)
- [ ] "Hide me from nearby" toggle visible
- [ ] "Download my data" visible
- [ ] "Privacy requests" visible
- [ ] "My appeals" visible
- [ ] "Delete my account" visible (red text)
- [ ] "Log out" visible
- [ ] Version shows "WalkTogether v1.7.0 (27)"

### 9. Feedback submits

- [ ] Go to More → "Give feedback"
- [ ] Category dropdown works (general, bug, safety concern, feature request)
- [ ] Star rating works (1–5 stars)
- [ ] Message input visible
- [ ] Enter a test feedback message
- [ ] Tap "Submit feedback"
- [ ] "Thank you!" message appears

### 10. No startup crash

- [ ] Close the app completely (swipe away from recent apps)
- [ ] Reopen the app
- [ ] App opens without crash
- [ ] Session persists (no re-login required)

## Pass / fail criteria

**PASS:** All 10 scenarios complete without blocking issues. Minor bugs (P3 UI issues) are acceptable.

**FAIL:** Any of the following:
- App crashes on startup
- Login impossible (OTP not received or verify fails)
- Home screen doesn't load
- Settings doesn't load
- App crashes on reopen

## If a tester fails

1. Document the issue (what happened, device model, Android version)
2. Report via: More → Give feedback (category = "bug")
3. Triage the bug using `BETA_BUG_TRIAGE_BOARD.md` severity levels
4. If P0: fix immediately, rebuild, re-upload to Play Console
5. If P1: fix within 48 hours
6. Do NOT expand to 20–50 testers until all 5 pass

## Tester communication

Send each tester:

1. **Play Console opt-in link** (from Internal Testing track)
2. **Onboarding message** from `docs/phase28/TESTER_ONBOARDING_MESSAGE.md`
3. **This smoke checklist** (or link to it)
4. **Safety reminder:** "Do not meet unknown people privately during testing. Use public places only."

## After all 5 pass

1. Update `docs/phase29/TESTER_PARTICIPATION_REPORT.md` with smoke test results
2. Update `docs/phase29/CLOSED_BETA_EXECUTION_LOG.md` with Day 1 entry
3. Expand to 20–50 testers:
   - Add more emails to Play Console Closed Testing
   - Send onboarding message to all new testers
   - Begin 2-week beta test period
   - Start daily safety monitoring
