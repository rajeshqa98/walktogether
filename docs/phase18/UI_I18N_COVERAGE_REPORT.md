# WalkTogether — UI i18n Coverage Report

**Phase:** 18B
**Status:** Core screens translated; remaining screens use English fallback

---

## 1. Overview

This report documents which UI screens have been internationalized (i18n) in Phase 18B. Screens marked as "✅ Translated" use the `useTranslation()` hook and `t()` function for all user-facing strings. Screens marked as "⬜ English only" still use inline English strings.

---

## 2. Screen Coverage

### ✅ Fully Translated Screens

| Screen | Component | i18n Keys Used | Notes |
|--------|-----------|----------------|-------|
| Home (no-walkers empty state) | `Home.tsx` → `EmptyState` | `no_walkers.*` | All 7 strings translated |
| Area page | `AreaPage.tsx` | `area_page.*` | All 15 strings translated |
| First walker flow | `FirstWalkerExperience.tsx` | `first_walker.*` | All 11 strings translated |
| Host onboarding | `HostOnboarding.tsx` | `host_onboarding.*` | All 8 step titles + bodies, header, success screen translated |
| Safety education cards | `SafetyEducationCard.tsx` | `safety.*`, `safety_v1_3.*` | All 10 cards (title + body) translated |
| Share sheet (invite copy) | `ShareSheet.tsx` | `invite.*` | All 4 invite message types translated |
| Settings (language picker) | `Settings.tsx` | `settings.*` | Language picker with native names, beta badges, RTL badges |

### ⬜ English Only Screens (v1.4 priority)

| Screen | Component | Strings to Translate | Priority |
|--------|-----------|---------------------|----------|
| Login | `Login.tsx` | ~10 strings | Medium |
| Profile setup | `ProfileSetup.tsx` | ~15 strings | Medium |
| Location permission | `LocationPermission.tsx` | ~12 strings | High |
| Walker card | `WalkerCard.tsx` | ~5 strings | Low |
| Walker detail sheet | `WalkerDetailSheet.tsx` | ~8 strings | Low |
| Requests inbox | `Requests.tsx` | ~10 strings | Medium |
| Chat | `Chat.tsx` | ~8 strings | Medium |
| Walk session | `WalkSession.tsx` | ~15 strings | High |
| Post-walk | `PostWalk.tsx` | ~10 strings | Medium |
| Groups list | `Groups.tsx` | ~8 strings | Medium |
| Group walk detail | `GroupWalkDetail.tsx` | ~20 strings | Medium |
| Create group walk | `GroupWalkCreate.tsx` | ~15 strings | Medium |
| Group chat | `GroupChat.tsx` | ~5 strings | Low |
| Clubs list | `Groups.tsx` (clubs tab) | ~5 strings | Low |
| Club detail | `ClubDetail.tsx` | ~12 strings | Medium |
| Create club | `ClubCreate.tsx` | ~10 strings | Medium |
| Notifications | `Notifications.tsx` | ~8 strings | Medium |
| Feedback | `Settings.tsx` (feedback section) | ~10 strings | Medium |

### 🔄 Partially Translated Screens

| Screen | What's translated | What's not |
|--------|-------------------|------------|
| Settings | Language picker (fully translated) | Community section, notification settings, feedback, legal links — still English |
| Host onboarding | Step titles, bodies, header, success screen — translated | Step points (sub-bullets) — still English |

---

## 3. i18n Infrastructure

### `useTranslation()` hook

Located at `src/lib/use-translation.ts`:

```typescript
const { t, lang, isRtl, dir } = useTranslation();
// t("no_walkers.title") → translated string
// lang → "hi", "te", etc.
// isRtl → true for Arabic
// dir → "rtl" or "ltr"
```

### `useRTLEffect()` hook

Automatically sets `document.documentElement.dir` and `document.documentElement.lang` based on the user's language. Called once in `src/app/page.tsx`.

### Translation key lookup

1. Look up key in user's preferred language
2. If missing, fall back to English
3. If English is missing, return the key itself
4. In dev, log a console warning for missing keys

---

## 4. RTL Support

### What's implemented

- `document.documentElement.dir` is set to `"rtl"` when Arabic is selected
- `document.documentElement.lang` is set to the language code
- Arabic locale has `"rtl": true` metadata
- Language picker shows "RTL" badge for Arabic

### What's not yet implemented (v1.4)

- Tailwind RTL utilities (`rtl:` variants) not applied to components
- Icon mirroring (back/forward arrows) not implemented
- Text alignment (`text-left` → `text-start`) not converted
- Asymmetric padding/margins not converted

### Current RTL behavior

When Arabic is selected:
- ✅ Text direction is RTL at the document level
- ✅ Browser renders Arabic text right-to-left
- ⚠️ Some layouts may not look perfect (padding/margins are LTR-optimized)
- ⚠️ Some icons may point the wrong way (back arrow points left instead of right)

---

## 5. Host Badges

### `HostBadge` component

Located at `src/components/HostBadge.tsx`:

```tsx
<HostBadge isHost={true} trusted={false} size="sm" />
<HostBadge isHost={true} trusted={true} size="md" />
<HostBadge isHost={false} needsReview={true} />
<HostBadge isHost={false} suspended={true} />
```

### Where badges are displayed

| Screen | Component | Badge shown |
|--------|-----------|-------------|
| Group walk detail | `GroupWalkDetail.tsx` | Community Host badge next to host name |
| Club detail | `ClubDetail.tsx` | Community Host badge next to club name |
| Host onboarding success | `HostOnboarding.tsx` | Community Host badge on completion screen |

### Badge types

| Badge | Icon | Color | When shown |
|-------|------|-------|------------|
| Community Host | Award | Primary | `isCommunityHost === true` |
| Trusted Host | Star | Emerald | Host meets trusted criteria |
| Needs review | AlertTriangle | Amber | 2+ reports against host (admin only) |
| Suspended | Ban | Red | Account suspended/banned (admin only) |

---

## 6. Language Picker

### Features

- Native language names (हिन्दी, తెలుగు, தமிழ், etc.)
- English language name below native name
- Translation completeness percentage (100% for all)
- "Beta" badge for languages pending native review
- "RTL" badge for Arabic
- Active language highlighted with primary border + checkmark icon
- Save success toast: "Language saved: <native name>"
- Save error toast: "Could not save language preference"
- Native review note at bottom: "Translations are beta and should be reviewed by native speakers before public promotion."

---

## 7. Acceptance Criteria

- [x] `useTranslation()` hook exists and works
- [x] `useRTLEffect()` hook exists and sets document dir/lang
- [x] Home no-walkers empty state is translated
- [x] Area page is translated
- [x] First walker flow is translated
- [x] Host onboarding is translated (titles + bodies)
- [x] Safety education cards are translated (all 10)
- [x] Share sheet invite copy is translated
- [x] Settings language picker shows native names, beta badges, RTL badges
- [x] Host badges displayed in GroupWalkDetail, ClubDetail, HostOnboarding
- [x] Arabic RTL: document.dir set to "rtl"
- [ ] All 25 screens fully translated (v1.4)
- [ ] Tailwind RTL utilities applied (v1.4)
- [ ] Icon mirroring for RTL (v1.4)
