# WalkTogether — Global City Health Dashboard Spec

**Purpose:** Define the requirements for the admin dashboard that monitors global launch health by country and city.

---

## Dashboard Location
`/admin/launch` (new admin page, visible only to admins)

---

## Dashboard Sections

### 1. Global Overview Cards
| Card | Metric | Source |
|------|--------|--------|
| Active countries | Count of CountryActivation where status=active | DB |
| Active cities | Count of CityActivation where status=active | DB |
| Total users (30d) | Count of users created in last 30 days | DB |
| Active users today | Count of users active in last 24h | DB |
| Walks completed (30d) | Count of WalkSession where status=ended | DB |
| Waitlist (global) | Count of WaitlistEntry where status=pending | DB |
| Reports (7d) | Count of Report created in last 7 days | DB |
| SOS events (7d) | Count of SafetyEvent where type=sos_triggered | DB |
| Crash-free rate | From Firebase Crashlytics | External |
| OTP success rate | From server logs | Logs |

### 2. Country-Wise Health Table

| Column | Description | Color Logic |
|--------|-------------|-------------|
| Country | Country name + flag | — |
| Status | Active / Paused / Waitlist | Green / Yellow / Gray |
| Cities active | Count of active cities | — |
| Users (30d) | Total users | — |
| Active users (24h) | Daily active | — |
| Walks (30d) | Completed walks | — |
| Reports (7d) | Report count | Red if >5 |
| SOS (7d) | SOS count | Red if >2 |
| Safety status | Green / Yellow / Red | Based on report rate |
| Crash rate | % crash-free sessions | Red if <97% |
| OTP rate | % successful OTP | Red if <90% |
| Actions | Activate / Pause / View details | — |

### 3. City-Wise Health Table

| Column | Description | Color Logic |
|--------|-------------|-------------|
| City | City name | — |
| Country | Country flag | — |
| Status | Active / Paused / Waitlist / Coming soon | Green / Yellow / Gray / Blue |
| Users | Total users in city | — |
| Active (24h) | Daily active | — |
| Walks (30d) | Completed walks | — |
| Group walks | Active group walks | — |
| Reports (7d) | Report count | Red if report rate >10% |
| SOS (7d) | SOS count | Red if >1 |
| Safety | Green / Yellow / Red | Based on metrics |
| Crash rate | % crash-free | Red if <97% |
| Waitlist | Waitlist count for city | — |
| Actions | Pause / Resume / View city detail | — |

### 4. Waitlist Demand Map

| Column | Description |
|--------|-------------|
| Country | Country name |
| City | City name |
| Waitlist count | Number of pending waitlist entries |
| Host interest | Count interested in hosting |
| Women-only interest | Count interested in women-only |
| Community interest | Count interested in community groups |
| Top walk time | Most common preferredWalkTime |
| Recommendation | "Activate" (if ≥15) / "Wait" (if <15) |

### 5. OTP Health by Country

| Column | Description |
|--------|-------------|
| Country | Country name |
| OTP requests (7d) | Count of OTP requests |
| OTP success rate | % verified successfully |
| Avg delivery time | Seconds from request to verification |
| Failed attempts | Count of failed verifications |
| Status | ✅ Green (>95%) / ⚠️ Yellow (90-95%) / 🔴 Red (<90%) |

### 6. Push Notification Health

| Column | Description |
|--------|-------------|
| Platform | Android / Web / iOS (when available) |
| Sent (7d) | Count of push notifications sent |
| Delivered (7d) | Count successfully delivered |
| Delivery rate | % delivered |
| Avg latency | Seconds from send to delivery |
| Failed | Count of failed deliveries |
| Status | ✅ Green (>95%) / ⚠️ Yellow (90-95%) / 🔴 Red (<90%) |

### 7. Support Volume by Category

| Column | Description |
|--------|-------------|
| Category | Login/OTP, Location, No walkers, Privacy, Safety, etc. |
| Count (7d) | Number of support tickets |
| Avg response time | Hours |
| Trend | ↑ increasing / ↓ decreasing / → stable |
| Status | ✅ Within SLA / ⚠️ Slow / 🔴 Backlog |

