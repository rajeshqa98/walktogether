# WalkTogether — RTL Arabic Readiness Report

**Phase:** 18
**Status:** RTL infrastructure implemented; full RTL layout rollout deferred to v1.4

---

## 1. Overview

Arabic is a right-to-left (RTL) language. Phase 18 adds RTL readiness infrastructure to the i18n system and documents the remaining work needed for full RTL layout support.

---

## 2. What's Implemented in Phase 18

### 2.1 RTL metadata in locale file

The Arabic locale (`src/locales/ar.json`) includes `"rtl": true` in its `_meta` block:

```json
"_meta": {
  "language": "Arabic",
  "code": "ar",
  "nativeName": "العربية",
  "version": "1.0.0",
  "completed": true,
  "reviewed": false,
  "rtl": true,
  "notes": "Phase 18: Full translation. RTL layout support."
}
```

### 2.2 RTL helper functions in i18n.ts

```typescript
// Returns true for Arabic, false for all other languages
export function isRTL(lang: LanguageCode): boolean {
  return lang === "ar";
}

// Returns "rtl" or "ltr" — used to set dir attribute on HTML element
export function getTextDirection(lang: LanguageCode): "rtl" | "ltr" {
  return isRTL(lang) ? "rtl" : "ltr";
}
```

### 2.3 RTL badge in language picker

The Settings language picker shows an "RTL" badge next to Arabic so users know the language requires RTL layout:

```
العربية  [Beta] [RTL]
Arabic · 100% translated
```

### 2.4 Arabic translation complete

The Arabic locale file has all 264 keys translated, including:
- All safety strings (marked `[SAFETY]` for native review)
- All UI strings
- All invite copy
- All host onboarding steps
- All admin dashboard labels

---

## 3. What's NOT Yet Implemented (Deferred to v1.4)

### 3.1 HTML dir attribute

The `<html>` element does not yet dynamically set `dir="rtl"` when the user selects Arabic. This requires:

```tsx
// In src/app/layout.tsx (future v1.4)
<html dir={userLanguage === "ar" ? "rtl" : "ltr"}>
```

Currently, the HTML element is static (`dir="ltr"`). Adding dynamic direction requires either:
- A server component that reads the user's language from the session
- A client-side effect that sets `document.dir` on language change

### 3.2 Tailwind RTL utilities

Tailwind CSS supports RTL via `rtl:` and `ltr:` variant modifiers. These are not yet used in the codebase. When RTL layout is enabled, components should use:

```tsx
// Example: icon that should flip in RTL
<ArrowLeft className="rtl:rotate-180" />

// Example: padding that flips in RTL
<div className="pl-4 rtl:pr-4 rtl:pl-0">
```

### 3.3 Icon direction exceptions

Some icons should NOT flip in RTL:
- Brand logos
- Numerical/date icons
- Progress bars (debatable — some apps flip, some don't)

Some icons SHOULD flip in RTL:
- Back/forward arrows
- Chevron left/right
- List bullets

This requires per-icon review and `rtl:rotate-180` (or `rtl:scale-x-[-1]`) classes.

### 3.4 Text alignment

All `text-left` and `text-right` classes need review:
- `text-left` → should become `text-start` (Tailwind v4) or `rtl:text-right`
- `text-right` → should become `text-end` or `rtl:text-left`

### 3.5 Flexbox direction

Row-based flex layouts may need `rtl:flex-row-reverse` in some cases.

### 3.6 Padding/margin asymmetry

Asymmetric padding (`pl-4 pr-2`) needs RTL equivalents (`rtl:pl-2 rtl:pr-4`).

---

## 4. Arabic Text Alignment Checks

When RTL is enabled, verify:

- [ ] Headings align right
- [ ] Body text aligns right
- [ ] Form labels align right
- [ ] Buttons: icon on right, text on left (in RTL)
- [ ] List items: bullet on right
- [ ] Tables: first column on right
- [ ] Modals: close button on left (in RTL)
- [ ] Bottom nav: order may reverse (debatable)

---

## 5. Icon Direction Exceptions

### Icons that SHOULD flip in RTL

| Icon | LTR direction | RTL direction |
|------|---------------|---------------|
| ArrowLeft | Points left (back) | Points right (back) |
| ArrowRight | Points right (forward) | Points left (forward) |
| ChevronLeft | Points left | Points right |
| ChevronRight | Points right | Points left |
| Send (paper plane) | Points right | Points left |

### Icons that should NOT flip in RTL

| Icon | Reason |
|------|--------|
| Footprints (logo) | Brand identity |
| MapPin | Universal symbol |
| Phone | Universal symbol |
| ShieldCheck | Universal symbol |
| Clock | Universal symbol |
| Calendar | Universal symbol |

---

## 6. Testing Arabic RTL

### 6.1 Manual test plan

1. Set language to Arabic in Settings
2. Verify HTML `dir` attribute changes to `rtl` (after v1.4 implementation)
3. Navigate through every screen:
   - Home
   - Area page
   - First walker
   - Host onboarding
   - Group walk detail
   - Club detail
   - Settings
   - Notifications
4. Check text alignment on each screen
5. Check icon directions
6. Check modal/sheet alignment
7. Check bottom nav order

### 6.2 Known limitations in Phase 18

- The app renders Arabic text but in LTR layout
- Text will appear left-aligned even though it should be right-aligned
- Icons will not flip
- This is acceptable for Phase 18 since Arabic users can still read the content; full RTL polish is a v1.4 priority

---

## 7. v1.4 RTL Implementation Plan

### Step 1: Dynamic HTML dir attribute (2 hours)
- Add `dir` attribute to `<html>` based on user language
- Test that all text re-aligns

### Step 2: Add Tailwind RTL utilities (4 hours)
- Audit all `text-left` / `text-right` → use `text-start` / `text-end`
- Audit asymmetric padding/margins
- Add `rtl:` variants where needed

### Step 3: Flip directional icons (2 hours)
- Add `rtl:rotate-180` to back/forward arrows
- Add `rtl:scale-x-[-1]` to send icons
- Verify brand icons don't flip

### Step 4: Test and polish (4 hours)
- Manual test all screens in RTL
- Fix any layout breakage
- Get native Arabic speaker feedback

**Total estimated effort:** 12 hours

---

## 8. Acceptance Criteria

- [x] Arabic locale file has `rtl: true` metadata
- [x] `isRTL()` and `getTextDirection()` helper functions exist
- [x] Language picker shows RTL badge for Arabic
- [x] Arabic translations are 100% complete
- [ ] HTML `dir` attribute dynamically set (v1.4)
- [ ] Tailwind RTL utilities applied (v1.4)
- [ ] Icon direction exceptions handled (v1.4)
- [ ] Native Arabic speaker sign-off on layout (v1.4)
