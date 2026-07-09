# WalkTogether — v1.2 Post-Release Notes

**Phase:** 17
**Status:** v1.2 stable; Phase 17 monitoring + improvements layered on top
**Audience:** Community ops, safety ops, product, engineering

---

## 1. What Shipped in v1.2 (Phase 16)

v1.2 (Phase 16) shipped 13 community growth feature areas:

1. Community invite links (app, area, group walk, club)
2. Local area community page
3. Better free-text location support (village, town, district, state, country, timezone, landmark)
4. Local walking clubs discovery (filter by type)
5. Host onboarding (8-step flow)
6. First walker experience (special empty-state screen)
7. Community growth dashboard (admin)
8. Global language readiness (9-language preference picker)
9. Safety education cards (5 cards across app)
10. Better no-walkers flow (improved empty state + analytics)
11. Community growth notifications (club_joined, group_walk_joined, etc.)
12. Moderation improvements (English, Hindi, Hinglish, Telugu, Tamil, Spanish, Arabic, French)
13. 9 documentation deliverables

All features are free. No premium tier. No monetization.

---

## 2. What Phase 17 Adds (Layered on v1.2)

Phase 17 does NOT ship new user-facing features. Instead, it wraps v1.2 in:

### 2.1 Monitoring infrastructure
- 30+ analytics events tracked across all v1.2 features
- Admin community dashboard v1.3 with host availability, invite conversion, language distribution, village/town growth, 7-day trends, low-density alerts, community health scores

### 2.2 Host quality monitoring
- `/api/admin/hosts` endpoint returns per-host metrics
- 5 host statuses: new_host, active_host, trusted_host, needs_review, suspended_host
- Safety score (0-100) per host
- Repeat participants, reports against, cancelled walks tracked

### 2.3 Multilingual moderation expansion
- Kannada and Bengali banned term lists added (Phase 17)
- Safety pattern detection: requests for home address / private meeting (flagged, never blocked)
- `detectSafetyPattern()` helper for client-side warnings
- `getModerationLanguageCoverage()` for admin dashboard

### 2.4 i18n infrastructure
- `src/locales/` directory with 9 locale files
- `src/lib/i18n.ts` with `translate()`, `getAllLocalesMeta()`, `countTranslationKeys()`, `countTranslatedKeys()`
- 183 translation keys across 14 categories
- Hindi locale fully translated (needs native review)
- 7 other locales stubbed (fall back to English)
- Safety education cards are now language-aware

### 2.5 Village/town adoption improvements
- Location confirmation modal before saving approximate location
- Improved WhatsApp share copy mentioning villages, towns, and cities
- Analytics tracking for `village_town_location_set`

### 2.6 Free product compliance
- Codebase scanner at `/api/admin/compliance`
- Scans src/, docs/, prisma/ for forbidden terms (premium, upgrade, subscription, etc.)
- Whitelist for known-OK technical contexts (push subscription, chat unlocks)
- ✅ Result: Compliant — no high-severity matches in user-facing copy

### 2.7 Documentation (9 deliverables)
- `V1_2_MONITORING_REPORT.md`
- `LOCAL_LANGUAGE_EXPANSION_PLAN.md`
- `VILLAGE_TOWN_ADOPTION_REVIEW.md`
- `COMMUNITY_HOST_QUALITY_REPORT.md`
- `MULTILINGUAL_MODERATION_PLAN.md`
- `FREE_PRODUCT_COMPLIANCE_REPORT.md`
- `ADMIN_COMMUNITY_DASHBOARD_V1_3_SPEC.md`
- `V1_3_BACKLOG.md`
- `V1_2_POST_RELEASE_NOTES.md` (this file)

---

## 3. Metrics to Watch in the First 30 Days

After Phase 17 deploys, monitor these metrics on the admin community dashboard:

### 3.1 Growth metrics
- **Invite conversion rate** — target ≥ 15% (joins / visits)
- **7-day invite_link_created count** — should grow week-over-week
- **7-day no_walkers_nearby_seen count** — should grow more slowly than signups (indicating density is increasing)
- **Low-density alerts** — should decrease over time as areas grow

### 3.2 Host metrics
- **New hosts (30d)** — target ≥ 10 new hosts per week globally
- **Active hosts (30d)** — target ≥ 50% of total hosts
- **Hosts needing review** — should stay < 5% of total hosts

