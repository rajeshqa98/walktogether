# WalkTogether — Global Language Readiness Plan

**Phase:** 16
**Status:** Structured for translation; full translations deferred to v1.3+
**Files:** `src/app/api/me/route.ts` (language field), `src/components/screens/Settings.tsx` (language picker)

---

## 1. Goal

WalkTogether is used globally — villages, towns, and cities across India, South Asia, the Middle East, Africa, Europe, and the Americas. To serve these users well, the app must be translatable into their preferred languages.

**v1.2 ships:**
- A `language` field on the User model (default `"en"`)
- A language preference picker in Settings
- All UI strings extracted into a structured format ready for translation

**v1.2 does NOT ship:**
- Full translations of every screen (deferred to v1.3+)
- Auto-detection from phone locale (deferred to v1.3)
- Per-screen language toggle (deferred — global preference only in v1.2)

---

## 2. Supported Languages (v1.2)

| Code | Language | Native name | Script |
|------|----------|-------------|--------|
| `en` | English | English | Latin |
| `hi` | Hindi | हिन्दी | Devanagari |
| `te` | Telugu | తెలుగు | Telugu |
| `ta` | Tamil | தமிழ் | Tamil |
| `kn` | Kannada | ಕನ್ನಡ | Kannada |
| `bn` | Bengali | বাংলা | Bengali |
| `es` | Spanish | Español | Latin |
| `ar` | Arabic | العربية | Arabic (RTL) |
| `fr` | French | Français | Latin |

These 9 languages were chosen based on:
- Existing user distribution (India + global English)
- Moderate-to-large speaker populations globally
- Coverage of major scripts (Latin, Devanagari, Dravidian, Arabic)

More languages can be added in v1.3+ without schema changes — the `language` field is a free-form string.

---

## 3. User Preference Storage

### Schema

```prisma
model User {
  // ...
  language String @default("en")  // preferred UI language code
}
```

### API

Users can update their language preference via:

```
PATCH /api/me
{ "language": "hi" }
```

Returns the updated user with the new `language` value.

### Settings UI

The Settings screen has a "Language preference" section with a `<select>` dropdown:

```
App language
WalkTogether is structured for these languages. Translations are rolling out gradually.

[ English ▼ ]
  English
  हिन्दी (Hindi)
  తెలుగు (Telugu)
  தமிழ் (Tamil)
  ಕನ್ನಡ (Kannada)
  বাংলা (Bengali)
  Español (Spanish)
  العربية (Arabic)
  Français (French)
```

Each option shows both the English name and the native name+script, so users who don't read English can still find their language.

---

## 4. String Extraction Strategy (v1.3 prep)

In v1.2, all UI strings are written inline in JSX:

```tsx
<button>Create group walk</button>
```

For v1.3, we will extract these into a translation file structure:

```
src/locales/
  en.json
  hi.json
  te.json
  ta.json
  kn.json
  bn.json
  es.json
  ar.json
  fr.json
```

With keys like:

```json
{
  "home.empty.create_group_walk": "Create a group walk",
  "home.empty.start_club": "Start a walking club",
  "home.empty.invite_friends": "Invite friends",
  "first_walker.hero.title": "You're one of the first walkers here.",
  "first_walker.hero.body": "Every walking community starts with one person..."
}
```

A `useTranslation()` hook will read the current user's language and return the appropriate string. Components will switch from:

```tsx
<button>Create group walk</button>
```

to:

```tsx
<button>{t("home.empty.create_group_walk")}</button>
```

This refactor is mechanical and can be done incrementally — no architectural changes needed.

---

## 5. RTL Support

Arabic (`ar`) is a right-to-left language. The Flutter app already supports RTL via Flutter's `Directionality` widget.

For the web/PWA, we will use Tailwind's RTL utilities (`rtl:`, `ltr:`) and set `dir="rtl"` on the `<html>` element when the user's language is Arabic.

In v1.2, the web app's layout is LTR only. RTL support is targeted for v1.3 alongside the Arabic translation.

---

## 6. Moderation Language Coverage

Moderation is already multilingual in v1.2. The `src/lib/moderation.ts` library covers:

- English
- Hindi (Devanagari + Roman)
- Hinglish (transliterated)
- Telugu (transliterated)
- Tamil (transliterated)
- Spanish, Arabic, French (high-severity only)

This is independent of the UI language — moderation runs on every message regardless of the user's language preference.

---

## 7. Date and Time Formatting

Dates and times are formatted using the user's browser locale (`Intl.DateTimeFormat`). In v1.3, we will explicitly pass the user's `language` code to ensure consistent formatting regardless of browser locale.

Example:
```typescript
new Date(walk.scheduledAt).toLocaleString([user.language], {
  weekday: "short",
  day: "numeric",
  month: "short",
  hour: "2-digit",
  minute: "2-digit",
});
```

---

## 8. Translation Workflow (v1.3+)

When translations are ready:

1. **Strings are extracted** into `src/locales/en.json` (source language).
2. **Translations are sourced** via:
   - Professional translation service for high-traffic screens (Home, Login, ProfileSetup)
   - Community contributions for lower-traffic screens
   - Machine translation as a starting point, reviewed by native speakers
3. **Translations are reviewed** by at least one native speaker before merge.
4. **Missing keys** fall back to English with a console warning in dev.
5. **Translation completeness** is tracked per-language in a dashboard.

---

## 9. What v1.2 Delivers

- ✅ Language preference field on User
- ✅ Settings picker for 9 languages
- ✅ Native script display in the picker
- ✅ Multilingual moderation (independent of UI language)
- ✅ Date/time formatting via browser locale
- ✅ Documentation of the v1.3 translation plan

## 10. What v1.2 Does NOT Deliver

- ❌ Full UI translations (deferred to v1.3)
- ❌ Auto-detection from phone locale (deferred to v1.3)
- ❌ RTL layout for Arabic (deferred to v1.3)
- ❌ Per-screen language toggle (global preference only)
- ❌ Translation management UI for admins (deferred to v1.3)

---

## 11. Acceptance Criteria

- [x] User can set language preference in Settings.
- [x] Language preference is persisted on the User record.
- [x] 9 languages are listed (English, Hindi, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French).
- [x] Native script is shown for each language in the picker.
- [x] The picker notes that "translations are rolling out gradually" — no false promise of full translation in v1.2.
- [x] Moderation works in all 9 languages (independent of UI language).
