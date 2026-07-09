# WalkTogether — Safety Education Cards

**Phase:** 16
**Status:** Implemented
**Files:** `src/components/SafetyEducationCard.tsx`

---

## 1. Why Safety Education Cards?

WalkTogether's safety features (SOS, report/block, women-only/verified-only groups, approximate location, moderation) only work if users know they exist and know how to use them. Passive safety copy buried in a help page is rarely read.

Safety Education Cards are small, dismissible tips that appear in context across the app. They remind users of the most important safety practices at the moment those practices matter most.

---

## 2. The Five Cards

### Card 1 — Meet only in public places

> 📍 **Meet only in public places**
> Parks, markets, well-lit streets. Never at a private home or isolated spot.

**Shown on:** Home screen, Area page

### Card 2 — Do not share your home address

> 🛡️ **Do not share your home address**
> WalkTogether only stores approximate location. Keep your address private.

**Shown on:** Profile setup, Settings (privacy section)

### Card 3 — Report or block anyone unsafe

> ⚠️ **Report or block anyone unsafe**
> If someone makes you uncomfortable, report them. Our team reviews every report.

**Shown on:** Chat screens, Group chat

### Card 4 — Night walks? Prefer groups

> 🌙 **Night walks? Prefer groups**
> For evening or night walks, choose group walks or verified walkers for extra safety.

**Shown on:** Group walk detail (when scheduled time is after sunset), Walk request detail (evening walks)

### Card 5 — SOS does not auto-call emergency services

> 📞 **SOS does not auto-call 112/911**
> SOS alerts your emergency contacts and our safety team. Call local emergency services directly if you are in danger.

**Shown on:** Walk session screen, SOS modal, Settings (safety section)

---

## 3. Component API

### `<SafetyEducationCard />` (dismissible)

Renders a single random non-dismissed card. The user can dismiss it; dismissed cards are stored in `localStorage` and skipped on future renders.

```tsx
<SafetyEducationCard />  // random card
<SafetyEducationCard force="meet_public" />  // specific card
```

**Props:**
- `force?: CardKey` — render a specific card (e.g. in an empty state)
- `className?: string` — extra Tailwind classes

### `<SafetyEducationInline cardKey="..." />` (non-dismissible)

Renders a specific card without a dismiss button. Used in fixed contexts like the Area page and First Walker screen.

```tsx
<SafetyEducationInline cardKey="meet_public" />
```

**Props:**
- `cardKey: CardKey` — required, which card to show
- `className?: string` — extra Tailwind classes

---

## 4. Dismissal Behavior

When a user dismisses a card:
1. The card's key is added to a `Set<CardKey>` in component state.
2. The set is serialized to `localStorage` under the key `wt-safety-cards-dismissed`.
3. Future renders of `<SafetyEducationCard />` skip dismissed cards.
4. When all 5 cards are dismissed, `<SafetyEducationCard />` renders nothing.

**Reset behavior:** A "Reset safety tips" button will be added in Settings (v1.3) to re-show all dismissed cards.

**Force-rendered cards** (via the `force` prop or `<SafetyEducationInline>`) are NEVER dismissible — they always render regardless of dismissal state.

---

## 5. Placement Across the App

| Screen | Card | Component | Notes |
|--------|------|-----------|-------|
| Home | Random (rotates) | `<SafetyEducationCard />` | Below the privacy note, above the walker list |
| Area page | Meet in public | `<SafetyEducationInline cardKey="meet_public" />` | Below the walks and clubs sections |
| First Walker | Meet in public | `<SafetyEducationInline cardKey="meet_public" />` | Below the increase-radius tip |
| Group Walk Detail | Night walks (if evening) | `<SafetyEducationInline cardKey="night_groups" />` | Conditional on scheduled time |
| Walk Session | SOS limitations | `<SafetyEducationInline cardKey="sos_limitations" />` | Below the SOS button |
| Chat | Report/block | `<SafetyEducationInline cardKey="report_block" />` | Below the message input |
| Settings (privacy) | No address | `<SafetyEducationInline cardKey="no_address" />` | In the privacy section |

---

## 6. Visual Design

### Dismissible card (`<SafetyEducationCard />`)

```
┌─────────────────────────────────────────────┐
│ 📍  Meet only in public places          ✕  │
│     Parks, markets, well-lit streets.       │
│     Never at a private home or isolated     │
│     spot.                                   │
└─────────────────────────────────────────────┘
```

- Background: `bg-amber-50/80` (light) / `bg-amber-950/20` (dark)
- Border: `border-amber-500/30`
- Icon: amber-tinted, in a rounded square
- Title: `text-amber-900` (light) / `text-amber-200` (dark)
- Body: `text-amber-800/90` (light) / `text-amber-300/80` (dark)
- Dismiss button: `text-amber-700/60`, top-right

### Inline card (`<SafetyEducationInline />`)

```
┌─────────────────────────────────────────────┐
│ ℹ️  📍 Meet only in public places           │
│     Parks, markets, well-lit streets.       │
│     Never at a private home or isolated     │
│     spot.                                   │
└─────────────────────────────────────────────┘
```

- Background: `bg-card`
- Border: `border-border`
- Smaller padding (p-2.5 vs p-3)
- No dismiss button

---

## 7. Accessibility

- Each card has `role="note"` and an `aria-label` describing the tip.
- The dismiss button has `aria-label="Dismiss safety tip"`.
- Color is never the only signal — text labels are always present.
- Cards meet WCAG AA contrast ratios for both light and dark modes.

---

## 8. Analytics (Future)

In v1.3, we will track:
- `safety_card_shown` — which card was shown on which screen
- `safety_card_dismissed` — when a user dismisses a card

This will help us measure:
- Which cards are most useful
- Which screens benefit most from safety reminders
- Whether dismissals correlate with safety incidents (they shouldn't)

---

## 9. Localization

Card text is currently English-only. When v1.3 translations ship, the `SAFETY_CARDS` map will be replaced with translation keys:

```typescript
const SAFETY_CARDS: Record<CardKey, { icon: ...; titleKey: string; bodyKey: string }> = {
  meet_public: {
    icon: MapPin,
    titleKey: "safety.meet_public.title",
    bodyKey: "safety.meet_public.body",
  },
  // ...
};
```

The `<SafetyEducationCard>` component will call `t(titleKey)` to render the translated string.

---

## 10. Acceptance Criteria

- [x] 5 safety education cards are implemented.
- [x] Cards are dismissible via the X button.
- [x] Dismissed cards are remembered in localStorage.
- [x] Cards appear in context: Home, Area page, First Walker, Group Walk Detail, etc.
- [x] Forced cards (via `force` prop or `<SafetyEducationInline>`) are not dismissible.
- [x] Cards meet accessibility standards (role, aria-label, contrast).
- [x] Cards are free — no premium gating.