### 3.3 Language metrics
- **Hindi language adoption** — target ≥ 10% of Indian users select Hindi within 30 days
- **Other language adoption** — target ≥ 5% combined for Telugu/Tamil/Kannada/Bengali

### 3.4 Village/town metrics
- **Village users** — target ≥ 15% of new signups in India are village/town users
- **Village/town first-walker flow completion** — target ≥ 20% of village/town users start a club or create a walk

### 3.5 Safety metrics
- **Safety card dismissal rate** — should stay < 30% (most users should read, not dismiss)
- **Reports against hosts** — should stay < 2% of hosts per month
- **SOS triggers** — track (no target; baseline data)

---

## 4. Known Issues & Limitations

### 4.1 v1.2 known issues (carried forward)

1. **No geocoding for villages** — village/town entries use `(0, 0)` coordinates. Village/town users can't appear in nearby walker lists. (v1.3 fix planned)

2. **No full UI translations** — only Hindi is translated; other 8 languages fall back to English. (v1.3 fix planned)

3. **No profile photo upload** — still using initials avatars. (v1.3 fix planned)

4. **No RTL layout for Arabic** — Arabic users see LTR layout. (v1.3 fix planned)

5. **No offline mode** — network required. (v1.3+ fix planned)

### 4.2 Phase 17 known issues

1. **Hindi translations need native review** — Hindi locale is 100% complete but marked `reviewed: false`. Should not be promoted to `reviewed: true` until a native Hindi speaker reviews.

2. **Host quality API is not cached** — each call to `/api/admin/hosts` computes metrics live. For large host counts (>1000), this may be slow. (v1.3 fix: add caching)

3. **Compliance scanner is manual** — there's no CI check yet. An admin must run the scanner manually. (v1.3 fix: add CI check)

4. **Safety card `viewed` event is not yet fired** — the `safety_card_dismissed` event works, but `safety_card_viewed` is defined but not wired up. (v1.3 fix: fire on card render)

5. **Auto-mute for repeated harassment is not enforced** — `shouldAutoMuteForHarassment()` is implemented but not called by the message routes. (v1.3 fix: enforce in message routes)

---

## 5. Operational Runbooks

### 5.1 If a low-density alert appears

1. Check the area on the admin community dashboard.
2. If the area has 0 hosts: consider reaching out to active walkers in nearby areas to invite them to host.
3. If the area has a host but no walks: message the host (v1.3 feature) or add them to the ambassador program.
4. If the area has safety concerns: prioritize safety review over growth.

### 5.2 If a host gets 2+ reports (needs_review status)

1. Review the reports at `/admin/reports`.
2. Review the host's recent messages at `/admin/messages`.
3. If the reports are valid: warn or suspend the host.
4. If the reports are invalid: dismiss them and add an admin note.
5. The host's status will automatically update on next dashboard refresh.

### 5.3 If the compliance scanner finds high-severity matches

1. Run `curl http://localhost:3000/api/admin/compliance` (as admin).
2. Review the matches list.
3. For each high-severity match:
   - If it's user-facing copy: fix immediately (P1 bug).
   - If it's a technical context (push subscription, etc.): add to the whitelist in `src/app/api/admin/compliance/route.ts`.
4. Re-run the scanner to confirm `isCompliant === true`.

---

## 6. What's Next: v1.3

v1.3 will focus on:
- Full i18n (all 9 languages translated and reviewed)
- Village geocoding (Nominatim integration)
- SEO area pages
- Host profile badges
- Stronger safety onboarding
- Community ambassador program

See `V1_3_BACKLOG.md` for the full v1.3 plan.

---

## 7. Acknowledgments

Phase 17 was built to make v1.2 measurable and safer at scale. Thanks to:

- The Phase 16 team for shipping the community growth features that Phase 17 wraps.
- The moderation library which now covers 10 languages.
- The i18n infrastructure which makes the app translatable.
- The compliance scanner which keeps the product honest about being free.

And to every walker who has signed up since the global free launch — including those in villages and towns we'd never heard of. Phase 17 is for you.

---

## 8. Free Product Promise (Reaffirmed)

WalkTogether is and always will be:
- **Free** — no premium, no subscriptions, no paid filters
- **Global** — anyone, anywhere can sign up
- **Safety-first** — women-only, verified-only, SOS, moderation always on, always free
- **Community-led** — hosts and walkers build their own local communities
- **Privacy-respecting** — approximate location, coarse counts, no address collection

If we ever change any of these, we'll tell you months in advance. We promise.

— The WalkTogether Team
