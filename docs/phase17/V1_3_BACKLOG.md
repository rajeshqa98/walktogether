# WalkTogether — v1.3 Backlog

**Phase:** 17
**Status:** Defined; not yet scheduled
**Release target:** v1.3 (after v1.2 monitoring stabilizes)

---

## 1. Purpose

This backlog defines the next release (v1.3) based on v1.2 monitoring data and Phase 17 learnings. Every item is **free** — no monetization, no premium tier, no paid features.

---

## 2. v1.3 Themes

1. **Full i18n implementation** — translate the entire UI into Hindi, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French.
2. **Better geocoding for villages** — integrate Nominatim/OpenStreetMap so village/town users get real coordinates and appear in nearby walker lists.
3. **Local community pages with SEO** — statically-rendered area pages that search engines can index.
4. **WhatsApp invite tracking** — track when invites are shared via WhatsApp vs other channels.
5. **Host profile badges** — visible "Community Host" badge + "Trusted Host" badge on profiles.
6. **Local area leaderboards** — coarse leaderboards that don't expose exact locations.
7. **Stronger safety onboarding** — interactive safety checklist for new users.
8. **Voice-note safety warning** — if a user receives a voice note, show a safety reminder.
9. **Community ambassador program** — recognize top hosts with a formal program.

---

## 3. Detailed Items

### 3.1 Full i18n implementation

**Priority:** P0
**Effort:** 80 hours
**Dependencies:** Phase 17 i18n infrastructure (complete)

**Scope:**
- Extract all inline UI strings into translation keys
- Complete Hindi translation (currently 100% but needs native review)
- Complete Telugu, Tamil, Kannada, Bengali translations (hire native translators)
- Complete Spanish, Arabic, French translations
- Add RTL layout support for Arabic
- Auto-detect language from phone locale on first launch
- Add "Reset safety tips" button in Settings (re-show dismissed safety cards)

**Acceptance:**
- All 9 locales marked `completed: true` and `reviewed: true`
- Native speaker sign-off for each locale
- RTL layout works for Arabic

---

### 3.2 Better geocoding for villages

**Priority:** P0
**Effort:** 16 hours
**Dependencies:** None

**Scope:**
- Integrate Nominatim/OpenStreetMap geocoding API (free, rate-limited)
- When a user enters a custom village/town, geocode it to get approximate coordinates
- Store the coordinates on the user's `LivePresence` record
- Village/town users now appear in nearby walker lists with a coarse distance label ("within 5km")
- Fallback: if geocoding fails, keep the current `(0, 0)` behavior with the approximate-location message

**Acceptance:**
- Village/town users appear in nearby walker lists
- Distance labels are coarse (rounded to nearest 500m, capped at "within 5km+")
- Geocoding failures gracefully fall back to approximate location

---

### 3.3 Local community pages with SEO

**Priority:** P1
**Effort:** 24 hours
**Dependencies:** None

**Scope:**
- Generate static pages at `/area/<area-slug>` (e.g. `/area/in-telangana-hyderabad-madhapur`)
- Each page shows: area name, coarse walker count, group walks, clubs, CTAs
- SEO metadata: title, description, OpenGraph tags
- Sitemap.xml auto-generated with all area pages
- When a user searches Google for "walking partners in <village>", they find the WalkTogether area page

**Acceptance:**
- Google indexes area pages
- Area pages load fast (server-rendered, no client-side data fetch on first paint)
- Area pages don't expose exact user locations

---

### 3.4 WhatsApp invite tracking

**Priority:** P1
**Effort:** 8 hours
**Dependencies:** None

**Scope:**
- Use UTM parameters on invite links: `?invite=wt-XXX&utm_source=whatsapp`
- Track `invite_shared` events with `channel: "whatsapp"` vs `channel: "native"`
- Dashboard shows invite conversion by channel
- A/B test different WhatsApp share copy

**Acceptance:**
- Dashboard shows conversion rate by channel
- WhatsApp invites have measurable conversion

---

### 3.5 Host profile badges

**Priority:** P1
**Effort:** 8 hours
**Dependencies:** Phase 17 host quality monitoring (complete)

**Scope:**
- Show "Community Host" badge on profiles of users with `isCommunityHost = true`
- Show "Trusted Host" badge (gold star) on profiles of hosts with `hostStatus === "trusted_host"`
- Badges appear on: WalkerCard, WalkerDetailSheet, GroupWalkDetail (host section), ClubDetail (creator section)
- Badges are visual only — no functional privilege changes

