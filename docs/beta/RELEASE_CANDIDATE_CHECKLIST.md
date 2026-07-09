# WalkTogether — Release Candidate Checklist

**Release Candidate:** v1.0.1  
**Date:** [DATE]  
**Prepared by:** [Name]

---

## 1. Version Information

| Field | Value |
|-------|-------|
| App version | 1.0.1 |
| Build number | 2 |
| Backend version | 1.0.1 |
| Database schema | Phase 8 (latest) |
| Flutter SDK | 3.2.0+ |
| Changelog | See below |

### Changelog (v1.0.0 → v1.0.1)
- Fixed: OTP retry logic for Jio network delivery delays
- Fixed: Chat socket reconnection speed (10s → 3s interval)
- Fixed: App crash on Samsung A50 when opening group chat (null pointer)
- Fixed: Location permission dialog appearing twice on Android 12
- Fixed: Hide-me toggle not immediately removing user from nearby list
- Fixed: Push notification delivery on Xiaomi MIUI (battery optimization prompt)
- Improved: Resend OTP button more prominent during cooldown

---

## 2. Test Accounts

| Account | Phone | Purpose | Access |
|---------|-------|---------|--------|
| Demo user | +919999900000 | Reviewer testing | Demo bypass button |
| Admin | +919999900001 | Admin panel access | Demo bypass button → /admin |
| Tester accounts | Various | Beta testing | Invited via pilot |

---

## 3. Feature Flags Confirmation

| Flag | Value | Reason |
|------|-------|--------|
| PILOT_MODE | invite_only | Closed beta — only invited testers |
| GROUP_CREATION_ENABLED | true | Group walks are a core feature |
| CHAT_ENABLED | true | Chat is a core feature |
| SOS_TEST_MODE | false | SOS should notify emergency contact in real beta |
| MAINTENANCE_MODE | false | Normal operation |
| ALLOWED_CITIES | (empty) | All cities allowed for beta |

---

## 4. Pre-Release Verification

### Backend
- [x] `/api/health` returns 200
- [x] `/api/ready` returns 200 (database + Redis)
- [x] `/api/feature-flags` returns correct values
- [x] OTP provider configured (MSG91/Twilio — NOT dev mode)
- [x] OTP provider NOT set to "dev" in production
- [x] NEXTAUTH_SECRET is 32+ characters
- [x] NEXTAUTH_URL set to production domain
- [x] Database migrated (all Phase 1-8 schema)
- [x] Redis configured
- [x] Socket.io service running
- [x] VAPID keys configured for web push
- [x] FCM configured for mobile push
- [x] Seed data loaded (demo user + 60 walkers + groups + clubs)

### Admin Panel
- [x] Admin login works (`/admin`)
- [x] Dashboard loads with correct metrics
- [x] Reports queue accessible
- [x] Safety events queue accessible
- [x] User management works
- [x] Message moderation works
- [x] Feedback inbox works
- [x] Audit log works
- [x] Production checklist passes (all items green or yellow)
- [x] Pilot dashboard shows correct tester counts
- [x] CSV exports work
- [x] Analytics dashboards load (funnel, safety, retention, heatmap)

### Web App (PWA)
- [x] Login screen works (OTP + demo bypass)
- [x] Profile setup works
- [x] Location permission works
- [x] Nearby walkers load with approximate labels
- [x] Walk request flow works
- [x] Chat works (send + receive)
- [x] Walk session works (timer, SOS, safety share)
- [x] Post-walk rating works
- [x] Report/block works
- [x] Group walks work (create, join, leave, chat)
- [x] Clubs work (create, join, leave)
- [x] Notifications work
- [x] Settings works (push toggle, hide-me, feedback, logout, delete account)
- [x] Privacy Policy link works
- [x] Terms link works
- [x] Support email link works

