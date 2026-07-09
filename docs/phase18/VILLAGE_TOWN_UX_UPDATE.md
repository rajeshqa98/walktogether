# WalkTogether — Village/Town UX Update

**Phase:** 18
**Status:** Improved flows shipped; full geocoding deferred to v1.4

---

## 1. Overview

Phase 18 improves the village/town user experience with:
- New translation keys for granular location fields
- Confirmation modal with clear "what works" vs "limited" messaging
- "My village/town is not listed" support copy
- Timezone detection display
- Localized village/town UI strings

---

## 2. New Translation Keys (village_town category)

Phase 18 adds 16 new keys in the `village_town` category, translated across all 9 languages:

| Key | English source |
|-----|---------------|
| `field_village` | Village / town / locality |
| `field_district` | District / county |
| `field_state` | State / region |
| `field_country` | Country |
| `field_landmark` | Nearby landmark (optional) |
| `field_timezone` | Timezone |
| `timezone_detected` | Detected: {timezone} |
| `use_approximate` | Use approximate location |
| `use_approximate_desc` | We'll save your text as your location without exact coordinates. |
| `not_listed_title` | My village/town is not listed |
| `not_listed_body` | If your village or town doesn't appear in the search, type it manually. We'll save it as your approximate location... |
| `confirm_title` | Confirm your location |
| `confirm_body` | We couldn't find "{text}" in our city list. We'll save it as your approximate location. |
| `confirm_what_works` | What works: Joining group walks, starting clubs, inviting friends, chat, SOS. |
| `confirm_limited` | Limited: You may not appear in nearby walker lists because we don't have your exact coordinates. |
| `confirm_button` | Confirm |
| `change_anytime` | You can change your location anytime in Settings. |

---

## 3. Location Confirmation Modal

### 3.1 When it shows

When a user enters a custom village/town name that's not in the city list and taps "Use '<text>' as my location", a confirmation modal appears before saving.

### 3.2 Modal content

```
┌──────────────────────────────────────┐
│ 🏢  Confirm your location            │
│                                      │
│ We couldn't find "<text>" in our     │
│ city list. We'll save it as your     │
│ approximate location.                │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ What works: Joining group walks, │ │
│ │ starting clubs, inviting         │ │
│ │ friends, chat, SOS.              │ │
│ │                                  │ │
│ │ Limited: You may not appear in   │ │
│ │ nearby walker lists because we   │ │
│ │ don't have your exact coordinates│ │
└──────────────────────────────────────┘
│                                      │
│ [Cancel]              [Confirm]      │
│                                      │
│ You can change your location anytime │
│ in Settings.                         │
└──────────────────────────────────────┘
```

### 3.3 Why this matters

**Before Phase 17:** Clicking "Use as location" immediately saved with no warning. Users were surprised when they didn't appear in nearby walker lists.

**After Phase 17/18:** The confirmation modal sets clear expectations BEFORE the user commits. The "What works" vs "Limited" framing helps users understand the tradeoff.

---

## 4. "My Village/Town Is Not Listed" Support Copy

The `not_listed_title` and `not_listed_body` keys provide support copy for users who can't find their village/town in the search:

> **My village/town is not listed**
>
> If your village or town doesn't appear in the search, type it manually. We'll save it as your approximate location. You can still join group walks, start clubs, and invite friends — you just may not appear in nearby walker lists until we add geocoding.

This copy is available in the locale files and can be surfaced in:
- A help tooltip next to the location search
- A FAQ section (future)
- The confirmation modal (already shown)

---

## 5. Timezone Detection

The `timezone_detected` key shows the user's detected timezone:

```
Timezone: Detected: Asia/Kolkata
```

The timezone is detected via `Intl.DateTimeFormat().resolvedOptions().timeZone` and stored on the user record. This helps:
- Schedule group walks at correct local times
- Display walk times in the user's local timezone
- Analytics: understand user geographic distribution

---

## 6. Granular Location Fields

Phase 16 added these fields to the User model. Phase 18 adds translation keys for their labels:

| Field | Label key | English label |
|-------|-----------|---------------|
| `village` | `village_town.field_village` | Village / town / locality |
| `town` | `village_town.field_village` | (same) |
| `district` | `village_town.field_district` | District / county |
| `stateRegion` | `village_town.field_state` | State / region |
| `countryCode` | `village_town.field_country` | Country |
| `landmark` | `village_town.field_landmark` | Nearby landmark (optional) |
| `timezone` | `village_town.field_timezone` | Timezone |

These fields are stored on the User record and used for:
- Area slug computation (`buildAreaSlug`)
- Area page matching (text-based, not coordinate-based)
- Analytics (village/town adoption metrics)

---

## 7. "Use Approximate Location" Option

The `use_approximate` and `use_approximate_desc` keys describe the option to save a text-only location without GPS coordinates:

> **Use approximate location**
> We'll save your text as your location without exact coordinates.

This is the behavior when:
- GPS is denied or unavailable
- The village/town is not in the geocoding database
- The user chooses manual entry over GPS

---

## 8. Known Limitations

### 8.1 No geocoding API (deferred to v1.4)

Village/town entries are stored with `(0, 0)` coordinates. Users with approximate locations:
- ✅ Can join group walks (matched by text)
- ✅ Can start clubs
- ✅ Can invite friends
- ✅ Can use chat and SOS
- ❌ Do NOT appear in nearby walker lists (radius-based search requires coordinates)

**v1.4 plan:** Integrate Nominatim/OpenStreetMap geocoding to convert village/town text to approximate coordinates.

### 8.2 Text-based area matching

Area pages match walks and clubs by city/village text (case-insensitive contains), not by coordinates. This means:
- A walk in "Madhapur" will show up for a user in "Madhapur" even if GPS coords differ slightly
- A walk in "Hyderabad" will show up for a user in "Madhapur, Hyderabad" (text contains)
- This is intentionally fuzzy — better to show extra walks than miss relevant ones

---

## 9. Analytics Tracking

Phase 17 added the `village_town_location_set` analytics event, fired when a user saves a custom (non-GPS) location. Properties:
- `hasVillage` (boolean)
- `hasTown` (boolean)

The admin community dashboard shows:
- **Village users**: count of users with `village` field set
- **Town users**: count of users with `town` field set
- **Total users**: for percentage calculation

---

## 10. Acceptance Criteria

- [x] 16 new `village_town` translation keys added to all 9 locale files
- [x] Location confirmation modal shows before saving approximate location
- [x] "What works" vs "Limited" messaging is clear
- [x] "My village/town is not listed" support copy is available
- [x] Timezone detection works and displays
- [x] Granular location fields have translated labels
- [x] "Use approximate location" option is documented
- [x] Village/town users can still use all core features (walks, clubs, invites, chat, SOS)
- [x] No exact user locations are exposed
