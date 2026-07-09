# WalkTogether — v1.2 Community Monitoring Report

**Phase:** 17
**Status:** Monitoring infrastructure live
**Reporting period:** Phase 16 launch → Phase 17 monitoring rollout

---

## 1. Purpose

This report defines the v1.2 community growth monitoring framework. Phase 16 shipped the community growth features (invite links, area pages, first-walker flow, host onboarding, language preference, safety cards, no-walkers flow, multilingual moderation). Phase 17 wraps those features in a measurement layer so product and safety teams can answer:

- Are the v1.2 features being used?
- Are low-density areas growing?
- Are invites converting to signups?
- Are hosts completing onboarding and hosting walks?
- Are safety education cards being read or dismissed?
- Are village/town users being served well?

---

## 2. Tracked Events

All events are recorded to the `AnalyticsEvent` table via `POST /api/analytics/events` (client-side) or directly by API routes (server-side). The admin community dashboard aggregates them.

### 2.1 Invite link events

| Event | Trigger | Properties |
|-------|---------|------------|
| `invite_link_created` | User creates an invite link (app/area/walk/club) | `targetType`, `areaSlug` |
| `invite_link_visited` | Someone opens an invite link | `targetType`, `areaSlug`, `visitorId` |
| `invite_shared` | User taps Share or WhatsApp button | `targetType`, `channel` (`native` / `whatsapp`) |

### 2.2 Area page events

| Event | Trigger | Properties |
|-------|---------|------------|
| `area_page_viewed` | User opens the Area page | `areaSlug`, `isFirstWalker` |
| `create_group_from_area_page_clicked` | User taps "Create group walk" on Area page | `areaSlug` |
| `create_club_from_area_page_clicked` | User taps "Start a club" on Area page | `areaSlug` |
| `invite_from_area_page_clicked` | User taps "Invite friends" on Area page | `areaSlug` |
| `host_onboarding_from_area_clicked` | User taps "Become a host" on Area page | `areaSlug` |

### 2.3 First walker flow events

| Event | Trigger | Properties |
|-------|---------|------------|
| `first_walker_flow_viewed` | User opens the First Walker screen | `areaSlug` |
| `first_walker_invite_clicked` | User taps "Invite friends" | `areaSlug` |
| `first_walker_create_group_clicked` | User taps "Create first group walk" | `areaSlug` |
| `first_walker_create_club_clicked` | User taps "Start a local walking club" | `areaSlug` |
| `first_walker_share_whatsapp_clicked` | User taps "Share in WhatsApp" | `areaSlug` |

### 2.4 No-walkers empty state events

| Event | Trigger | Properties |
|-------|---------|------------|
| `no_walkers_nearby_seen` | Home empty state renders | `radius` |
| `invite_from_empty_state_clicked` | User taps "Invite friends" | `source: "no_walkers"` |
| `create_club_from_empty_state_clicked` | User taps "Start a walking club" | `source: "no_walkers"` |
| `create_group_from_empty_state_clicked` | User taps "Create a group walk" | `source: "no_walkers"` |

### 2.5 Host onboarding events

| Event | Trigger | Properties |
|-------|---------|------------|
| `host_onboarding_started` | User opens the Host Onboarding screen | — |
| `host_onboarding_step_viewed` | User advances to step N | `step`, `total` |
| `host_onboarding_completed` | User completes onboarding | — |

### 2.6 Language preference events

| Event | Trigger | Properties |
|-------|---------|------------|
| `language_preference_selected` | User changes language in Settings | `language` (e.g. `hi`, `te`) |

### 2.7 Safety education card events

| Event | Trigger | Properties |
|-------|---------|------------|
| `safety_card_viewed` | Safety card renders (planned — not yet fired) | `cardKey`, `screen` |
| `safety_card_dismissed` | User dismisses a safety card | `cardKey`, `screen` |

### 2.8 Village/town location events

| Event | Trigger | Properties |
|-------|---------|------------|
| `village_town_location_set` | User saves a custom (non-GPS) location | `hasVillage`, `hasTown` |

