# WalkTogether — Safety Education v1.3

**Phase:** 18
**Status:** 10 safety cards implemented (5 original + 5 new v1.3), all translated

---

## 1. Overview

Phase 18 expands the Safety Education Cards from 5 to 10 cards, adding 5 new v1.3 cards covering women-only safety, night walks, group walks, privacy protection, and the no-emergency-call disclaimer. All 10 cards are language-aware and translated across all 9 languages.

---

## 2. The 10 Safety Cards

### 2.1 Original cards (Phase 16)

| # | Card key | Title | Translation key prefix |
|---|----------|-------|----------------------|
| 1 | `meet_public` | Meet only in public places | `safety.meet_public_*` |
| 2 | `no_address` | Do not share your home address | `safety.no_address_*` |
| 3 | `report_block` | Report or block anyone unsafe | `safety.report_block_*` |
| 4 | `night_groups` | Night walks? Prefer groups | `safety.night_groups_*` |
| 5 | `sos_limitations` | SOS does not auto-call 112/911 | `safety.sos_limitations_*` |

### 2.2 New v1.3 cards (Phase 18)

| # | Card key | Title | Translation key prefix |
|---|----------|-------|----------------------|
| 6 | `women_only_safety` | Women-only safety guidance | `safety_v1_3.women_only_*` |
| 7 | `night_walk_guidance` | Night walk guidance | `safety_v1_3.night_walk_*` |
| 8 | `group_walk_safety` | Group walk safety | `safety_v1_3.group_walk_*` |
| 9 | `privacy_protection` | Privacy protection | `safety_v1_3.privacy_*` |
| 10 | `no_emergency_call` | SOS does not auto-call emergency services | `safety_v1_3.no_emergency_*` |

---

## 3. New Card Details

### 3.1 Women-only safety guidance

**Title:** Women-only safety guidance
**Body:** Women-only groups are visible only to women. Still meet in public places and trust your instincts.

**Icon:** Users
**Shown on:** Women-only group walk detail, women-only club detail

### 3.2 Night walk guidance

**Title:** Night walk guidance
**Body:** For walks after sunset, prefer well-lit routes, group walks, or verified walkers. Share your walk session with a friend.

**Icon:** Moon
**Shown on:** Group walk detail (when scheduled after sunset)

### 3.3 Group walk safety

**Title:** Group walk safety
**Body:** Group walks are safer than solo walks. Stay with the group. If someone makes you uncomfortable, tell the host or report them.

**Icon:** Users
**Shown on:** Group walk detail (before joining)

### 3.4 Privacy protection

**Title:** Privacy protection
**Body:** WalkTogether never shares your exact location until you accept a walk. Hide from nearby walkers anytime in Settings.

**Icon:** Lock
**Shown on:** Profile setup, Settings (privacy section)

### 3.5 No emergency auto-call disclaimer

**Title:** SOS does not auto-call emergency services
**Body:** SOS alerts your emergency contacts and our safety team. For immediate danger, call your local emergency number directly (112 / 911 / 100 / 999).

**Icon:** AlertTriangle
**Shown on:** Walk session screen, SOS modal

---

## 4. Language-Aware Rendering

All 10 cards use the `translate()` function to render in the user's preferred language. The `SafetyEducationCard` component:

1. Reads the user's language from the store (`me.language`)
2. Looks up the card's title and body via i18n keys
3. Falls back to English if the translation is missing
4. Renders the card with the appropriate icon

```typescript
function resolveCard(lang: LanguageCode, key: CardKey): { title: string; body: string } {
  const { titleKey, bodyKey } = CARD_KEY_TO_I18N[key];
  const title = translate(lang, titleKey);
  const body = translate(lang, bodyKey);
  return {
    title: title === titleKey ? SAFETY_CARDS_EN[key].title : title,
    body: body === bodyKey ? SAFETY_CARDS_EN[key].body : body,
  };
}
```

---

## 5. Card Placement

| Screen | Cards shown | Component |
|--------|-------------|-----------|
| Home | Random (rotates through 10) | `<SafetyEducationCard />` |
| Area page | `meet_public` (inline) | `<SafetyEducationInline cardKey="meet_public" />` |
| First walker | `meet_public` (inline) | `<SafetyEducationInline cardKey="meet_public" />` |
| Group walk detail | `night_walk_guidance` (if evening) | `<SafetyEducationInline cardKey="night_walk_guidance" />` |
| Walk session | `no_emergency_call` | `<SafetyEducationInline cardKey="no_emergency_call" />` |
| Profile setup | `privacy_protection` | `<SafetyEducationInline cardKey="privacy_protection" />` |

*Note: Some placements are v1.4 UI tasks. The components and translations are ready in Phase 18.*

---

## 6. Dismissal Behavior

- The dismissible `<SafetyEducationCard />` rotates through the 10 cards
- Dismissed cards are stored in `localStorage` (`wt-safety-cards-dismissed`)
- When all 10 cards are dismissed, `<SafetyEducationCard />` renders nothing
- The non-dismissible `<SafetyEducationInline />` always renders the specified card

---

## 7. Safety String Review

All safety card strings are marked with `"_note": "[SAFETY] — Native speaker review required."` in each locale file. Before a locale is marked `reviewed: true`, a native speaker must review:

- All 10 safety card titles + bodies
- All SOS strings
- All report/block strings

This is especially important for:
- The no-emergency-call disclaimer (must be unambiguous)
- The women-only safety guidance (must be culturally appropriate)
- The night walk guidance (must convey the right level of caution)

---

## 8. Analytics

Phase 17 tracks safety card events:

| Event | When |
|-------|------|
| `safety_card_viewed` | Card renders (planned — not yet fired) |
| `safety_card_dismissed` | User dismisses a card |

Properties: `cardKey`, `screen`

*Note: `safety_card_viewed` is defined but not yet wired up. v1.4 will fire it on card render.*

---

## 9. Acceptance Criteria

- [x] 5 new v1.3 safety cards implemented (women_only, night_walk, group_walk, privacy, no_emergency)
- [x] All 10 cards have translation keys in all 9 locale files
- [x] `SafetyEducationCard` component supports all 10 cards
- [x] `SafetyEducationInline` component supports all 10 cards
- [x] Cards are language-aware (use `translate()`)
- [x] English fallback works for missing translations
- [x] Safety strings marked `[SAFETY]` for native review
- [x] Icons assigned to all 10 cards
- [x] Dismissible card rotates through all 10 cards
