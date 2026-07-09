# WalkTogether — Known Limitations (Global Launch)

**Version:** 1.0.1 Global  
**Last Updated:** [DATE]

---

## Product Limitations

### 1. iOS App Not Available at Launch
- **Status:** Source code complete, requires macOS + Xcode to build
- **Impact:** iPhone users cannot install native app; can use web/PWA via Safari
- **Workaround:** Web app works on iOS Safari with PWA install support
- **Fix target:** v1.1.0 (when macOS build environment available)

### 2. English Only
- **Status:** App content is in English
- **Impact:** Non-English speakers may have difficulty
- **Workaround:** Simple English used throughout; globally understandable
- **Fix target:** v1.2.0 (add Hindi, Telugu, Spanish, Arabic based on user demographics)

### 3. No Offline Mode
- **Status:** App requires internet connection
- **Impact:** Cannot use app without connectivity
- **Workaround:** None — error state shown when offline
- **Fix target:** Not planned for v1.x

### 4. No Background Location
- **Status:** Not requested (intentional, for privacy)
- **Impact:** App doesn't track location when closed
- **Rationale:** Privacy-first design — we never collect background location
- **Fix target:** Not planned (by design)

### 5. No Scheduled One-to-One Walks
- **Status:** Walk requests are for "walk now" only
- **Impact:** Cannot schedule walks for later (group walks can be scheduled)
- **Fix target:** v1.2.0

### 6. No Walking Route Maps
- **Status:** Shows meeting point but not suggested route
- **Fix target:** v1.2.0 (requires Google Maps/Mapbox integration)

### 7. No Apple Health / Google Fit
- **Status:** Not integrated
- **Fix target:** v1.2.0

### 8. Profile Photo Upload
- **Status:** Not working in v1.0.1
- **Workaround:** Initials-based avatars work fine
- **Fix target:** v1.1.0

### 9. Socket.io on Poor Networks
- **Status:** Falls back to 10-second polling
- **Impact:** Chat messages may be delayed 3-10 seconds
- **Fix target:** v1.1.0 (reduce polling to 5s)

### 10. Push on Chinese OEMs (Xiaomi, Oppo, Vivo)
- **Status:** May not deliver if battery optimization kills FCM
- **Workaround:** Battery optimization exemption prompt added
- **Fix target:** Ongoing (Android OEM issue)

### 11. No Video/Voice Call Before Meeting
- **Status:** Not implemented
- **Impact:** Users cannot verify partner via video before meeting
- **Fix target:** v1.2.0

### 12. City Density Varies
- **Status:** New cities may have few walkers
- **Impact:** Users in newly activated cities may find limited matches
- **Workaround:** Group walks help solve density problem; expand city-by-city

---

## Privacy Limitations (By Design)

1. **Exact location never shared** — Only approximate distance labels ("within 300m")
2. **Location expires after 1 hour** — Live location snapshots auto-expire
3. **No background tracking** — Location used only in foreground
4. **Phone numbers never shared** — Used only for OTP authentication
5. **Chat messages private** — Only visible to matched users; admins see only flagged messages
6. **No social media integration** — No data shared with Facebook, Instagram, etc.
7. **No advertising** — No ad SDKs, no data sold to advertisers

---

## Global Launch Specific Limitations

1. **Invite-only initial period** — First 2 weeks per city are invite-only
2. **Admin monitoring during peak hours** — May not have 24/7 coverage across all time zones initially
3. **Country-specific legal compliance** — Privacy policy covers India DPDP + general principles; country-specific compliance (GDPR, CCPA) noted but not fully implemented
4. **Emergency numbers** — Configured for 6 launch countries; other countries show "Contact your local emergency service immediately"
5. **Timezone-aware scheduling** — Group walk times shown in user's local timezone; admin sees UTC
6. **Currency** — No payments in this phase (free app)
7. **Content moderation across languages** — Auto-moderation works for English; other languages may not be caught
8. **Support response time** — 24 hours for general, 4 hours for safety (may vary by timezone)

---

## Store Limitations

### Google Play
- New personal developer accounts require 14-day closed testing with 12+ testers before production access
- Production rollout may be staged (10% → 50% → 100% over 7 days)
- Data Safety form must be kept updated as features change

### Apple App Store
- iOS app deferred (requires macOS build)
- App Review may take 1-3 days for first submission
- TestFlight builds expire after 90 days
- Privacy nutrition labels must be kept updated
