# WalkTogether — v1.2 Community Growth Spec

**Phase:** 16
**Status:** Implemented
**Released:** Phase 16 build
**Product principle:** Free, global, safety-first. No premium tier. No monetization.

---

## 1. Purpose

v1.2 turns WalkTogether from a "find walkers near you" app into a "grow your own local walking community" app. Anyone, anywhere in the world — including villages and small towns — can now build a local walking community from scratch, even if they are the very first walker in their area.

The guiding belief: **every walking community starts with one person.** v1.2 gives that person the tools, the safety net, and the encouragement to start.

---

## 2. Design Principles

1. **Free, always.** No premium, no subscription, no paid filters. Invite links, host onboarding, area pages, club discovery — all free.
2. **Safety is mandatory, not a paid tier.** Women-only groups, verified-only groups, SOS, report/block, moderation — always on, always free.
3. **Privacy by default.** Approximate location only. Walker counts are coarse. Exact locations are shared only after a walk is accepted.
4. **Local-first.** Village, town, district, state, country — granular location is a first-class concept.
5. **Low-density friendly.** Empty states are not failures — they are invitations to start.
6. **Host-led growth.** Community hosts are the engine of v1.2. Onboarding is free and lightweight.

---

## 3. Scope — What's New in v1.2

### 3.1 Community Invite Links

Shareable links for four target types:

| Target type | URL pattern | Recipient lands on |
|-------------|-------------|--------------------|
| `app` | `/?invite=wt-XXXX` | App home (or sign-up) |
| `area` | `/?invite=wt-XXXX` | Local area page |
| `group_walk` | `/?invite=wt-XXXX` | Group walk detail |
| `club` | `/?invite=wt-XXXX` | Walking club detail |

Default share copy:
> "Join me on WalkTogether and let's build a walking community in our area."

**Implementation:**
- API: `POST /api/invite-links`, `GET /api/invite-links/[code]`
- UI: `ShareSheet` component (`src/components/ShareSheet.tsx`)
- DB: `InviteLink`, `InviteLinkVisit` Prisma models
- Rate limits: 20 invite links per user per hour, 50 visits per IP per hour

### 3.2 Local Area Community Page

A lightweight page per (country, state, district, city) tuple.

**Shows:**
- Area name (village → city → district → state → country)
- Coarse walker count (hidden if ≤3 for privacy)
- Group walks in area
- Walking clubs in area
- CTAs: create group walk, start club, invite friends, become a host
- First-walker banner if applicable

**Privacy:**
- Never exposes exact user locations
- Walker count is coarse (rounded, hidden when very small)
- No user IDs or names listed