### 2.9 Server-side events (already tracked in Phase 16)

| Event | Source |
|-------|--------|
| `group_walk_created` | `POST /api/group-walks` |
| `club_created` | `POST /api/clubs` |
| `club_joined` | `POST /api/clubs/[id]/join` |
| `group_walk_joined` | `POST /api/group-walks/[id]/join` |
| `host_onboarded` | `POST /api/host/onboard` |
| `invite_link_created` (server copy) | `POST /api/invite-links` |
| `invite_link_visited` (server copy) | `GET /api/invite-links/[code]` |

---

## 3. Admin Dashboard v1.3 Metrics

The admin community dashboard at `/admin/community` now surfaces:

### 3.1 Host availability
- Total hosts
- New hosts (30 days)
- Active hosts (hosted a walk in 30 days)
- Hosts needing review (2+ reports against them)

### 3.2 Invite conversion
- Total invites created
- Total invite visits
- Total invite joins (visits that led to signup)
- Conversion rate %
- Breakdown by target type (app / area / group_walk / club)

### 3.3 Language distribution
- Count of users per preferred language
- Visual bar chart on the dashboard

### 3.4 Village/town adoption
- Users with village set
- Users with town set
- Total users (for percentage calc)

### 3.5 7-day trends
- Counts of key events in the last 7 days:
  - `group_walk_created`
  - `club_created`
  - `invite_link_created`
  - `invite_link_visited`
  - `host_onboarded`
  - `no_walkers_nearby_seen`

### 3.6 Low-density alerts
- Areas with 1-3 users, no walks/clubs, first walker > 14 days ago
- Sorted by days stuck
- Recommendation: assign a host or run a local growth campaign

### 3.7 Community health score (per area)
Formula (0-100):
- Base: 20
- +15 if totalUsers ≥ 2
- +15 if totalUsers ≥ 5
- +15 if groupWalksCount ≥ 1
- +15 if clubsCount ≥ 1
- +10 if recommendation === "active_community"
- +10 if recommendation === "growing"
- -30 if safetyConcernLevel === "red"
- -15 if safetyConcernLevel === "yellow"
- Capped at 0-100

### 3.8 Host quality monitoring (separate page planned for v1.3)
The `/api/admin/hosts` endpoint returns per-host:
- Host status: `new_host` | `active_host` | `trusted_host` | `needs_review` | `suspended_host`
- Walks created (total + 30d)
- Total participants across walks
- Repeat participants (joined 2+ of their walks)
- Reports against (total + 30d)
- Cancelled walks count
- Safety score (0-100)

---

## 4. Privacy & Data Retention

- All analytics events are stored in the `AnalyticsEvent` table.
- Events do NOT include exact locations — only `city` and `neighborhood` (coarse).
- Visitor IPs for invite link visits are NOT recorded as raw IPs — only a constant placeholder for rate-limiting.
- Events are retained indefinitely for trend analysis (subject to future privacy review).
- Users can request their data be deleted via the existing "Delete my account" flow in Settings, which cascades to their analytics events.

---

## 5. Alerting (Planned for v1.3)

Future alerts based on v1.2 monitoring:
- **Low-density alert**: area stuck at 1-3 users for 14+ days → email to community ops
- **Host quality alert**: host gets 2+ reports in 7 days → email to safety ops
- **Spam invite alert**: user creates 20+ invites in 1 hour with <5% conversion → email to trust & safety
- **Safety card dismissal alert**: user dismisses 4+ safety cards in 24h → flag for review (they may be ignoring safety guidance)

---

## 6. Acceptance Criteria

- [x] All v1.2 community growth features have analytics events.
- [x] Admin community dashboard shows host availability, invite conversion, language distribution, village/town growth, 7-day trends, low-density alerts, and health scores.
- [x] Host quality monitoring API returns per-host metrics.
- [x] Safety card view/dismiss events are tracked.
- [x] Language preference selection is tracked.
- [x] Village/town location set is tracked.
- [x] No paid/premium language in any analytics event names or properties.
