# WalkTogether — RTL Arabic Verification Report

**Phase:** 18C
**Status:** ✅ Document-level RTL implemented; component-level RTL deferred to v1.4

---

## 1. Overview

Arabic RTL support was implemented in Phase 18B with the `useRTLEffect()` hook that sets `document.documentElement.dir = "rtl"` and `document.documentElement.lang = "ar"`. Phase 18C verifies that core screens remain usable when Arabic is selected.

---

## 2. What's Implemented

### 2.1 Document-level RTL

The `useRTLEffect()` hook in `src/lib/use-translation.ts` automatically sets:
- `document.documentElement.dir = "rtl"` when Arabic is selected
- `document.documentElement.lang = "ar"`
- Restores `dir = "ltr"` and `lang = "en"` when switching back to English

This hook is called once in `src/app/page.tsx`.

### 2.2 RTL metadata

The Arabic locale file (`src/locales/ar.json`) has `"rtl": true` in its `_meta` block.

### 2.3 RTL badge in language picker

The Settings language picker shows an "RTL" badge next to Arabic so users know the language requires RTL layout.

### 2.4 Arabic translation

All 518 translation keys are present in the Arabic locale file. The Arabic translations are marked "Beta" pending native speaker review.

---

## 3. Verification Results

### 3.1 Screens tested with Arabic

| Screen | Status | Notes |
|--------|--------|-------|
| Login | ✅ Usable | Text renders RTL; form inputs work |
| Home | ✅ Usable | Walker cards render correctly; safety card displays |
| Area page | ✅ Usable | Section headers, CTAs, walk/club lists render in Arabic |
| Settings | ✅ Usable | Language picker shows RTL badge; all sections accessible |
| Requests | ✅ Usable | Accept/Decline buttons work; request cards render |
| Groups | ✅ Usable | Walk/club lists render; filter tabs work |
| Notifications | ✅ Usable | Notification list renders; mark all read works |
| Chat | ✅ Usable | Chat bubbles render; message input works |
| Walk Session | ✅ Usable | SOS button accessible; timer displays |

### 3.2 Text direction

- ✅ Arabic text renders right-to-left at the document level
- ✅ Browser handles text direction automatically for Arabic characters
- ✅ Form inputs accept RTL text correctly

### 3.3 Icon direction

- ⚠️ Back/forward arrows are NOT mirrored (still point left/right as in LTR)
- ⚠️ Chevron icons are NOT mirrored
- ✅ Brand icons (Footprints, MapPin, Phone, ShieldCheck) are NOT mirrored (correct — they should stay the same)
- ✅ Send button icon is NOT mirrored (acceptable)

### 3.4 Layout

- ⚠️ Some layouts use LTR-optimized padding/margins (`pl-4` instead of `ps-4`)
- ⚠️ Flexbox rows are NOT reversed (acceptable for most layouts)
- ✅ Text-centered content renders correctly
- ✅ Buttons remain clickable and don't break
- ✅ Bottom nav remains usable (7 tabs in correct order)
- ✅ Chat bubbles remain readable

---

## 4. Known RTL Limitations (v1.4 backlog)

1. **Tailwind RTL utilities** — `rtl:` variant modifiers not applied to components. Need to audit all `text-left`/`text-right` and `pl-`/`pr-` classes.

2. **Icon mirroring** — Back/forward arrows and chevrons should be mirrored in RTL using `rtl:rotate-180` or `rtl:scale-x-[-1]`.

3. **Text alignment** — `text-left` should become `text-start` (Tailwind v4) or `rtl:text-right`.

4. **Asymmetric padding** — `pl-4 pr-2` should become `ps-4 pe-2` or include `rtl:` variants.

5. **Flexbox direction** — Some row-based layouts may need `rtl:flex-row-reverse`.

---

## 5. v1.4 RTL Polish Plan

### Step 1: Audit and convert text alignment (2 hours)
- Replace all `text-left` with `text-start` (Tailwind v4)
- Replace all `text-right` with `text-end`

### Step 2: Convert asymmetric padding (3 hours)
- Replace `pl-` with `ps-` (padding-inline-start)
- Replace `pr-` with `pe-` (padding-inline-end)
- Replace `ml-` with `ms-` (margin-inline-start)
- Replace `mr-` with `me-` (margin-inline-end)

### Step 3: Mirror directional icons (2 hours)
- Add `rtl:rotate-180` to ChevronLeft, ArrowLeft
- Add `rtl:scale-x-[-1]` to Send icon
- Verify brand icons don't flip

### Step 4: Test with native Arabic speaker (2 hours)
- Get feedback on layout naturalness
- Fix any remaining issues

**Total estimated effort:** 9 hours

---

## 6. Acceptance Criteria

- [x] `document.documentElement.dir` is set to "rtl" when Arabic is selected
- [x] `document.documentElement.lang` is set to "ar"
- [x] Arabic text renders right-to-left
- [x] All core screens remain usable (no crashes, no broken layouts)
- [x] Chat bubbles remain readable
- [x] Buttons do not break
- [x] Bottom nav remains usable
- [x] Arabic locale has all 518 keys
- [ ] Tailwind RTL utilities applied (v1.4)
- [ ] Icon mirroring for directional icons (v1.4)
- [ ] Native Arabic speaker sign-off (v1.4)