**Acceptance:**
- Hosts see their badge on their own profile
- Other users see host badges on walker cards
- Trusted host badge only appears for hosts meeting the trusted criteria

---

### 3.6 Local area leaderboards (without unsafe location exposure)

**Priority:** P2
**Effort:** 16 hours
**Dependencies:** None

**Scope:**
- Add a "Top clubs in your area" section to the Area page
- Rank clubs by: member count, recent activity (walks in last 30 days), repeat participants
- Show top 3 clubs only (coarse — doesn't expose individual walkers)
- Never show individual walker rankings (would leak activity patterns)
- Add a "Most active walks" section showing upcoming walks with the most participants

**Acceptance:**
- Leaderboards show only aggregate/club-level data
- No individual walker is singled out
- Leaderboards refresh daily (not real-time)

---

### 3.7 Stronger safety onboarding

**Priority:** P1
**Effort:** 12 hours
**Dependencies:** None

**Scope:**
- Add a 3-step safety checklist to ProfileSetup:
  1. "Meet only in public places" (checkbox)
  2. "Do not share your home address" (checkbox)
  3. "Use report/block if someone makes you uncomfortable" (checkbox)
- User must check all 3 to complete profile setup
- Add a "Safety quiz" (3 questions) before first group walk join — optional but recommended
- Track `safety_checklist_completed` and `safety_quiz_completed` events

**Acceptance:**
- New users complete the safety checklist before reaching Home
- Safety quiz is optional but shown
- Events are tracked

---

### 3.8 Voice-note safety warning

**Priority:** P2
**Effort:** 8 hours
**Dependencies:** Voice notes feature (not yet built — would need to add in v1.3 first)

**Scope:**
- If voice notes are added to chat (separate v1.3 feature), show a safety reminder:
  "Voice notes can't be auto-moderated. If a voice note makes you uncomfortable, report it."
- Add a "report voice note" option in the message context menu
- Voice note reports are flagged for priority admin review

**Note:** This item is contingent on voice notes being added. If voice notes are not added in v1.3, this item is deferred.

---

### 3.9 Community ambassador program

**Priority:** P2
**Effort:** 20 hours
**Dependencies:** Phase 17 host quality monitoring (complete)

**Scope:**
- Identify top hosts (trusted_host status, high safety score, high repeat participants)
- Invite them to the ambassador program via in-app notification
- Ambassadors get:
  - "Community Ambassador" badge on profile
  - Early access to new features
  - Monthly community call with product team
  - Ability to nominate other hosts for the program
- Track `ambassador_invited`, `ambassador_accepted` events
- Ambassador list is admin-managed at `/admin/ambassadors` (new page)

**Acceptance:**
- At least 10 ambassadors across 5+ areas by end of v1.3
- Ambassadors host at least 1 walk per month
- Ambassador-hosted walks have higher participation than average

---

## 4. Items Explicitly Excluded from v1.3

- ❌ Payments, subscriptions, premium tiers
- ❌ Paid filters or paid safety features
- ❌ Ads or sponsored content
- ❌ In-app purchases
- ❌ Paid host certification
- ❌ Selling user data
- ❌ Paid "boost" for group walks or clubs

---

## 5. Priority Matrix

| Item | Priority | Effort | Impact |
|------|----------|--------|--------|
| Full i18n | P0 | 80h | High (unlocks non-English users) |
| Village geocoding | P0 | 16h | High (unlocks nearby walker matching for villages) |
| SEO area pages | P1 | 24h | Medium (organic growth) |
| WhatsApp tracking | P1 | 8h | Medium (measurable growth channel) |
| Host badges | P1 | 8h | Medium (host retention) |
| Safety onboarding | P1 | 12h | High (safety) |
| Area leaderboards | P2 | 16h | Low (engagement) |
| Voice note warning | P2 | 8h | Low (safety, contingent) |
| Ambassador program | P2 | 20h | Medium (host retention + growth) |

**Total effort:** ~192 hours (P0 + P1 = 148h, P2 = 44h)

---

## 6. Acceptance Criteria for v1.3

- [ ] All P0 items complete (i18n, village geocoding)
- [ ] At least 4 P1 items complete (SEO pages, WhatsApp tracking, host badges, safety onboarding)
- [ ] No monetization features added
- [ ] All features remain free
- [ ] Compliance scanner still passes (no paid language)
- [ ] Phase 17 monitoring continues to track all v1.3 features