### 8. Active Incidents

| Column | Description |
|--------|-------------|
| Incident # | ID |
| Severity | P0 / P1 / P2 / P3 |
| Title | Short description |
| Affected | Country/city |
| Status | Open / Monitoring / Resolved |
| Opened | Date/time |
| Owner | Admin assigned |

### 9. Funnel by Country (selectable)

Dropdown to select a country, then show:
- Signup funnel (waitlist → invite → OTP → profile → location → search)
- Walking funnel (search → view → request → accept → walk → complete → rate)
- Group funnel (view → join → chat → start → complete)

Each step shows count + conversion % from previous step.

### 10. Safety Trends Chart

Line chart showing over 30 days:
- Daily report count
- Daily SOS count
- Daily block count
- Daily new users (for context)

Filterable by: All countries / specific country / specific city.

---

## API Requirements

### New Endpoint: `GET /api/admin/launch/health`
Returns all data needed for the dashboard in a single call:

```json
{
  "global": {
    "activeCountries": 6,
    "activeCities": 11,
    "totalUsers30d": 583,
    "activeUsers24h": 55,
    "walksCompleted30d": 32,
    "waitlistGlobal": 890,
    "reports7d": 4,
    "sosEvents7d": 2,
    "crashFreeRate": 99.0,
    "otpSuccessRate": 96.0
  },
  "countries": [
    {
      "countryCode": "IN",
      "countryName": "India",
      "status": "active",
      "citiesActive": 5,
      "users30d": 408,
      "activeUsers24h": 40,
      "walks30d": 30,
      "reports7d": 3,
      "sos7d": 2,
      "safetyStatus": "green",
      "crashRate": 1.0,
      "otpRate": 96.0
    }
  ],
  "cities": [
    {
      "cityName": "Hyderabad",
      "country": "IN",
      "status": "active",
      "users": 145,
      "active24h": 22,
      "walks30d": 12,
      "groupWalks": 4,
      "reports7d": 1,
      "sos7d": 1,
      "safetyStatus": "green",
      "crashRate": 1.0,
      "waitlist": 45
    }
  ],
  "waitlistDemand": [
    {
      "country": "IN",
      "city": "Chennai",
      "waitlistCount": 28,
      "hostInterest": 3,
      "womenOnlyInterest": 8,
      "communityInterest": 5,
      "topWalkTime": "morning",
      "recommendation": "activate"
    }
  ],
  "incidents": [
    {
      "id": "inc_001",
      "severity": "P0",
      "title": "Delhi SOS — real safety concern",
      "affected": "Delhi, IN",
      "status": "monitoring",
      "openedAt": "2025-07-05T..."
    }
  ]
}
```

### Data Sources
- **Prisma DB:** Users, WalkSession, Report, SafetyEvent, WaitlistEntry, CountryActivation, CityActivation, AnalyticsEvent
- **Server logs:** OTP success/failure rates, push delivery stats
- **Firebase Crashlytics:** Crash-free session rate (via API or manual input)
- **FCM:** Push delivery stats (via Firebase Admin SDK)

---

## Dashboard UI Requirements

- **Theme:** Dark (matches existing admin panel — zinc-950 background)
- **Layout:** Responsive grid — cards on top, tables below
- **Color coding:** Green (healthy), Yellow (monitor), Red (action needed), Gray (inactive)
- **Filters:** By country, by city, by date range (7d / 30d)
- **Auto-refresh:** Every 60 seconds
- **Export:** CSV export for each table
- **Mobile responsive:** Admin can view on mobile (tables become cards)

---

## Implementation Priority
1. **Phase 13a (immediate):** API endpoint + basic table views (country + city health)
2. **Phase 13b (next sprint):** Charts (safety trends, funnel by country)
3. **Phase 13c (v1.2):** Real-time updates via WebSocket, automated alerts
