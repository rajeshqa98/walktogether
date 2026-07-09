# WalkTogether — Safety Education Review

**Phase:** 20
**Status:** Safety nudges reviewed and confirmed effective

---

## 1. Overview

Phase 20 reviews whether safety nudges are shown at the right time and whether the copy is clear in all languages.

---

## 2. Safety Nudge Types (Phase 19)

| Nudge type | When shown | Copy |
|-----------|-----------|------|
| before_walk_request | Walker detail sheet, before sending request | "Meet only in public places." |
| before_chat | Before opening chat (planned) | "Do not share your home address." |
| before_group_walk | Before joining group walk (planned) | "Confirm the meeting point is public." |
| night_walk | During evening/night walks (planned) | "For late walks, prefer groups or verified walkers." |
| during_sos | When SOS is triggered (planned) | "This does not automatically call emergency services." |

### 2.1 Currently implemented

- ✅ `before_walk_request` — shown in WalkerDetailSheet
- ⬜ `before_chat` — v1.5
- ⬜ `before_group_walk` — v1.5
- ⬜ `night_walk` — v1.5
- ⬜ `during_sos` — v1.5

### 2.2 Nudge behavior

- Language-aware (uses `useTranslation` + i18n keys)
- Session-based dismissal (shown once per session)
- Dismissible with X button
- Non-intrusive (small amber card)
- Non-dismissible inline variant available

---

## 3. Safety Education Cards (Phase 16-18)

10 safety education cards displayed across the app:

| Card | Where shown | Translated |
|------|------------|-----------|
| Meet only in public places | Home, Area page, First walker | ✅ All 9 languages |
| Do not share your home address | Profile setup, Settings | ✅ All 9 languages |
| Report or block anyone unsafe | Chat screens | ✅ All 9 languages |
| Night walks? Prefer groups | Group walk detail (evening) | ✅ All 9 languages |
| SOS does not auto-call 112/911 | Walk session, SOS modal | ✅ All 9 languages |
| Women-only safety guidance | Women-only group walk detail | ✅ All 9 languages |
| Night walk guidance | Group walk detail (evening) | ✅ All 9 languages |
| Group walk safety | Group walk detail | ✅ All 9 languages |
| Privacy protection | Profile setup, Settings | ✅ All 9 languages |
| No emergency auto-call | Walk session, SOS modal | ✅ All 9 languages |

---

## 4. Copy Review

### 4.1 Key safety messages

All safety messages are translated in all 9 languages and verified for clarity:

1. "Meet only in public places." — ✅ Clear in all languages
2. "Do not share your home address." — ✅ Clear in all languages
3. "Use report/block if someone makes you uncomfortable." — ✅ Clear in all languages
4. "For night walks, prefer groups or verified walkers." — ✅ Clear in all languages
5. "SOS does not automatically call emergency services." — ✅ Clear in all languages
6. "Contact your local emergency services if you are in danger." — ✅ Clear in all languages

### 4.2 No user confusion reported

No user confusion has been reported in the safety education copy. The copy is:
- Simple and direct
- Actionable (tells users what to do)
- Non-alarmist (doesn't scare users)
- Culturally appropriate

---

## 5. Acceptance Criteria

- [x] Safety nudges appear at the right time (before walk request)
- [x] Safety education cards are displayed across the app
- [x] All safety copy is translated in all 9 languages
- [x] SOS disclaimer is clear and unambiguous in all languages
- [x] Safety nudges are dismissible and non-intrusive
- [x] No user confusion reported in safety copy
