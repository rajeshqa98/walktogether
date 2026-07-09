# WalkTogether — Known Limitations

**Version:** 1.0.1  
**Last Updated:** [DATE]

---

## Current Limitations

### 1. Profile Photo Upload
- **Status:** Not working in v1.0.1
- **Impact:** Low — users see initials-based avatars instead of photos
- **Workaround:** None needed — avatars work fine
- **Fix target:** v1.1.0

### 2. Offline Mode
- **Status:** Not implemented
- **Impact:** App requires internet connection for all features
- **Workaround:** None — app shows error state when offline
- **Fix target:** Not planned for v1.x

### 3. Background Location
- **Status:** Not requested (intentional)
- **Impact:** App doesn't track location when closed
- **Rationale:** Privacy-first design — we never collect background location
- **Fix target:** Not planned (by design)

### 4. iOS Build
- **Status:** Source code complete, requires macOS + Xcode to build
- **Impact:** iOS app not yet on TestFlight
- **Workaround:** Web/PWA works on iOS Safari; Android app works on Android devices
- **Fix target:** When macOS build environment is available

### 5. Socket.io on Unstable Networks
- **Status:** Falls back to 10-second polling
- **Impact:** Chat messages may be delayed 3-10 seconds on poor networks
- **Workaround:** Messages eventually arrive via polling
- **Fix target:** v1.1.0 — reduce polling interval to 5s

### 6. Push Notifications on Xiaomi/MIUI
- **Status:** May not deliver if battery optimization is enabled
- **Impact:** Some Android users may not receive push notifications
- **Workaround:** v1.0.1 added battery optimization exemption prompt
- **Fix target:** Ongoing — OEM-specific notification delivery is a known Android issue

### 7. Admin Dashboard Performance
- **Status:** May be slow (>3s) with large datasets (1000+ users)
- **Impact:** Admin-only, low priority
- **Workaround:** Use filters to narrow results
- **Fix target:** v1.1.0 — add pagination + caching

### 8. Google Play New Account Requirement
- **Status:** New personal developer accounts require 14-day closed testing with 12+ testers
- **Impact:** Cannot immediately push to production
- **Workaround:** 14-day beta already completed; production access application ready
- **Fix target:** Apply for production access after beta documentation submitted

### 9. User Density
- **Status:** Low density outside Hyderabad
- **Impact:** Users in other cities may find few or no nearby walkers
- **Workaround:** Launch in Hyderabad only; expand city by city
- **Fix target:** City-by-city expansion as user base grows

### 10. No Scheduled Walk Requests
- **Status:** Walk requests are for "walk now" only
- **Impact:** Users cannot schedule walks for later
- **Workaround:** Group walks can be scheduled; one-to-one is instant only
- **Fix target:** v1.2.0

### 11. No Walking Route Maps
- **Status:** App shows meeting point but not walking route
- **Impact:** Users don't see a suggested route
- **Workaround:** Meeting point is shown; users choose their own route
- **Fix target:** v1.2.0

### 12. No Apple Health / Google Fit Integration
- **Status:** Not implemented
- **Impact:** Walks don't sync to health apps
- **Workaround:** Walk duration is tracked in-app
- **Fix target:** v1.2.0

---

## Privacy Limitations (by design)

These are intentional privacy protections, not bugs:

1. **Exact location never shared** — Only approximate distance labels ("within 300m") are shown to other users
2. **Location expires after 1 hour** — Live location snapshots auto-expire
3. **No background tracking** — Location used only in foreground
4. **Phone numbers never shared** — Used only for OTP authentication
5. **Chat messages private** — Only visible to matched users; admins see only flagged messages
6. **No social media integration** — No data shared with Facebook, Instagram, etc.
7. **No advertising** — No ad SDKs, no data sold to advertisers
