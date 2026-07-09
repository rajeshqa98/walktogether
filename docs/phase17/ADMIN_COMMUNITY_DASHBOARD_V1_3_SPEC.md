# WalkTogether — Admin Community Dashboard v1.3 Spec

**Phase:** 17
**Status:** v1.3 metrics implemented; UI live at `/admin/community`
**API:** `GET /api/admin/community`

---

## 1. Overview

The Admin Community Dashboard v1.3 extends the Phase 16 dashboard with deeper growth, host, language, and safety metrics. The goal is to give community ops and safety ops a single page where they can answer:

- Are areas growing or stuck?
- Are hosts available and active?
- Are invites converting?
- Which languages are users choosing?
- Are village/town users being served?
- Which areas need intervention (low-density alerts, safety review)?

---

## 2. Dashboard Sections

### 2.1 Recommendation badge summary (Phase 16, retained)

5 summary cards:
- First walker areas
- Needs host
- Growing
- Active community
- Safety review

### 2.2 Host availability (Phase 17 NEW)

4 summary cards:
- **Total hosts** — all users with `isCommunityHost = true`
- **New hosts (30d)** — onboarded in last 30 days
- **Active hosts (30d)** — hosted at least one walk in last 30 days
- **Hosts needing review** — 2+ reports against them

### 2.3 Invite conversion (Phase 17 NEW)

A panel showing:
- **Created** — total invite links created
- **Visits** — total invite link visits
- **Joins** — visits that led to signup (visitor had `joinedAt` set)
- **Conv. rate** — joins / visits × 100 (1 decimal place)
- **Breakdown by target type** — chips showing `app: N`, `area: N`, `group_walk: N`, `club: N`

### 2.4 Language distribution (Phase 17 NEW)

A panel with horizontal bar charts showing:
- Each language (English, Hindi, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French)
- Bar width = percentage of total users
- Count displayed on the right

### 2.5 Village / town adoption (Phase 17 NEW)

A panel showing:
- **Village users** — users with `village` field set
- **Town users** — users with `town` field set
- **Total users** — for percentage calculation
- Helper text: "Village/town users have set a custom (non-GPS) location. They can join group walks and clubs but may not appear in nearby walker lists."

### 2.6 7-day activity trends (Phase 17 NEW)

A panel showing counts for the last 7 days:
- `group_walk_created`
- `club_created`
- `invite_link_created`
- `invite_link_visited`
- `host_onboarded`
- `no_walkers_nearby_seen`

### 2.7 Low-density alerts (Phase 17 NEW)

An amber-bordered panel showing areas that are stuck low-density:
- 1-3 users
- 0 group walks
- 0 clubs
- First walker > 14 days ago

Each alert shows:
- Area name (village, city, district, state, country)
- User count
- Days stuck

Helper text: "Areas with 1–3 users, no walks or clubs, and first walker > 14 days ago. Consider assigning a host or running a local growth campaign."

### 2.8 Areas table (Phase 16, extended)

Sortable table with columns:
- Area (village/city + district/state/country)
- Walkers (total users)
- Walks (group walks count)
- Clubs (walking clubs count)
- **Health** (Phase 17 NEW — 0-100 score badge)
- Recommendation (badge)
- Safety (green/yellow/red)
- First walker (date)

---

## 3. Community Health Score

Each area gets a health score (0-100) computed from:

| Signal | Score change |
|--------|--------------|
| Base | +20 |
| `totalUsers >= 2` | +15 |
| `totalUsers >= 5` | +15 |
| `groupWalksCount >= 1` | +15 |
| `clubsCount >= 1` | +15 |
| `recommendation === "active_community"` | +10 |
| `recommendation === "growing"` | +10 |
| `safetyConcernLevel === "red"` | -30 |
| `safetyConcernLevel === "yellow"` | -15 |

**Capped at 0-100.**

### Color coding

| Score | Color | Meaning |
|-------|-------|---------|
| 80-100 | Emerald | Healthy area |
| 60-79 | Teal | Growing well |
| 40-59 | Amber | Needs attention |
| 0-39 | Red | Stuck or unsafe |

---

## 4. API Response Shape

