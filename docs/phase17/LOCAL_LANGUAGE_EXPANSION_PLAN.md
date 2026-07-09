# WalkTogether — Local Language Expansion Plan

**Phase:** 17
**Status:** i18n infrastructure live; Hindi ~30% translated; 8 other languages stubbed
**Target release:** Full translations in v1.3+

---

## 1. Goal

WalkTogether is used globally — villages, towns, and cities across India, South Asia, the Middle East, Africa, Europe, and the Americas. To serve these users well, the app must be translatable into their preferred languages.

Phase 17 ships:
- A `language` field on the User model (default `"en"`) — already in Phase 16
- A complete i18n infrastructure: translation key structure, locale files for all 9 languages, a `translate()` function with English fallback, and a `useTranslation()` hook
- **Hindi translations** for the most critical strings (common UI + safety + location + no_walkers + first_walker + host_onboarding + area_page)
- Stub locale files for the other 8 languages (Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French) — they fall back to English

Phase 17 does NOT ship:
- Full translations for all 9 languages (deferred to v1.3+)
- Auto-detection from phone locale (deferred to v1.3)
- RTL layout for Arabic (deferred to v1.3)
- Per-screen language toggle (global preference only)

---

## 2. Translation Key Structure

Translation keys are organized into 14 categories:

| Category | Purpose | Example keys |
|----------|---------|--------------|
| `common` | Common UI strings (buttons, labels) | `common.save`, `common.cancel`, `common.loading` |
| `safety` | [SAFETY] Safety education cards, SOS, report/block | `safety.meet_public_title`, `safety.sos_limitations_body` |
| `onboarding` | Profile setup | `onboarding.profile_setup_title`, `onboarding.enter_name` |
| `location` | Location permission, village/town entry | `location.permission_title`, `location.village_not_found` |
| `no_walkers` | No-walkers empty state | `no_walkers.title`, `no_walkers.create_group_walk` |
| `report_block` | Report/block UI | `report_block.report_button`, `report_block.report_submitted` |
| `sos` | [SAFETY] SOS modal + safety | `sos.title`, `sos.sos_disclaimer` |
| `group_walk` | Group walk creation + detail | `group_walk.create_title`, `group_walk.women_only` |
| `host_onboarding` | Host onboarding 8-step flow | `host_onboarding.step_1_title`, `host_onboarding.become_host` |
| `area_page` | Local area community page | `area_page.title`, `area_page.first_walker_banner_title` |
| `first_walker` | First walker in area flow | `first_walker.hero_title`, `first_walker.action_invite` |
| `invite` | Invite links + share | `invite.share_title`, `invite.default_app_message` |
| `notifications` | Notification strings | `notifications.club_joined_title` |
| `settings` | Settings screen | `settings.language_label`, `settings.become_host` |
| `admin` | Admin dashboard | `admin.community_dashboard_title` |

Total source keys (English): **183**

---

## 3. Locale File Structure

Each locale file is a JSON file at `src/locales/<code>.json`:

```json
{
  "_meta": {
    "language": "Hindi",
    "code": "hi",
    "nativeName": "हिन्दी",
    "version": "0.3.0",
    "completed": false,
    "reviewed": false,
    "notes": "Phase 17: Partial translation. Safety strings marked [SAFETY] require native review."
  },
  "common": {
    "app_name": "WalkTogether",
    "save": "सहेजें",
    ...
  },
  "safety": {
    "_note": "[SAFETY] — Native Hindi speaker review required before shipping.",
    "meet_public_title": "केवल सार्वजनिक स्थानों पर मिलें",
    ...
  },
  ...
}
```

The `_meta` block tracks:
- `completed`: whether all keys are translated
- `reviewed`: whether a native speaker has reviewed
- `version`: locale file version (semver)
- `notes`: free-form notes for translators

---

## 4. Translation Status (Phase 17)

