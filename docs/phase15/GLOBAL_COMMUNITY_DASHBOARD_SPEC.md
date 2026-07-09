# WalkTogether — Global Community Dashboard Spec

**Purpose:** Admin dashboard for monitoring global free launch community health by approximate area.

---

## Dashboard Location
`/admin/community` (new admin page)

---

## Dashboard Sections

### 1. Global Community Overview
| Card | Metric |
|------|--------|
| Total users | All-time count |
| Active users (24h) | LastActiveAt in last 24h |
| New signups (7d) | Created in last 7 days |
| Countries with users | Distinct countries from User.city |
| Areas (cities/towns/villages) | Distinct city values |
| Walks completed (7d) | WalkSession status=ended |
| Group walks active | GroupWalk status in [scheduled, active] |
| Walking clubs active | WalkingClub status=active |
| Reports (7d) | Report count |
| SOS events (7d) | SafetyEvent count |
| Community hosts | Users who have hosted ≥1 group walk |
| No-walker areas | Areas with >20 searches and 0 walkers found |

### 2. Area Health Table (by country → state → city/town/village)

| Column | Description |
|--------|-------------|
| Area | City/Town/Village name |
| Country | Country name |
| Users | Total users in area |
| Active (7d) | Users active in last 7 days |
| New (7d) | New signups in last 7 days |
| Walks | Completed walks in last 30 days |
| Group walks | Active group walks |
| Clubs | Active walking clubs |
| Hosts | Verified users who have hosted |
| Reports (7d) | Report count |
| SOS (7d) | SOS count |
| No-walker searches (7d) | Searches returning 0 results |
| Badge | 🌱/🌿/🌳/🌲/🏔️ (growth stage) |
| Safety | Green/Yellow/Red |
| Recommendation | Growing/Needs Walkers/Needs Host/Safety Review/Healthy |

### 3. Emerging Communities

Show areas with growth signals:
- First-ever signup (new area)
- First group walk created
- First walking club created
- >5 new signups in 7 days
- High invite/share activity

| Column | Description |
|--------|-------------|
| Area | City/Town/Village |
| Country | Country |
| Signal | "First signup" / "First group walk" / "Growing fast" / "High invites" |
| Users | Current user count |
| Action | "Welcome" / "Create group walk" / "Recruit host" / "Monitor" |

### 4. Low-Density Areas (Needs Growth Support)

Show areas where users consistently find no walkers:
- No-walker rate >80%
- >5 users but 0 group walks
- >10 users but 0 verified hosts

| Column | Description |
|--------|-------------|
| Area | City/Town/Village |
| Users | User count |
| No-walker searches (7d) | Count |
| No-walker rate | % |
| Group walks | 0 |
| Hosts | 0 |
| Action | "Create group walk" / "Send growth tips" / "Recruit host" |

### 5. Safety by Area

| Column | Description |
|--------|-------------|
| Area | City/Town/Village |
| Reports (7d) | Count |
| Report rate | Reports / active users |
| SOS (7d) | Count |
| Safety status | Green/Yellow/Red |
| Action | "Review reports" / "Pause area" / "Set yellow" |

### 6. Host Availability

| Column | Description |
|--------|-------------|
| Area | City/Town/Village |
| Users | Count |
| Verified users | Count |
| Potential hosts (trust≥60, 3+ walks) | Count |
| Active hosts (created group walk) | Count |
| Action | "Invite to host" / "Create admin walk" |

---

## API Requirements

### New Endpoint: `GET /api/admin/community/dashboard`

Returns:
```json
{
  "global": { "totalUsers": 1234, "active24h": 89, ... },
  "areas": [
    { "area": "Hyderabad", "country": "India", "users": 145, "active7d": 40, "walks30d": 30, ... }
  ],
  "emerging": [
    { "area": "Kothapally", "country": "India", "signal": "First signup", "users": 1 }
  ],
  "lowDensity": [
    { "area": "Sydney", "country": "Australia", "users": 3, "noWalkerSearches7d": 25, ... }
  ],
  "safetyByArea": [
    { "area": "Delhi", "country": "India", "reports7d": 3, "reportRate": 37.5, "safetyStatus": "yellow" }
  ],
  "hostAvailability": [
    { "area": "Bangalore", "country": "India", "users": 98, "verifiedUsers": 45, "potentialHosts": 12, "activeHosts": 3 }
  ]
}
```

### Data Sources
- User table (group by city, country)
- AnalyticsEvent (group by city for search/no-walker events)
- GroupWalk (group by city)
- WalkingClub (group by city)
- Report (group by reported user's city)
- SafetyEvent (group by reporter's city)

---

## Recommendation Badge Logic

| Badge | Condition |
|-------|-----------|
| 🌱 Growing | New signups >3 in 7d AND no-walker rate <80% |
| 🚶 Needs Walkers | No-walker rate >80% AND <10 total users |
| 🏠 Needs Host | >10 users BUT 0 group walks AND 0 clubs |
| ⚠️ Safety Review | Report rate >10% OR >2 SOS in 7d |
| ✅ Healthy | >20 users, >5 walks completed, report rate <5% |
