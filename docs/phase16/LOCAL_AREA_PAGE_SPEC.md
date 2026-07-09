# WalkTogether — Local Area Page Spec

**Phase:** 16
**Status:** Implemented
**Files:** `src/app/api/area/route.ts`, `src/components/screens/AreaPage.tsx`

---

## 1. Overview

Every WalkTogether user has a Local Area Page — a lightweight, privacy-safe view of the walking community in their (country, state, district, city) tuple. The Area Page is the centerpiece of v1.2's low-density-area strategy: it shows walkers, group walks, and clubs in the area, and provides clear CTAs to start something if the area is empty.

The Area Page is also the destination for `area` invite links — when someone shares their area's invite link, the recipient lands here.

---

## 2. What the Area Page Shows

### Header
- "Your area" title
- Human-readable area label: `village, city, district, state, country`
- Share button (opens ShareSheet with `targetType="area"`)

### Hero card
- Area label
- Coarse walker count (or "first walker" message if isFirstWalker)
- Stats grid: Walkers, Walks, Clubs (coarse counts)

### CTAs (2x2 grid)
- Create group walk → `group_create` screen
- Start a club → `club_create` screen
- Invite friends → ShareSheet
- Become a host → `host_onboarding` screen

### First-walker banner (conditional)
Only shown if `isFirstWalker === true` (total area users ≤ 1):

> **You're one of the first walkers here.**
> Every walking community starts with one person. Invite 2–3 friends, create your first group walk, and start building a local walking community.

With a primary button: "Invite friends to WalkTogether"

### Group walks in this area
- Lists upcoming scheduled/active group walks in the area
- Each row: title, meeting point name, neighborhood, scheduled time, visibility badge
- Tap → group walk detail screen
- Empty state: "No group walks yet. Be the first to host one!"

### Walking clubs in this area
- Lists active clubs in the area
- Each row: name, type, member count, "Joined" badge if applicable
- Tap → club detail screen
- Empty state: "No clubs yet. Start one for your area!"

### Safety tip
Inline safety education card: "Meet only in public places."

### Privacy note
"We never show your exact location. Walker counts are approximate."

---

## 3. API

### `GET /api/area?slug=<areaSlug>`
### `GET /api/area` (uses current user's location)

**Response:**
```json
{
  "areaSlug": "in|telangana|hyderabad|madhapur",
  "label": "Madhapur, Hyderabad, Telangana, IN",
  "country": "IN",
  "stateRegion": "Telangana",
  "district": "Hyderabad",
  "city": "Hyderabad",
  "village": null,
  "walkersNearby": 12,
  "totalUsers": 12,
  "groupWalks": [ /* GroupWalk[] */ ],
  "clubs": [ /* WalkingClub[] */ ],
  "recommendation": "growing",
  "isFirstWalker": false
}
```

### Area slug normalization

Slugs are built from granular location parts:

```typescript
buildAreaSlug({
  country: "IN",
  stateRegion: "Telangana",
  district: "Hyderabad",
  city: "Hyderabad",
  village: "Madhapur"
}) // → "in|telangana|hyderabad|madhapur"
```

- All parts are lowercased and trimmed.
- Empty parts are dropped.
- Parts are joined with `|`.

---

## 4. Privacy

### Walker count disclosure rules

| Actual user count in area | Displayed count | Why |
|--------------------------|-----------------|-----|
| 0 | 0 | Empty area — show first-walker flow |
| 1 | 0 | Privacy: don't expose a single user |
| 2 | 0 | Privacy: don't expose pairs |
| 3 | 0 | Privacy: don't expose small groups |
| 4+ | actual count | Safe to display |

The `isFirstWalker` flag is `true` only when the actual count is ≤ 1. This lets the UI show the first-walker banner without exposing the exact count.

### What is NOT exposed

- ❌ User IDs
- ❌ User names
- ❌ User coordinates
- ❌ Distance to specific walkers
- ❌ Time of last activity per user

### What IS exposed

- ✅ Coarse total user count (with the disclosure rules above)
- ✅ Group walks (already public — visible in Groups tab)
- ✅ Walking clubs (already public — visible in Groups tab)
- ✅ Recommendation badge (computed server-side)
- ✅ Area label (village, city, district, state, country)

---

## 5. Recommendation Badge

The badge is computed server-side via `computeRecommendation()` in `src/lib/community.ts`:

| Inputs | Output badge |
|--------|--------------|
| `safetyConcernLevel === "red"` | `safety_review` |
| `totalUsers ≤ 1` | `first_walker` |
| `groupWalksCount === 0 && clubsCount === 0` | `needs_host` |
| `groupWalksCount ≥ 2 \|\| clubsCount ≥ 2` | `active_community` |
| otherwise | `growing` |

Badges are refreshed:
- Whenever a user updates their location (PATCH `/api/me`)
- Whenever a group walk or club is created
- Hourly by the admin dashboard (opportunistic refresh of stale areas)

---

## 6. Area Activity Rollup

The `AreaActivity` Prisma model stores the rollup. One row per `areaSlug`:

| Field | Description |
|-------|-------------|
| `areaSlug` | Unique area key |
| `country`, `stateRegion`, `district`, `city`, `village` | Parts |
| `walkersNearby` | Coarse active-presence count |
| `totalUsers` | Total users who set this area |
| `groupWalksCount` | Active walks in area |
| `clubsCount` | Active clubs in area |
| `firstWalkerAt` | When the first user set this area |
| `firstGroupWalkAt` | When the first walk was created |
| `firstClubAt` | When the first club was created |
| `recommendation` | Current badge |
| `safetyConcernLevel` | `green` / `yellow` / `red` |
| `updatedAt` | Last refresh timestamp |

---

## 7. Walk and Club Matching

Group walks and clubs are matched to an area by **text similarity** on the city or village name, not by coordinates. This is intentional:

- Custom village/town entries have no coordinates (0, 0).
- Text matching ensures users in "Madhapur" see walks and clubs in "Madhapur" even if the GPS coords are slightly different.

The query uses `mode: "insensitive"` contains matching:

```typescript
OR: [
  { city: { contains: cityOrVillage, mode: "insensitive" } },
  { village: { contains: village, mode: "insensitive" } },
  { neighborhood: { contains: cityOrVillage, mode: "insensitive" } },
]
```

This is intentionally fuzzy — it's better to show a few extra walks than to miss relevant ones.

---

## 8. Mobile (Flutter)

The Flutter app has a corresponding `AreaPageScreen` widget (already implemented in v1.1) that:
- Calls the same `GET /api/area` endpoint.
- Renders the same hero, CTAs, walk list, and club list.
- Honors the same privacy rules.

---

## 9. Acceptance Criteria

- [x] Every user can view their area page from the home screen (sparkles icon).
- [x] Area page shows group walks and clubs in the area.
- [x] Area page never exposes exact user locations.
- [x] Walker count is hidden when ≤3 for privacy.
- [x] First-walker banner is shown when the user is the only one in the area.
- [x] Area page supports invite link sharing.
- [x] Area page works for villages, towns, and cities.