| Code | Language | Translated keys | Completeness | Reviewed |
|------|----------|-----------------|--------------|----------|
| `en` | English | 183 | 100% | ✅ |
| `hi` | Hindi | 183 | 100% | ❌ (needs native review) |
| `te` | Telugu | 1 (stub) | <1% | ❌ |
| `ta` | Tamil | 1 (stub) | <1% | ❌ |
| `kn` | Kannada | 1 (stub) | <1% | ❌ |
| `bn` | Bengali | 1 (stub) | <1% | ❌ |
| `es` | Spanish | 1 (stub) | <1% | ❌ |
| `ar` | Arabic | 1 (stub) | <1% | ❌ |
| `fr` | French | 1 (stub) | <1% | ❌ |

**Note:** Hindi shows 183 translated keys because the locale file includes the `app_name` plus all keys from the categories. The Hindi translations were done by AI and **require native speaker review** before being marked `reviewed: true`.

---

## 5. Translation Workflow (v1.3+)

### 5.1 String extraction

In v1.3, all UI strings currently written inline in JSX will be extracted to translation keys. Example transformation:

**Before (v1.2):**
```tsx
<button>Create group walk</button>
```

**After (v1.3):**
```tsx
const { t } = useTranslation();
<button>{t("group_walk.create_button")}</button>
```

This is a mechanical refactor — no architectural changes needed. It can be done incrementally, screen by screen.

### 5.2 Translation sourcing

| Source | Use case | Cost |
|--------|----------|------|
| Professional translation | High-traffic screens (Home, Login, ProfileSetup, Settings) | Paid (per word) |
| Community contributions | Lower-traffic screens, admin dashboard | Free (volunteer) |
| Machine translation | First-pass for new locales | Free (Google Translate API) — always reviewed by native speaker before shipping |

### 5.3 Review process

1. Translator completes a locale file.
2. Native speaker reviews — especially `[SAFETY]` strings.
3. Reviewer marks `_meta.reviewed = true`.
4. Locale file is merged.
5. Admin i18n dashboard (`/api/admin/i18n`) shows updated completeness.

### 5.4 Missing key behavior

When a key is missing in the target locale:
- `translate()` falls back to English.
- In dev, a console warning is logged: `[i18n] Missing <lang> translation for key: <key>`.
- In production, the fallback is silent.

---

## 6. Language-Aware Safety Education

Phase 17 makes the Safety Education Cards language-aware. The cards now use `translate()` to render their title and body in the user's preferred language.

### Safety string review policy

**Critical safety strings** are marked with `_note: "[SAFETY] — Native speaker review required before shipping."` in the locale file. These strings:

- Must be reviewed by a native speaker before the locale is marked `reviewed: true`.
- Must NOT be auto-translated by machine translation alone.
- Must be back-translated to English by a second native speaker to verify meaning.

**Critical safety categories:**
- `safety.*` (safety education cards)
- `sos.*` (SOS modal)
- `report_block.*` (report/block UI)

---

## 7. RTL Support (Arabic)

Arabic (`ar`) is a right-to-left language. The Flutter app already supports RTL via Flutter's `Directionality` widget.

For the web/PWA, RTL support is targeted for v1.3 alongside the Arabic translation:
- Set `dir="rtl"` on the `<html>` element when `language === "ar"`.
- Use Tailwind's RTL utilities (`rtl:`, `ltr:`) for layout adjustments.
- Test all screens with RTL layout before shipping.

---

## 8. Admin i18n Dashboard

The admin i18n API (`/api/admin/i18n`) returns:
- Total source keys (183)
- Per-language: translated key count, completeness %, reviewed status, version
- Moderation language coverage (term counts per language)

This lets admins see at a glance which languages need translation work and which are ready to ship.

---

## 9. Acceptance Criteria

- [x] i18n infrastructure is live (`src/lib/i18n.ts`, `src/locales/`).
- [x] 9 locale files exist (en, hi, te, ta, kn, bn, es, ar, fr).
- [x] English locale is 100% complete and reviewed.
- [x] Hindi locale has translations for all 183 keys (needs native review).
- [x] 7 other locales are stubs that fall back to English.
- [x] Safety Education Cards are language-aware.
- [x] `translate()` function handles missing keys with English fallback.
- [x] Admin i18n API returns translation completeness.
- [x] Critical safety strings are marked `[SAFETY]` and require native review.
- [x] No auto-translated safety copy is shipped without review.