```json
{
  "areas": [
    {
      "areaSlug": "in|telangana|hyderabad|madhapur",
      "country": "IN",
      "stateRegion": "Telangana",
      "district": "Hyderabad",
      "city": "Hyderabad",
      "village": null,
      "walkersNearby": 12,
      "totalUsers": 12,
      "groupWalksCount": 3,
      "clubsCount": 2,
      "recommendation": "active_community",
      "safetyConcernLevel": "green",
      "firstWalkerAt": "2025-06-01T...",
      "updatedAt": "2025-07-06T...",
      "healthScore": 95
    }
  ],
  "summary": {
    "totalAreas": 45,
    "firstWalkerAreas": 12,
    "needsHostAreas": 8,
    "growingAreas": 15,
    "activeCommunityAreas": 9,
    "safetyReviewAreas": 1
  },
  "hosts": {
    "totalHosts": 23,
    "newHosts30d": 5,
    "activeHosts30d": 12,
    "hostsNeedingReview": 1
  },
  "invites": {
    "totalCreated": 156,
    "totalVisits": 423,
    "totalJoins": 89,
    "conversionRate": 21.0,
    "byTargetType": {
      "app": 78,
      "area": 34,
      "group_walk": 28,
      "club": 16
    }
  },
  "languages": {
    "en": 234,
    "hi": 56,
    "te": 12,
    "ta": 3,
    "kn": 2,
    "bn": 1,
    "es": 0,
    "ar": 0,
    "fr": 0
  },
  "villageTown": {
    "villageUsers": 18,
    "townUsers": 7,
    "totalUsers": 308
  },
  "trends7d": {
    "group_walk_created": 14,
    "club_created": 5,
    "invite_link_created": 32,
    "invite_link_visited": 87,
    "host_onboarded": 3,
    "no_walkers_nearby_seen": 145
  },
  "lowDensityAlerts": [
    {
      "areaSlug": "in|karnataka|...",
      "country": "IN",
      "stateRegion": "Karnataka",
      "district": "...",
      "city": "...",
      "village": "Some Village",
      "totalUsers": 1,
      "firstWalkerAt": "2025-06-15T...",
      "daysStuck": 21
    }
  ]
}
```

---

## 5. Refresh Strategy

- The dashboard API opportunistically refreshes area activity counters for any area that hasn't been updated in 1 hour (limited to 50 areas per request to bound work).
- 7-day trends are computed live from the `AnalyticsEvent` table.
- Host metrics are computed live per request (no caching in v1.3 — to be added if performance becomes an issue).

---

## 6. Access Control

- The dashboard page at `/admin/community` is admin-only (redirects non-admins to the user app).
- The API at `/api/admin/community` returns 401 without admin auth, 403 for non-admin authenticated users.
- All data is read-only — the dashboard does not modify any records.

---

## 7. Privacy

- **No exact locations** are exposed. Walker counts are coarse.
- **No user IDs or names** are exposed in the area list. Only aggregate counts.
- **Host phone numbers** are NOT exposed in the community dashboard (only in the dedicated `/api/admin/hosts` endpoint, also admin-only).
- **Language distribution** shows counts only, not which user picked which language.

---

## 8. Future (v1.4+)

- **Time-series charts**: show area growth over time (weekly snapshots)
- **Cohort analysis**: signup cohort retention by language / village vs city
- **Funnel visualization**: invite created → visited → joined → hosted first walk
- **Geographic heatmap**: areas colored by health score (no exact locations)
- **Export to CSV**: for offline analysis
- **Alert subscriptions**: email admins when low-density alerts cross a threshold

---

## 9. Acceptance Criteria

- [x] Dashboard shows host availability (total, new 30d, active 30d, needing review).
- [x] Dashboard shows invite conversion (created, visits, joins, conversion rate, by target type).
- [x] Dashboard shows language distribution with bar charts.
- [x] Dashboard shows village/town adoption metrics.
- [x] Dashboard shows 7-day activity trends.
- [x] Dashboard shows low-density alerts (areas stuck 14+ days).
- [x] Areas table includes community health score (0-100) with color coding.
- [x] API returns all v1.3 metrics in a single response.
- [x] Dashboard is admin-only (401/403 without admin auth).
- [x] No exact user locations or identities are exposed.
