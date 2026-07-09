# WalkTogether — Village / Town Adoption Review

**Phase:** 17
**Status:** Improved flows shipped; monitoring live

---

## 1. Why This Matters

WalkTogether's Phase 15 launch made the app globally free and open. Phase 16 added community growth features. But the bulk of global walking communities are not in dense cities — they are in villages, towns, and semi-urban areas where:

- GPS may be inaccurate or unavailable
- Village names may not exist in geocoding databases
- Users may share a single phone or use low-end devices
- WhatsApp is the primary communication channel, not SMS or email
- Local languages (Hindi, Telugu, Tamil, Kannada, Bengali) matter more than English

Phase 17 reviews how well v1.2 serves these users and adds targeted improvements.

---

## 2. What v1.2 Already Did for Village/Town Users

Phase 16 shipped:
- **Granular location fields**: `village`, `town`, `district`, `stateRegion`, `countryCode`, `timezone`, `landmark`
- **Custom location entry**: free-text village/town input with `(0, 0)` approximate coordinates
- **Clear "approximate location" message**: "If exact geocoding is unavailable, we'll use your text as an approximate location. You can still join group walks, clubs, and invite friends — you just may not appear in nearby walker lists."
- **Area page** works for custom locations — matches by city/village text, not coordinates
- **First walker flow** encourages village/town users to invite friends and start clubs
- **Multilingual moderation** covers Hindi, Telugu, Tamil (Phase 16) + Kannada, Bengali (Phase 17)

---

## 3. Phase 17 Improvements

### 3.1 Location confirmation modal

**Before (Phase 16):** Clicking "Use '<text>' as my location" immediately saved the location with no confirmation. Users could be surprised that they won't appear in nearby walker lists.

**After (Phase 17):** Clicking the button opens a confirmation modal:

> **Confirm your location**
>
> We couldn't find "<text>" in our city list. We'll save it as your approximate location.
>
> **What works:** Joining group walks, starting clubs, inviting friends, chat, SOS.
> **Limited:** You may not appear in nearby walker lists because we don't have your exact coordinates.
>
> [Cancel] [Confirm]

This sets clear expectations before the user commits.

### 3.2 Improved WhatsApp share copy

**Before (Phase 16):** "Join me on WalkTogether and let's build a walking community in our area."

**After (Phase 17):**
> 🚶 WalkTogether — let's build a walking community in our area!
>
> It's free, safe, and works in villages, towns, and cities. We can find walking partners, join group walks, and start a local walking club together.
>
> Join me: <link>

The new copy:
- Explicitly mentions "villages, towns, and cities" so village/town users feel included.
- Lists concrete benefits (walking partners, group walks, walking club).
- Uses an emoji (🚶) for higher WhatsApp open rates.

### 3.3 First local club guidance

The First Walker screen now has clearer guidance for starting the first walking club in a low-density area:
- Action row: "Start a local walking club" with description "Morning, evening, women-only, senior — pick your type."
- Closing message: "WalkTogether is free, everywhere. Villages, towns, and cities are all welcome."

### 3.4 First local group walk guidance

The First Walker screen's "Create first group walk" action row now reads:
- Title: "Create first group walk"
- Description: "Pick a public place, set a time, and welcome new walkers."

This is the same as Phase 16 but is now backed by Phase 17 analytics so we can measure how many village/town users actually complete this flow.

### 3.5 Area invite link for village/town

The Area page ShareSheet works for village/town areas. When a village/town user shares their area invite link, the recipient sees the area page with that village's group walks and clubs (if any).

### 3.6 Analytics tracking

New event: `village_town_location_set` fires when a user saves a custom (non-GPS) location. Properties: `hasVillage`, `hasTown`.

Admin dashboard shows:
- **Village users**: count of users with `village` field set
- **Town users**: count of users with `town` field set
- **Total users**: for percentage calculation

---

## 4. Known Limitations (v1.2 + v1.3 backlog)

### 4.1 No geocoding API integration

Village/town entries are stored with `(0, 0)` coordinates. This means:
- Village/town users don't appear in nearby walker lists (radius-based search).
- They can still join group walks and clubs (matched by text).
- They can still invite friends and use all safety features.

**v1.3 plan:** Integrate a free geocoding API (Nominatim/OpenStreetMap) to convert village/town text to approximate coordinates. This will let village/town users appear in nearby walker lists with a coarse distance label like "within 5km".

### 4.2 No village-level area pages with SEO

The current Area page is a client-side screen, not a statically-rendered page. Village/town users can't share a URL like `walktogether.app/area/madhapur-hyderabad` that search engines can index.

**v1.3 plan:** Generate static area pages with SEO metadata so village/town searches on Google can find WalkTogether area pages.

### 4.3 No local area leaderboards

Village/town users have no way to see "most active walkers in their area" — and we don't want to expose this anyway because it could leak exact locations.

**v1.3 plan:** Local area leaderboards that show only coarse counts (e.g. "Top 3 most active clubs in your area") without exposing individual user identities or locations.

### 4.4 No offline mode

Village/town users on low-end devices with poor connectivity may struggle to use the app.

**v1.3 plan:** Cache nearby walkers and active group walks for offline viewing. Sync when connectivity returns.

---

## 5. Metrics to Watch

The admin community dashboard now shows:

| Metric | What it tells us |
|--------|------------------|
| Village users (count) | How many users have set a custom village location |
| Town users (count) | How many users have set a custom town location |
| `village_town_location_set` events (7d) | How many users are completing the custom location flow |
| `first_walker_flow_viewed` events (7d) | How many village/town users are seeing the first-walker flow |
| `first_walker_create_club_clicked` events (7d) | How many village/town users are starting clubs |
| Low-density alerts | Areas stuck at 1-3 users for 14+ days — likely villages/towns needing growth support |

**Target for v1.3:** Village/town users should make up ≥ 20% of new signups in low-density regions (India tier-2/3 cities, rural areas globally).

---

## 6. Acceptance Criteria

- [x] Custom village/town entry works from LocationPermission screen.
- [x] Confirmation modal shows before saving approximate location.
- [x] WhatsApp share copy explicitly mentions villages, towns, and cities.
- [x] First walker flow guides village/town users to start a club and create a walk.
- [x] Area invite links work for village/town areas.
- [x] Analytics tracks village/town location set events.
- [x] Admin dashboard shows village/town adoption metrics.
- [x] Area page does not expose exact user locations.