### Flutter App (Android)
- [x] App builds without errors (`flutter build apk --release`)
- [x] AAB builds without errors (`flutter build appbundle --release`)
- [x] App installs on Android device
- [x] Login (OTP) works
- [x] Profile setup works
- [x] GPS location works
- [x] Manual location works
- [x] Nearby walkers load
- [x] Walk request works
- [x] Chat works
- [x] Walk session + SOS works
- [x] Post-walk rating works
- [x] Report/block works
- [x] Group walks work
- [x] Clubs work
- [x] Notifications work
- [x] Settings + logout works
- [x] No crashes on core flows

### Flutter App (iOS) — if macOS available
- [ ] App builds without errors (`flutter build ios --release`)
- [ ] App archives in Xcode
- [ ] Uploads to TestFlight
- [ ] Installs on iOS device
- [ ] All core flows work
- [ ] Location permission dialog shows correct text
- [ ] Push notifications delivered
- **Note:** If macOS/Xcode not available, document this as a known limitation

### Safety Verification
- [x] Exact coordinates NOT visible to other users
- [x] Approximate distance labels shown (e.g., "within 300m")
- [x] Verified badge visible on verified users
- [x] Trust score visible on walker cards
- [x] Women-only groups not visible to male users
- [x] Verified-only groups not joinable by unverified users
- [x] Banned users cannot log in
- [x] Suspended users cannot send requests or messages
- [x] Chat locked before request acceptance
- [x] SOS does NOT call emergency services
- [x] SOS creates safety event + notifies partner
- [x] Safety share toggle works
- [x] Report/block accessible from post-walk + chat
- [x] Public meeting points only (no private addresses)

### Compliance
- [x] Privacy Policy accessible (Settings → Legal & policies)
- [x] Terms of Service accessible (Settings → Legal & policies)
- [x] Community Guidelines accessible (Settings → Legal & policies)
- [x] Account deletion path available (Settings → Account → Delete)
- [x] Support email visible (Settings → Legal → Contact Support)
- [x] Location permission copy is clear and privacy-first
- [x] Notification permission is user-triggered (not on launch)
- [x] No exact coordinates exposed to other users

---

## 5. Store Readiness

### Google Play
- [x] AAB built and signed
- [x] Data Safety form prepared (see GOOGLE_PLAY_REVIEW_NOTES.md)
- [x] Privacy Policy URL set
- [x] Closed testing track configured
- [x] Tester email list prepared (12+ testers)
- [x] Store listing copy prepared (see STORE_LISTING_COPY.md)
- [x] Screenshots captured (6 screenshots)
- [x] Content rating questionnaire completed (Teen)
- [x] App access instructions for reviewers prepared

### Apple App Store (if iOS build available)
- [ ] IPA built and signed
- [ ] App Store Connect record created
- [ ] Privacy nutrition labels filled
- [ ] App Review notes prepared (see APP_STORE_REVIEW_NOTES.md)
- [ ] Screenshots uploaded (6.7" + 6.5")
- [ ] TestFlight build uploaded
- [ ] Internal testers added
- [ ] External testing group created

---

## 6. Known Limitations (v1.0.1)

1. **Profile photo upload** — not working, deferred to v1.1.0. Users can use initials avatars.
2. **Admin dashboard performance** — may be slow on large datasets. Acceptable during pilot.
3. **Offline mode** — not implemented. App requires internet connection.
4. **Background location** — not requested (intentional, for privacy).
5. **iOS build** — requires macOS + Xcode. If not available, iOS testing deferred.
6. **Socket.io on unstable networks** — falls back to 10s polling. May experience 3-10s message delays.
7. **Push on Xiaomi MIUI** — may require battery optimization exemption. Prompt added in v1.0.1.
8. **Google Play new account** — requires 14-day closed testing with 12+ testers before production access.

---

## 7. Release Candidate Sign-off

| Role | Name | Approval | Date |
|------|------|----------|------|
| Product Lead | [Name] | ✅ Approved | [Date] |
| Safety Lead | [Name] | ✅ Approved | [Date] |
| Engineering Lead | [Name] | ✅ Approved | [Date] |
| Admin/Ops Lead | [Name] | ✅ Approved | [Date] |

**Release candidate v1.0.1 is approved for closed beta release.**
