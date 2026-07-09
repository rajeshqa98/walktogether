# WalkTogether — Language QA Checklist

**Phase:** 18
**Purpose:** Pre-release QA checklist for verifying all 9 languages work correctly

---

## 1. Pre-QA Setup

- [ ] Dev server running on port 3000
- [ ] Database seeded with at least 1 demo user
- [ ] Browser console open for errors
- [ ] All 9 locale files present in `src/locales/`

---

## 2. Per-Language Verification

For each of the 9 languages, verify:

### 2.1 English (en)
- [ ] Settings → Language preference shows "English" selected
- [ ] Home screen renders in English
- [ ] Safety education card displays in English
- [ ] No-walkers empty state (if applicable) shows English copy
- [ ] No console errors

### 2.2 Hindi (hi)
- [ ] Settings → select "हिन्दी (Hindi)"
- [ ] Safety education card displays in Hindi (e.g. "केवल सार्वजनिक स्थानों पर मिलें")
- [ ] Share sheet invite copy displays in Hindi
- [ ] No console errors
- [ ] No layout breakage from Devanagari script

### 2.3 Telugu (te)
- [ ] Settings → select "తెలుగు (Telugu)"
- [ ] Safety education card displays in Telugu
- [ ] Share sheet invite copy displays in Telugu
- [ ] No console errors
- [ ] No layout breakage from Telugu script

### 2.4 Tamil (ta)
- [ ] Settings → select "தமிழ் (Tamil)"
- [ ] Safety education card displays in Tamil
- [ ] Share sheet invite copy displays in Tamil
- [ ] No console errors
- [ ] No layout breakage from Tamil script

### 2.5 Kannada (kn)
- [ ] Settings → select "ಕನ್ನಡ (Kannada)"
- [ ] Safety education card displays in Kannada
- [ ] Share sheet invite copy displays in Kannada
- [ ] No console errors
- [ ] No layout breakage from Kannada script

### 2.6 Bengali (bn)
- [ ] Settings → select "বাংলা (Bengali)"
- [ ] Safety education card displays in Bengali
- [ ] Share sheet invite copy displays in Bengali
- [ ] No console errors
- [ ] No layout breakage from Bengali script

### 2.7 Spanish (es)
- [ ] Settings → select "Español (Spanish)"
- [ ] Safety education card displays in Spanish
- [ ] Share sheet invite copy displays in Spanish
- [ ] No console errors

### 2.8 Arabic (ar) — RTL
- [ ] Settings → select "العربية (Arabic)"
- [ ] Safety education card displays in Arabic
- [ ] Share sheet invite copy displays in Arabic
- [ ] RTL badge shown in language picker
- [ ] No console errors
- [ ] **RTL layout**: text aligns right-to-left (when RTL wrapper is applied)
- [ ] Icons do not flip incorrectly (check arrow icons)

### 2.9 French (fr)
- [ ] Settings → select "Français (French)"
- [ ] Safety education card displays in French
- [ ] Share sheet invite copy displays in French
- [ ] No console errors

---

## 3. Cross-Language Checks

### 3.1 Language preference persistence
- [ ] Select Hindi → reload page → still Hindi
- [ ] Select Telugu → navigate to another screen → still Telugu
- [ ] Select English → close browser → reopen → still English (if session persists)

### 3.2 English fallback
- [ ] If a translation key is missing, English text appears (no blank strings)
- [ ] Console warning logged in dev for missing keys

### 3.3 Interpolation
- [ ] `area_page.walkers_nearby` with `{count: 5}` renders as "5 walkers nearby" (or translated equivalent)
- [ ] `notifications.club_joined_title` with `{clubName: "Morning Walkers"}` renders correctly
- [ ] `settings.language_completeness` with `{percent: 100}` renders as "100% translated"

### 3.4 No layout breakage
- [ ] Devanagari (Hindi, Bengali) text doesn't overflow containers
- [ ] Dravidian scripts (Telugu, Tamil, Kannada) render with correct font
- [ ] Arabic text aligns correctly (RTL when applicable)
- [ ] Long translated strings don't break button layouts

---

## 4. Safety String Review (Manual)

For each language, a native speaker must review:

### 4.1 Safety education cards (5 original + 5 new = 10 total)
- [ ] `safety.meet_public_title` + `body` — accurate? culturally appropriate?
- [ ] `safety.no_address_title` + `body`
- [ ] `safety.report_block_title` + `body`
- [ ] `safety.night_groups_title` + `body`
- [ ] `safety.sos_limitations_title` + `body`
- [ ] `safety_v1_3.women_only_title` + `body`
- [ ] `safety_v1_3.night_walk_title` + `body`
- [ ] `safety_v1_3.group_walk_title` + `body`
- [ ] `safety_v1_3.privacy_title` + `body`
- [ ] `safety_v1_3.no_emergency_title` + `body`

### 4.2 SOS strings
- [ ] `sos.title` — "Emergency SOS" translated correctly
- [ ] `sos.sos_disclaimer` — critical: must convey that SOS does NOT auto-call emergency services
- [ ] `sos.call_emergency` — local emergency numbers shown correctly

### 4.3 Report/block strings
- [ ] `report_block.report_button` — "Report" translated correctly
- [ ] `report_block.block_button` — "Block" translated correctly
- [ ] `report_block.report_submitted` — confirmation message accurate

---

## 5. Invite Copy Review

For each language, verify the invite share copy is natural and compelling:

- [ ] `invite.default_app_message` — sounds natural, not machine-translated
- [ ] `invite.default_area_message` — area-specific copy makes sense
- [ ] `invite.default_group_walk_message` — group walk invitation is welcoming
- [ ] `invite.default_club_message` — club invitation is welcoming
- [ ] `invite.privacy_reminder` — women-only / verified-only warning is clear

---

## 6. Admin Dashboard Verification

- [ ] `/admin/community` loads without errors
- [ ] Language distribution section shows all 9 languages with counts
- [ ] Translation adoption section shows completeness percentages
- [ ] Invite conversion by language section displays
- [ ] Safety reports by language section displays

---

## 7. Compliance Check

- [ ] No "premium", "subscription", "upgrade", "paid plan" in any translated string
- [ ] Free product language preserved across translations ("free for everyone", "no premium", etc.)
- [ ] Run `/api/admin/compliance` scanner — `isCompliant === true`

---

## 8. Sign-off

- [ ] All 9 languages load without console errors
- [ ] Safety strings reviewed by native speaker (or flagged for review)
- [ ] No layout breakage in any language
- [ ] Language preference persists across sessions
- [ ] English fallback works for any missing keys
- [ ] No paid/monetization language in any locale

**Reviewer:** ___________________
**Date:** ___________________
**Languages reviewed:** ___________________
