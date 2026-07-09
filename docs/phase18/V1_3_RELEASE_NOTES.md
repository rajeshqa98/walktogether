# WalkTogether — v1.3 Release Notes

**Phase:** 18
**Release:** v1.3 (Full Language Support)
**Tagline:** WalkTogether in your language — free, safe, for everyone.

---

## What's New in v1.3

WalkTogether v1.3 completes full translation support for 9 languages and adds expanded safety education, host program improvements, and community dashboard enhancements — all while remaining 100% free.

**Every feature in v1.3 is free.** No premium tier. No subscriptions. No paid filters. No ads. Safety features remain mandatory and always free.

---

## Highlights

### 🌐 Full 9-Language Support

All 9 languages are now **100% translated** (264 keys each):

- English (source language, reviewed)
- Hindi (हिन्दी)
- Telugu (తెలుగు)
- Tamil (தமிழ்)
- Kannada (ಕನ್ನಡ)
- Bengali (বাংলা)
- Spanish (Español)
- Arabic (العربية) — with RTL readiness
- French (Français)

**Note:** All non-English languages are marked "Beta" pending native speaker review, especially for safety-critical strings.

### 🛡️ Expanded Safety Education (10 cards)

5 new safety cards added (total 10):

1. Meet only in public places (original)
2. Do not share your home address (original)
3. Report or block anyone unsafe (original)
4. Night walks? Prefer groups (original)
5. SOS does not auto-call 112/911 (original)
6. **Women-only safety guidance** (new)
7. **Night walk guidance** (new)
8. **Group walk safety** (new)
9. **Privacy protection** (new)
10. **SOS does not auto-call emergency services** (new, expanded)

All 10 cards are language-aware — they display in the user's preferred language.

### 🎓 Host Program v1.3

- **Host badges**: Community Host + Trusted Host labels (translated)
- **Host safety checklist**: 6-item checklist for hosts to review before each walk
- **Host quality score explanation**: Transparent scoring formula
- **Host review statuses**: 5 statuses (new, active, trusted, needs review, suspended)
- **Host appeal copy**: Translated appeal process for hosts who receive warnings/suspensions

### 📊 Community Dashboard v1.4

New admin metrics:
- **Invite conversion by language** — which languages drive the most conversions
- **Safety reports by language** — identifies moderation gaps
- **Translation adoption** — per-language user counts + completeness percentages

### 🏘️ Village/Town UX Improvements

- 16 new translation keys for granular location fields
- Localized "my village/town is not listed" support copy
- Localized confirmation modal with clear "what works" vs "limited" messaging
- Timezone detection display

### 🔗 Localized Invite Copy

All 4 invite message types (app, area, group walk, club) are now translated across all 9 languages. When a user shares an invite link, the default message appears in their preferred language.

### 🔄 Improved Language Switcher

The Settings language picker now shows:
- Native language names (हिन्दी, తెలుగు, தமிழ், etc.)
- Translation completeness percentage
- "Beta" badge for languages pending native review
- "RTL" badge for Arabic

---

## Behind the Scenes

### New translation keys
- 264 total keys per language (up from 183 in Phase 17)
- 4 new categories: `safety_v1_3`, `host_program`, `village_town`, `feedback`
- Extended existing categories with new keys

### i18n infrastructure
- `isRTL()` and `getTextDirection()` helper functions for Arabic RTL support
- RTL metadata in Arabic locale file (`"rtl": true`)
- Static language metadata in Settings (avoids client-side hydration issues)

### Admin API extensions
- `GET /api/admin/community` now returns `inviteConversionByLanguage`, `safetyReportsByLanguage`, and `translationAdoption`

---

## Privacy & Safety

v1.3 maintains WalkTogether's privacy-first design:

- ✅ **Approximate location only.** Exact coordinates shared only after accepting a walk.
- ✅ **Coarse walker counts.** Area pages never show counts ≤3.
- ✅ **No meeting point exposure** via invite links.
- ✅ **Women-only and verified-only filters** still enforced at join time.
- ✅ **SOS** still alerts emergency contacts + safety team. Does NOT auto-call 112/911/100.
- ✅ **Report/Block** still works everywhere.
- ✅ **Moderation** now covers 10 languages (English, Hindi, Hinglish, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French).

---

## What's Still Free

Everything. Including:

- ✅ All 9 language translations
- ✅ Matching with nearby walkers
- ✅ Group walks (create + join)
- ✅ Walking clubs (create + join)
- ✅ Women-only groups
- ✅ Verified-only groups
- ✅ All safety features (SOS, report/block, approximate location)
- ✅ Invite links (unlimited, with fair-use rate limits)
- ✅ Host onboarding + host badges
- ✅ Area page
- ✅ Safety education cards (all 10)
- ✅ All notifications

---

## Known Limitations

1. **Translations need native review** — All non-English languages are AI-translated and marked "Beta". Native speaker review is required before marking `reviewed: true`, especially for safety strings.

2. **Arabic RTL layout not fully applied** — RTL metadata and helper functions are implemented, but the HTML `dir` attribute and Tailwind RTL utilities are not yet applied. Arabic text renders in LTR layout. Full RTL polish is a v1.4 task.

3. **No geocoding for villages** — Village/town entries still use `(0, 0)` coordinates. Village/town users can't appear in nearby walker lists. (v1.4 fix planned)

4. **Some UI screens still use inline English** — The i18n infrastructure is ready, but extracting all inline strings to translation keys is an incremental refactor. Priority screens (Home, Area, First Walker, Host Onboarding, Location Permission, Settings) are v1.4 tasks.

5. **Host badges not yet displayed in UI** — The translation keys and data are ready, but badge display in WalkerCard, WalkerDetailSheet, GroupWalkDetail, and ClubDetail is a v1.4 UI task.

---

## Mobile App (Flutter)

The Flutter app already supports language preference (since Phase 16). The v1.3 translations will be bundled into the next Flutter app build.

---

## Upgrade Notes

v1.3 is backwards-compatible. No data migration required.

For developers:
1. Pull the latest `main` branch
2. Run `bun run lint` to verify
3. The dev server picks up new locale files automatically

For users:
- No action required. The next time you open Settings, you'll see the new language picker with all 9 languages.
- Your existing language preference is preserved.

---

## What's Next: v1.4

v1.4 will focus on:
- Full RTL layout for Arabic (HTML dir attribute + Tailwind RTL utilities)
- Applying translations to all UI screens (extracting inline strings)
- Displaying host badges in UI components
- Village geocoding (Nominatim integration)
- Host safety checklist display before walk creation
- Host appeal form in Settings
- Profile photo upload
- SEO area pages

See `docs/phase17/V1_3_BACKLOG.md` for the full v1.4 plan (now mostly complete — remaining items are the v1.4 polish tasks above).

---

## Free Product Promise (Reaffirmed)

WalkTogether is and always will be:
- **Free** — no premium, no subscriptions, no paid filters
- **Global** — anyone, anywhere can sign up
- **Safety-first** — women-only, verified-only, SOS, moderation always on, always free
- **Community-led** — hosts and walkers build their own local communities
- **Privacy-respecting** — approximate location, coarse counts, no address collection

If we ever change any of these, we'll tell you months in advance. We promise.

— The WalkTogether Team
