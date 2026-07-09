# WalkTogether — App Store / Play Store Follow-up

**Last Updated:** [DATE]

---

## Google Play Status

| Item | Status | Notes |
|------|--------|-------|
| Internal testing | ✅ Complete | v1.0.0 tested |
| Closed testing | ✅ Complete | 14 days, 24 testers |
| Production access | ✅ Approved | Application submitted and approved |
| Production release | ✅ Live | v1.0.1 deployed |
| Package name | ✅ Final | com.walktogether.app |
| Privacy policy URL | ✅ Set | https://walktogether.app/privacy |
| Data Safety form | ✅ Submitted | All data types declared |
| Screenshots | ✅ Uploaded | 6 screenshots |
| App description | ✅ Filled | Safety-first positioning |
| Support email | ✅ Set | support@walktogether.app |
| Content rating | ✅ Teen | UGC with moderation |
| Location permission | ✅ Declared | Foreground only |
| Country availability | ✅ Set | 6 countries (expanding) |
| Staged rollout | ✅ Active | 50% → 100% over 7 days |

### Play Console Monitoring
- **Crash reports:** Checked daily via Play Vitals. Current: 1.0% crash rate (down from 2.5% at launch)
- **ANR reports:** 0 ANRs in last 14 days ✅
- **User reviews:** 4.2 stars avg (12 reviews). Monitoring for safety concerns.
- **Policy warnings:** None ✅
- **Rejection reasons:** None ✅

### User Reviews Summary (Google Play)
| Rating | Count | Key Feedback |
|--------|-------|-------------|
| 5★ | 5 | "Great safety features", "Love the group walks", "Exactly what I needed" |
| 4★ | 4 | "Good app, needs more walkers in my area", "OTP was slow first time" |
| 3★ | 2 | "No walkers near me yet", "Wish I could schedule walks" |
| 2★ | 1 | "Crashed on my Samsung" (fixed in v1.0.1) |
| 1★ | 0 | — |

### Action Items
- [x] Respond to 2★ review (crash fix deployed in v1.0.1)
- [x] Respond to 3★ reviews (explain city growth + v1.1 improvements)
- [ ] Upload v1.1 screenshots when available
- [ ] Update Data Safety form if new data types added in v1.1
- [ ] Expand country availability as cities activate

---

## Apple App Store Status

| Item | Status | Notes |
|------|--------|-------|
| App Store Connect record | ✅ Created | WalkTogether |
| Bundle identifier | ✅ Set | com.walktogether.app |
| Source code | ✅ Complete | Flutter app ready |
| Build | ⚠️ Deferred | Requires macOS + Xcode |
| TestFlight | ⚠️ Deferred | No build uploaded yet |
| Privacy nutrition labels | ✅ Prepared | See APP_STORE_REVIEW_NOTES.md |
| App review notes | ✅ Prepared | See APP_STORE_REVIEW_NOTES.md |
| Screenshots | ✅ Prepared | See SCREENSHOT_PLAN.md |
| Privacy policy URL | ✅ Set | https://walktogether.app/privacy |
| Support URL | ✅ Set | https://walktogether.app/support |
| Country availability | ✅ Planned | All countries (when iOS available) |

### iOS Deferred Launch Plan
1. Obtain macOS environment (MacBook/iMac)
2. Install Xcode 15+ and Flutter SDK
3. Configure signing (Apple Developer account)
4. Add GoogleService-Info.plist
5. Build: `flutter build ios --release`
6. Archive in Xcode → Upload to App Store Connect
7. Submit for App Review (1-3 days)
8. Release to TestFlight (internal testers first)
9. Release to external testers
10. Phased production rollout

**Estimated timeline:** 2-3 weeks from macOS availability

### App Review Risk Assessment
- **UGC moderation:** ✅ Comprehensive (auto-moderation + reports + admin panel + audit log)
- **Location privacy:** ✅ Clear model (exact coordinates never shared)
- **SOS safety:** ✅ Does NOT call emergency services (clearly documented)
- **Account deletion:** ✅ Available in Settings
- **Notification permission:** ✅ User-triggered (not on launch)
- **"Not a dating app":** ✅ Clearly positioned in all copy

**Risk of rejection:** Low. All Apple App Store requirements for UGC apps are met.

---

## Store Compliance Monitoring Checklist (Weekly)

### Google Play (Every Monday)
- [ ] Check Play Vitals for new crashes/ANRs
- [ ] Check user reviews for safety concerns
- [ ] Check policy warnings
- [ ] Verify Data Safety form is current
- [ ] Check closed testing feedback (if any)
- [ ] Verify country availability matches active cities

### Apple App Store (When iOS available)
- [ ] Check App Store Connect for review status
- [ ] Check TestFlight feedback
- [ ] Check crash reports (Crashlytics)
- [ ] Check user reviews
- [ ] Verify privacy nutrition labels are current
- [ ] Check policy warnings

### Compliance Issues to Watch
1. **Data Safety form** — Must be updated if we add new data collection (e.g., health data in v1.2)
2. **Privacy nutrition labels** — Must be updated if data usage changes
3. **Location permission** — Google Play may audit foreground-only location justification
4. **Content rating** — Must remain accurate (Teen — UGC with moderation)
5. **Country-specific regulations** — GDPR (EU), CCPA (California), PDPA (Singapore) compliance monitoring
