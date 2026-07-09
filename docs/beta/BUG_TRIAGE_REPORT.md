# WalkTogether — Bug Triage Report

**Beta Period:** [START DATE] to [END DATE]  
**Last Updated:** [DATE]

---

## Bug Categories

| Category | Description |
|----------|-------------|
| 🔴 Critical crash | App crashes or becomes unusable |
| 🟠 Login/OTP issue | Authentication failures, OTP delivery problems |
| 🟡 Location issue | GPS denial, manual picker, location not updating |
| 🟡 Matching issue | Walkers not appearing, wrong distances, filters broken |
| 🟡 Chat issue | Messages not sending, not receiving, socket disconnections |
| 🟡 Notification issue | Push not delivered, wrong notification type, no badge |
| 🔴 SOS/safety issue | SOS fails, safety share broken, report/block fails |
| 🟡 Group walk issue | Join/leave broken, group chat access, host controls |
| 🟠 Admin issue | Admin panel errors, moderation actions fail |
| 🟢 UI/UX issue | Layout, text, color, animation problems |
| 🟢 Performance issue | Slow load, high battery, memory leaks |

---

## Bug Severity Levels

| Severity | Definition | SLA |
|----------|-----------|-----|
| 🔴 Critical | App crash, data loss, safety failure, privacy leak | Fix before launch |
| 🟠 High | Core flow broken, workarounds exist but painful | Fix before launch |
| 🟡 Medium | Non-core flow broken, workaround available | Fix in first update |
| 🟢 Low | Cosmetic, minor inconvenience | Backlog |

---

## Bug Tracker

| # | Title | Category | Severity | Device | OS | App Ver | Status | Owner | Fix Ver | Notes |
|---|-------|----------|----------|--------|----|---------|--------|-------|---------|-------|
| 1 | OTP not received on Jio network | Login/OTP | 🟠 High | Samsung A52 | Android 13 | 1.0.0 | ✅ Fixed | Backend | 1.0.1 | MSG91 delivery delay on Jio — added retry logic |
| 2 | Chat message delayed 3-5 seconds | Chat | 🟡 Medium | iPhone 14 | iOS 17 | 1.0.0 | ✅ Fixed | Backend | 1.0.1 | Socket reconnection interval reduced from 10s to 3s |
| 3 | Group chat not visible if joined after walk started | Group walk | 🟡 Medium | Various | Various | 1.0.0 | ✅ By Design | N/A | N/A | Expected: must join before walk starts to see chat |
| 4 | Push notification not delivered on Xiaomi MIUI | Notification | 🟡 Medium | Redmi Note 12 | Android 13 (MIUI 14) | 1.0.0 | ✅ Fixed | Mobile | 1.0.1 | MIUI battery optimization kills FCM — added battery optimization exemption prompt |
| 5 | Profile photo upload fails | UI/UX | 🟢 Low | Various | Various | 1.0.0 | ⏳ Deferred | Mobile | 1.1.0 | Not a launch blocker — profile photos optional |
| 6 | Location permission dialog appears twice on Android 12 | Location | 🟡 Medium | Samsung S22 | Android 12 | 1.0.0 | ✅ Fixed | Mobile | 1.0.1 | Removed duplicate permission request in Geolocator flow |
| 7 | "Hide me" toggle doesn't immediately remove from nearby | Matching | 🟡 Medium | Various | Various | 1.0.0 | ✅ Fixed | Backend | 1.0.1 | Added cache invalidation on hideMe toggle |
| 8 | Admin dashboard loads slowly (>3s) | Admin | 🟢 Low | Desktop | Chrome | 1.0.0 | ⏳ Deferred | Backend | 1.1.0 | Not a launch blocker — admin-only, acceptable during pilot |
| 9 | Nearby walkers list shows 0 walkers in 100m radius | Matching | 🟢 Low | Various | Various | 1.0.0 | ✅ By Design | N/A | N/A | Expected: 100m is very small radius, most walkers are further |
| 10 | App crashes on Samsung A50 when opening group chat | Critical crash | 🔴 Critical | Samsung A50 | Android 11 | 1.0.0 | ✅ Fixed | Mobile | 1.0.1 | Null pointer on missing participant data — added null check |

---

## Bug Summary

| Severity | Total | Fixed | Deferred | By Design |
|----------|-------|-------|----------|-----------|
| 🔴 Critical | 1 | 1 | 0 | 0 |
| 🟠 High | 1 | 1 | 0 | 0 |
| 🟡 Medium | 5 | 4 | 0 | 1 |
| 🟢 Low | 3 | 0 | 2 | 1 |
| **Total** | **10** | **6** | **2** | **2** |

## Critical Bug Details

### Bug #10: App crash on Samsung A50 when opening group chat
- **Severity:** 🔴 Critical
- **Reproduction:**
  1. Join a group walk
  2. Tap "Open group chat"
  3. App crashes immediately
- **Root cause:** Null pointer exception when participant data is missing from API response (race condition between join and chat load)
- **Fix:** Added null check in group chat screen — if participant data is null, show loading state and retry
- **Fix version:** 1.0.1
- **Verified:** ✅ Tester confirmed fix on same device

### Bug #1: OTP not received on Jio network
- **Severity:** 🟠 High
- **Reproduction:**
  1. Enter Jio phone number
  2. Tap "Send OTP"
  3. OTP never arrives (or arrives after 5+ minutes)
- **Root cause:** MSG91 has delivery delays on Jio network due to DLT registration
- **Fix:** Added retry logic — if OTP not received within 60 seconds, show "Resend OTP" button prominently. Backend logs MSG91 delivery status for debugging.
- **Fix version:** 1.0.1
- **Verified:** ✅ Tester received OTP within 30 seconds after fix

---

## Deferred Bugs (Post-Launch)

| # | Bug | Reason | Target Version |
|---|-----|--------|----------------|
| 5 | Profile photo upload fails | Optional feature, no safety impact | 1.1.0 |
| 8 | Admin dashboard slow | Admin-only, acceptable during pilot | 1.1.0 |

---

## Bug Report Template

```
BUG REPORT — WalkTogether

Title: [Short description]
Category: [Critical crash / Login-OTP / Location / Matching / Chat / Notification / SOS-safety / Group walk / Admin / UI-UX / Performance]
Severity: [Critical / High / Medium / Low]

DEVICE INFO:
Device: [e.g., Samsung Galaxy S23, iPhone 14]
OS version: [e.g., Android 14, iOS 17.2]
App version: [e.g., 1.0.0]

STEPS TO REPRODUCE:
1. 
2. 
3. 

EXPECTED RESULT:
[What should happen]

ACTUAL RESULT:
[What actually happened]

SCREENSHOTS/VIDEO:
[Attach if possible]

FREQUENCY:
[Always / Sometimes / Rarely]

WORKAROUND:
[Is there a way to continue using the app?]
```
