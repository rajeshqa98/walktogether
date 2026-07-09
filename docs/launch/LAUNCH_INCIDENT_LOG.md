# WalkTogether — Launch Incident Log

**Monitoring Period:** 30 days post-launch  
**Last Updated:** [DATE]

---

## Incident Management Process

### Incident Severity Levels

| Level | Definition | Response Time | Communication |
|-------|-----------|---------------|---------------|
| 🔴 P0 — Critical | Safety failure, privacy leak, data loss, widespread outage | 1 hour | Email all affected users + admin alert |
| 🟠 P1 — High | Core feature broken for many users, OTP outage | 4 hours | In-app banner + support email |
| 🟡 P2 — Medium | Feature degraded, workaround exists | 24 hours | Support email to affected users |
| 🟢 P3 — Low | Minor bug, cosmetic issue | 72 hours | Fix in next release |

### Incident Response Flow
1. **Detect** — Admin notices, user reports, or automated alert
2. **Triage** — Assign severity (P0-P3)
3. **Investigate** — Identify root cause
4. **Fix** — Deploy hotfix or workaround
5. **Communicate** — Notify affected users
6. **Document** — Log in this incident report
7. **Prevent** — Add prevention step to prevent recurrence

---

## Incident Log

### Incident #1: OTP delivery delay on Jio network
- **Date:** Day 1
- **Severity:** 🟠 P1
- **Affected:** India (Jio users)
- **Affected users:** ~15
- **Root cause:** MSG91 had DLT-related delivery delays on Jio numbers
- **Fix:** Added OTP retry logic + prominent "Resend OTP" button (v1.0.1)
- **Admin action:** Monitored OTP delivery logs; contacted MSG91 support
- **User communication:** In-app message: "Having trouble receiving OTP? Tap 'Resend OTP' or try again in a few minutes."
- **Prevention:** OTP delivery monitoring added to daily checklist; MSG91 SLA reviewed

### Incident #2: App crash on Samsung A50 (group chat)
- **Date:** Day 2
- **Severity:** 🔴 P0
- **Affected:** Global (Samsung A50 users)
- **Affected users:** ~3
- **Root cause:** Null pointer exception when participant data missing from API response
- **Fix:** Added null check + loading state in group chat screen (v1.0.1)
- **Admin action:** Identified device pattern from crash logs
- **User communication:** Direct email to affected users with fix timeline
- **Prevention:** Added null safety checks on all API response parsing

### Incident #3: Push notifications not delivered on Xiaomi MIUI
- **Date:** Day 3
- **Severity:** 🟡 P2
- **Affected:** Global (Xiaomi users)
- **Affected users:** ~8
- **Root cause:** MIUI battery optimization kills FCM background service
- **Fix:** Added battery optimization exemption prompt on first notification enable (v1.0.1)
- **Admin action:** Documented in known limitations
- **User communication:** Support email with instructions to disable battery optimization for WalkTogether
- **Prevention:** MIUI-specific FAQ added to support templates

### Incident #4: Hide-me toggle not immediately effective
- **Date:** Day 5
- **Severity:** 🟡 P2
- **Affected:** Global
- **Affected users:** ~5
- **Root cause:** Nearby walkers API cached results for 60 seconds
- **Fix:** Added cache invalidation on hideMe toggle (v1.0.1)
- **Admin action:** Verified fix works
- **User communication:** None needed — fix deployed silently
- **Prevention:** All toggle actions now invalidate relevant caches

### Incident #5: Delhi SOS — real safety concern
- **Date:** Day 24
- **Severity:** 🔴 P0 (safety)
- **Affected:** Delhi, India
- **Affected users:** 1 (SOS trigger) + 1 (partner banned)
- **Root cause:** Walking partner made unwanted advances during walk
- **Fix:** No code fix needed — safety system worked as designed
- **Admin action:** Investigated within 1 hour. Banned the partner. Contacted affected user. Created safety event record.
- **User communication:** Email to affected user: "We're sorry you had this experience. Your safety is our priority. The user has been banned. If you need support, please contact safety@walktogether.app or call 112."
- **Prevention:** Added safety tips for Delhi users. Monitoring Delhi report rate. Considering pause if pattern continues.

### Incident #6: Location permission dialog appears twice (Android 12)
- **Date:** Day 7
- **Severity:** 🟢 P3
- **Affected:** Android 12 users
- **Affected users:** ~4
- **Root cause:** Geolocator plugin triggered duplicate permission request
- **Fix:** Removed duplicate permission request in location flow (v1.0.1)
- **Admin action:** Verified fix
- **User communication:** None needed
- **Prevention:** Location permission flow tested on all Android versions 11-14

---

## Incident Summary

| Severity | Count | Avg Resolution Time | Root Causes |
|----------|-------|---------------------LA--------|-------------|
| 🔴 P0 | 2 | 2.5 hours | Null safety (code), user behavior (safety) |
| 🟠 P1 | 1 | 4 hours | Third-party SMS delivery |
| 🟡 P2 | 2 | 18 hours | Caching, OEM battery optimization |
| 🟢 P3 | 1 | 24 hours | Plugin duplication |
| **Total** | **6** | **9.7 hours avg** | — |

### Incident Prevention Measures Added
1. ✅ Null safety checks on all API response parsing
2. ✅ OTP delivery monitoring in daily checklist
3. ✅ Cache invalidation on all toggle actions
4. ✅ Battery optimization prompt for Xiaomi devices
5. ✅ Location permission flow tested on Android 11-14
6. ✅ Safety tips for cities with incidents (Delhi)
7. ✅ Delhi monitoring protocol (7-day observation)

---

## Incident Report Template

```
INCIDENT REPORT — WalkTogether

Incident #: [NUMBER]
Date: [DATE]
Severity: [P0/P1/P2/P3]

AFFECTED:
Country/City: [LOCATION]
Affected users: [COUNT]
Affected feature: [FEATURE]

ROOT CAUSE:
[What caused the incident]

FIX:
[What was done to fix it]

ADMIN ACTION:
[What admin did — ban, suspend, contact user, etc.]

USER COMMUNICATION:
[What was communicated to affected users]

PREVENTION:
[What steps were added to prevent recurrence]

STATUS: [Resolved / Monitoring / Open]
```