**API:** `GET /api/area?slug=<areaSlug>` or `GET /api/area` (uses current user's location)

### 3.3 Better Free-Text Location Support

Granular location fields on User:
- `village`, `town`, `district`, `stateRegion`, `countryCode`, `timezone`, `landmark`

Manual fallback flow:
- If GPS denied or geocoding unavailable → user types village/town name
- App saves the text as approximate location with `(0, 0)` coordinates
- User sees clear message: "Your location is approximate. Group walks and clubs work without GPS."
- User can still use the app — they just may not appear in nearby walker lists

### 3.4 Local Walking Clubs Discovery

New API: `GET /api/clubs/nearby?city=&village=&type=&limit=`

Club types supported (free, all of them):
- Morning walkers
- Evening walkers
- Women walkers
- Senior walkers
- Dog walkers
- Beginner fitness
- Office walkers
- Weekend walkers (via walk type filter, not club type)

### 3.5 Host Onboarding

8-step in-app onboarding flow. Free, lightweight, no test or quiz.

**Steps:**
1. Choose public places
2. Set clear walk time
3. Describe your pace
4. Welcome new walkers
5. Use women-only / verified-only when needed
6. Remove or report unsafe participants
7. Never ask for private addresses
8. Keep group chat respectful

On completion: `User.isCommunityHost = true`, `User.hostOnboardedAt = now()`, `HostEvent` row created.

**API:** `POST /api/host/onboard`

### 3.6 First Walker Experience

Special screen shown when the user is one of the first walkers in their area.

**Title:** "You're one of the first walkers here."

**Actions:**
- Invite friends (opens ShareSheet)
- Create first group walk
- Start local walking club
- Share in WhatsApp / community groups
- Increase radius (link back to home screen)

**Closing message:** "Every walking community starts with one person."

### 3.7 Community Growth Dashboard (Admin)

New admin page at `/admin/community`.

**Shows:**
- New areas created
- Areas with first users
- Areas with no walkers nearby
- Areas where clubs were started
- Areas where group walks were created
- Areas needing host support
- Areas with safety concerns

**Recommendation badges:**
| Badge | Color | Meaning |
|-------|-------|---------|
| First walker | blue | Only 1 user — show first-walker flow |
| Needs host | amber | Multiple walkers, no walks/clubs yet |
| Growing | teal | First walk or club created |
| Active community | green | Multiple walks + clubs + recurring activity |
| Safety review | red | Recent safety concerns flagged |

### 3.8 Global Language Readiness

App is structured for 9 languages. Full translations are NOT shipped in v1.2 — only the language preference field and string-extraction scaffolding. Translations will roll out in v1.3+.

**Supported codes:**
- `en` — English
- `hi` — Hindi (हिन्दी)
- `te` — Telugu (తెలుగు)
- `ta` — Tamil (தமிழ்)
- `kn` — Kannada (ಕನ್ನಡ)
- `bn` — Bengali (বাংলা)
- `es` — Spanish (Español)
- `ar` — Arabic (العربية)
- `fr` — French (Français)

User can pick language preference in Settings. Stored on `User.language`.

### 3.9 Safety Education Cards

5 safety cards shown across the app:

1. **Meet only in public places** — Home screen, Area page
2. **Do not share your home address** — Profile setup
3. **Report or block anyone unsafe** — Chat screens
4. **Night walks? Prefer groups** — Group walk detail (evening walks)
5. **SOS does not auto-call 112/911** — SOS modal, Settings

Cards are dismissible; dismissed cards are remembered in `localStorage`.

### 3.10 Better No-Walkers Flow

Improved empty state on Home screen when no walkers are nearby.

**Shows:**
- Increase radius (link to radius selector)
- Create group walk
- Start club
- Invite friends (with ShareSheet)
- First walker in your area? (link to FirstWalker screen)
- View area page
- Safety tip

**Analytics events fired:**
- `no_walkers_nearby_seen`
- `invite_from_empty_state_clicked`
- `create_club_from_empty_state_clicked`
- `create_group_from_empty_state_clicked`

### 3.11 Community Growth Notifications

New notification types (all free):

| Type | Trigger | Recipient |
|------|---------|-----------|
| `club_joined` | Someone joins your club | Club creator |
| `group_walk_joined` | Someone joins your walk | Walk host |
| `new_walker_in_area` | New user sets same area | Existing area users (capped) |
| `new_club_nearby` | New club created in your area | Users in same area |
| `new_group_walk_nearby` | New walk created in your area | Users in same area |
| `joined_walk_reminder` | 1 hour before scheduled walk | Joined participants |

### 3.12 Moderation Improvements

Centralized in `src/lib/moderation.ts`.

**Languages covered:**
- English (high-severity slurs)
- Hindi (Devanagari + Roman)
- Hinglish (transliterated phrases)
- Telugu (transliterated)
- Tamil (transliterated)
- Spanish, Arabic, French (high-severity)

**Severity model:**
- Severity 3 → auto-block (rape, child abuse, severe slurs)
- Severity 2 → flag for admin review, message still visible
- Severity 1 → log only (not currently used)

**Repeated harassment detection:**
- 3+ flagged messages in 24h → auto-mute for review
- 5+ flagged messages in 7d → auto-mute for review

**Spam invite abuse:**
- Blocked phrases: "earn money", "free recharge", "free paytm", bit.ly links, telegram.me links, wa.me links
- Rate limit: 20 invite links per user per hour

---

## 4. Database Changes (Phase 16)

### New fields on `User`
- `village`, `town`, `district`, `stateRegion`, `countryCode`, `timezone`, `landmark`
- `language` (default `"en"`)
- `isCommunityHost` (default `false`)
- `hostOnboardedAt`

### New fields on `GroupWalk` and `WalkingClub`
- `country`, `stateRegion`, `district`, `village`

### New models
- `InviteLink` — shareable invite tokens
- `InviteLinkVisit` — visit log
- `AreaActivity` — area rollup with recommendation badge
- `HostEvent` — host lifecycle events
- `InviteAbuseFlag` — spam/abuse tracking

---

## 5. New API Endpoints

| Method | Path | Purpose |
|--------|------|---------|
| `POST` | `/api/invite-links` | Create invite link |
| `GET` | `/api/invite-links` | List user's invite links |
| `GET` | `/api/invite-links/[code]` | Resolve invite link + record visit |
| `GET` | `/api/area` | Get current user's area page |
| `GET` | `/api/area?slug=<slug>` | Get area page by slug |
| `GET` | `/api/clubs/nearby` | List nearby clubs with filters |
| `POST` | `/api/host/onboard` | Complete host onboarding |
| `GET` | `/api/admin/community` | Admin: community growth dashboard |
| `POST` | `/api/analytics/events` | Client-side analytics event |

---

## 6. New Screens

| Screen | Purpose |
|--------|---------|
| `area_page` | Local area community page |
| `host_onboarding` | 8-step host onboarding flow |
| `first_walker` | First walker in area special flow |
| `share_sheet` | (modal) Invite link share sheet |

---

## 7. Acceptance Criteria

- [x] Users can grow their own local walking community anywhere.
- [x] Villages and towns are fully supported.
- [x] Low-density areas have useful flows (first-walker, no-walkers, area page).
- [x] Community hosts are guided safely (8-step onboarding).
- [x] Invite/share flows work for app, area, group walk, and club.
- [x] Safety remains mandatory and free (women-only, verified-only, SOS, moderation).
- [x] No monetization or premium language exists anywhere.

---

## 8. Out of Scope (Explicitly Excluded)

- ❌ Payments, subscriptions, premium tiers
- ❌ Paid filters or paid safety features
- ❌ Ads or sponsored content
- ❌ Full translations (only language preference in v1.2; translations in v1.3+)
- ❌ Geocoding API integration (manual text entry with approximate coordinates in v1.2)
- ❌ Profile photo upload (deferred to v1.3)
- ❌ Walking route suggestions (deferred to v1.3)
