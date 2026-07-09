# WalkTogether — Updated Known Limitations (v1.1.0)

**Version:** 1.1.0 | **Date:** [DATE]

## Product Limitations

1. **iOS app** — Source code complete, requires macOS + Xcode. Web/PWA works on iOS Safari. Target: v1.2.0
2. **English only** — App content in English. Multi-language planned for v1.2.0 (Hindi, Telugu, Spanish, Arabic)
3. **No offline mode** — App requires internet connection
4. **No background location** — Not requested (intentional, for privacy)
5. **No scheduled one-to-one walks** — Group walks can be scheduled; one-to-one is instant. Target: v1.2.0
6. **No walking route maps** — Meeting point shown, not route. Target: v1.2.0
7. **No Apple Health / Google Fit** — Target: v1.2.0
8. **Profile photo upload** — Not working. Initials avatars used. Target: v1.2.0
9. **Socket.io on poor networks** — Falls back to 5s polling (improved from 10s in v1.1)
10. **Push on Chinese OEMs** — May require battery optimization exemption (Xiaomi, Oppo, Vivo)
11. **No video/voice call** — Target: v1.2.0
12. **City density varies** — New cities may have limited matches. Group walks help bridge.
13. **Hindi moderation** — 10 Hindi banned words added in v1.1. More languages planned for v1.2.
14. **Admin dashboard** — May be slow with 1000+ users. Target: v1.2.0 (pagination + caching)
15. **Timezone coverage** — Admin monitoring covers IST + partial US/EU. Recruiting US-based admin.

## Privacy Limitations (By Design)

1. Exact location never shared — only approximate labels ("within 300m")
2. Location expires after 1 hour
3. No background tracking
4. Phone numbers never shared — used only for OTP
5. Chat messages private — admins see only flagged messages
6. No social media integration
7. No advertising

## Global Launch Specific

1. **Invite-only** for most cities (Hyderabad + Bangalore open signup in v1.1)
2. **Delhi** on 7-day safety observation (report rate 37.5%)
3. **Sydney** on 7-day density observation (3 active users)
4. **Country-specific compliance** — Privacy policy covers India DPDP + general principles. GDPR/CCPA/PIPEDA noted but not fully implemented
5. **Emergency numbers** — Configured for 7 active countries; others show "Contact your local emergency service"
6. **Content moderation** — English + Hindi. Other languages may not be caught
7. **Support response** — 24h general, 4h safety (varies by timezone)

## Store Limitations

### Google Play
- v1.1.0 deployed as production release
- Staged rollout: 50% → 100%
- Data Safety form current

### Apple App Store
- iOS app deferred (requires macOS)
- Source code ready for build when macOS available
- App Review notes prepared

## What's Fixed in v1.1 (from v1.0.1)
- ✅ Onboarding tooltip for first-time users
- ✅ Trust score explanation modal
- ✅ Location privacy banner
- ✅ Time-of-day safety tips
- ✅ Better no-walkers empty state
- ✅ Host guidance on create group walk
- ✅ Waitlist position + demand messaging
- ✅ Notification preference toggles
- ✅ Clearer banned/suspended messages
- ✅ 50+ global cities in manual location picker
- ✅ Hindi banned-word moderation
- ✅ Reduced crash rate (<0.5%)
- ✅ Faster socket polling (5s)
