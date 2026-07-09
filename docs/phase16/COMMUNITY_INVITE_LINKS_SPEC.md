# WalkTogether — Community Invite Links Spec

**Phase:** 16
**Status:** Implemented
**Files:** `src/lib/community.ts`, `src/app/api/invite-links/`, `src/components/ShareSheet.tsx`

---

## 1. Overview

Community invite links let any user share WalkTogether with friends, family, and community groups. Each link is tied to a specific target — the app, a local area, a group walk, or a walking club — so the recipient lands on the most relevant page.

All invite links are free. There are no premium invite tiers, no per-link fees, no usage caps beyond basic abuse prevention.

---

## 2. Target Types

| `targetType` | Use case | What the recipient sees |
|--------------|----------|------------------------|
| `app` | Generic app invite | App home (or sign-up if not authenticated) |
| `area` | Local area invite | Local area page with walks, clubs, and area CTAs |
| `group_walk` | Specific walk invite | Group walk detail page with a Join button |
| `club` | Specific club invite | Walking club detail page with a Join button |

---

## 3. URL Format

All invite links use the same pattern:

```
https://<app-origin>/?invite=wt-<8char-code>
```

Example: `https://walktogether.app/?invite=wt-7Hk2pQ4z`

The 8-character code uses an unambiguous alphabet (no `0`/`O`, no `1`/`l`) to avoid copy errors.

---

## 4. Link Resolution Flow

1. **Recipient opens the link** (in any browser, on any device).
2. **App loads** — PWA if installed, web fallback if not.
3. **Client calls** `GET /api/invite-links/<code>`.
4. **Server resolves** the link:
   - Records a visit (with rate limiting).
   - Returns `{ targetType, targetId, targetLabel, areaSlug, createdBy, message }`.
5. **Client navigates** based on `targetType`:
   - `app` → home screen (or login if unauthenticated)
   - `area` → area page (with `targetId` as the area slug)
   - `group_walk` → group walk detail (with `targetId` as the walk ID)
   - `club` → club detail (with `targetId` as the club ID)

---

## 5. Link Creation

### Who can create

- Any authenticated user can create invite links.
- For `group_walk` and `club` target types, the user must be the host/creator of that walk/club.

### Rate limits

- **Per user:** max 20 invite links per hour.
- **Per IP (visit):** max 50 visits per hour.

Beyond these limits, the API returns `429 Too Many Requests`.

### Spam protection

Optional `message` field is checked against a spam pattern list. Messages containing spam phrases (e.g. "earn money", "free recharge", bit.ly links, telegram.me links) are rejected with `422 Unprocessable Entity`.

---

## 6. Share Sheet UX

The `ShareSheet` component (`src/components/ShareSheet.tsx`) is the standard UI for creating and sharing invite links.

**Features:**
- Opens as a bottom-sheet modal.
- Calls `POST /api/invite-links` on open.
- Shows the generated URL with a copy button.
- Editable message textarea (max 500 chars).
- Native share button (uses `navigator.share` when available).
- WhatsApp share button (opens `wa.me/?text=...`).
- Privacy reminder: "Don't share publicly if your walk is women-only or verified-only — share directly with trusted contacts instead."

**Default share copy by target type:**
- `app`: "Join me on WalkTogether and let's build a walking community in our area."
- `area`: "Walking community in our area — join me on WalkTogether!"
- `group_walk`: "Come walk with us! Join this WalkTogether group walk."
- `club`: "Check out our walking club on WalkTogether — new members welcome!"

---

## 7. Database Schema

### `InviteLink` model

| Field | Type | Description |
|-------|------|-------------|
| `id` | String (cuid) | Primary key |
| `code` | String (unique) | Short shareable token, `wt-XXXXXXXX` |
| `targetType` | String | `app` \| `area` \| `group_walk` \| `club` |
| `targetId` | String? | Walk ID, club ID, or area slug (null for plain app invites) |
| `targetLabel` | String? | Human-readable label for display |
| `areaSlug` | String? | Normalized area key for analytics |
| `createdById` | String | User who created the link |
| `createdAt` | DateTime | Creation timestamp |
| `expiresAt` | DateTime? | Optional expiry |
| `visitCount` | Int | Total visits (denormalized for fast reads) |
| `joinCount` | Int | Successful joins/conversions |

### `InviteLinkVisit` model

| Field | Type | Description |
|-------|------|-------------|
| `id` | String (cuid) | Primary key |
| `inviteLinkId` | String | FK to InviteLink |
| `visitorId` | String? | User ID if signed in, null otherwise |
| `visitorIp` | String? | Hashed IP for spam detection |
| `userAgent` | String? | Browser user agent |
| `referrer` | String? | Referrer URL |
| `joinedAt` | DateTime? | When the visitor actually signed up/joined |
| `createdAt` | DateTime | Visit timestamp |

### `InviteAbuseFlag` model

| Field | Type | Description |
|-------|------|-------------|
| `id` | String (cuid) | Primary key |
| `userId` | String? | Offending user (null if IP-only) |
| `visitorIp` | String? | IP for IP-only flags |
| `reason` | String | `rapid_creation` \| `rapid_visits` \| `many_unconverted` \| `manual` |
| `count` | Int | Number of violations |
| `createdAt` | DateTime | Flag timestamp |

---

## 8. Privacy & Safety

- Invite links are **public** — anyone with the code can resolve them. This is intentional: they need to work over WhatsApp, SMS, etc.
- Links **never expose** meeting point coordinates. The recipient must join the walk to see the exact meeting point.
- Women-only and verified-only walks/clubs still require eligibility checks at join time. Sharing the link does not bypass these checks.
- Visits are logged with hashed IPs only. No precise location data is collected from visitors.
- The creator's name is shown on resolution (e.g. "Created by Priya") so recipients know who shared the link.

---

## 9. Analytics Events

| Event | Fired when | Properties |
|-------|------------|------------|
| `invite_link_created` | User creates a link | `targetType`, `areaSlug` |
| `invite_link_visited` | Someone opens a link | `targetType`, `areaSlug`, `visitorId` (if signed in) |

These events help measure:
- Which target types are most shared
- Conversion rate (visit → signup → join)
- Geographic spread (via `areaSlug`)
- Abuse patterns (rapid creation, rapid visits)

---

## 10. Mobile Deep Linking

The web URL `https://walktogether.app/?invite=wt-XXXX` is the canonical link.

**If the WalkTogether mobile app is installed:**
- Android App Links / iOS Universal Links will open the app directly.
- The app reads the `invite` query parameter and routes to the appropriate screen.

**If the app is not installed:**
- The PWA / web fallback opens in the browser.
- The user can sign up and the invite is resolved after signup.

**Mobile app routing** (Flutter, already implemented in v1.1):
- `app` → Home tab
- `area` → Area page (passing area slug)
- `group_walk` → Group walk detail (passing walk ID)
- `club` → Club detail (passing club ID)

---

## 11. Acceptance Criteria

- [x] Users can create invite links for app, area, group walk, and club targets.
- [x] Links work in browser (PWA) and in-app (mobile).
- [x] Links record visits and conversions.
- [x] Rate limits prevent abuse.
- [x] Spam phrases are blocked.
- [x] Meeting point coordinates are never exposed via invite links.
- [x] All invite features are free — no premium tier.
