# WalkTogether — Community Host Quality Report

**Phase:** 17
**Status:** Host quality monitoring live
**API:** `GET /api/admin/hosts`

---

## 1. Purpose

Community hosts are the engine of WalkTogether v1.2. They create group walks, start clubs, welcome new walkers, and set the tone for local walking communities. Phase 16 added host onboarding. Phase 17 wraps hosts in a quality monitoring layer so admins can:

- Identify active hosts worth celebrating
- Identify hosts who may need support or training
- Identify hosts who have received reports and need review
- Identify hosts whose accounts are suspended/banned
- Track host lifecycle: new → active → trusted (or → needs review → suspended)

---

## 2. Host Statuses

Each host is assigned one of 5 statuses, computed from their activity and reports:

| Status | Icon | Criteria | Admin action |
|--------|------|----------|--------------|
| `new_host` | 🆕 | Onboarded in last 30 days AND hasn't hosted any walks yet | Welcome them, suggest first walk |
| `active_host` | ✅ | Has hosted ≥1 walk, no recent reports | None — healthy |
| `trusted_host` | ⭐ | Hosted ≥5 walks, 0 reports, verified, not suspended | Celebrate (badge, feature in v1.3) |
| `needs_review` | ⚠️ | 2+ reports against them in 30 days | Manual review by safety ops |
| `suspended_host` | 🚫 | Account is `suspended` or `banned` | Already actioned — hide from active lists |

### Status priority

If a host meets multiple criteria, the higher-priority status wins:
1. `suspended_host` (highest priority — account-level action)
2. `needs_review` (safety concern)
3. `trusted_host` (positive recognition)
4. `new_host` (onboarding phase)
5. `active_host` (default healthy)

---

## 3. Per-Host Metrics

The `/api/admin/hosts` endpoint returns, for each host:

```json
{
  "userId": "ckxyz...",
  "name": "Priya Sharma",
  "phone": "+919876543210",
  "area": {
    "city": "Hyderabad",
    "neighborhood": "Hitech City",
    "village": null,
    "town": null,
    "stateRegion": "Telangana",
    "countryCode": "IN"
  },
  "verificationStatus": "verified",
  "accountStatus": "active",
  "trustScore": 78,
  "hostOnboardedAt": "2025-06-15T10:30:00Z",
  "hostStatus": "active_host",
  "metrics": {
    "totalWalksCreated": 4,
    "walksCreated30d": 2,
    "cancelledWalks": 0,
    "totalParticipants": 23,
    "repeatParticipants": 5,
    "totalReports": 0,
    "reports30d": 0
  },
  "safetyScore": 90
}
```

### Metric definitions

| Metric | Definition |
|--------|------------|
| `totalWalksCreated` | All group walks created by this host (any status) |
| `walksCreated30d` | Walks created in the last 30 days |
| `cancelledWalks` | Walks with `status === "cancelled"` |
| `totalParticipants` | Sum of joined participants across all their walks |
| `repeatParticipants` | Walkers who joined 2+ of this host's walks (loyalty signal) |
| `totalReports` | Reports filed against this host (any status) |
| `reports30d` | Reports filed against this host in the last 30 days |

---

## 4. Safety Score (0-100)

Each host gets a safety score computed from their metrics:

| Signal | Score change |
|--------|--------------|
| Base | +70 |
| Verified (`verificationStatus === "verified"`) | +10 |
| Per walk hosted | +5 (max +20) |
| Per repeat participant | +5 (max +10) |
| Per report against | -10 (max -30) |
| Suspended/banned | -20 |

**Capped at 0-100.**

### Score interpretation

| Score range | Meaning | Admin action |
|-------------|---------|--------------|
| 80-100 | Excellent host | Celebrate, consider for ambassador program |
| 60-79 | Good host | None |
| 40-59 | Watch | Monitor for declining patterns |
| 0-39 | Concern | Manual review |

---

## 5. Host Lifecycle

```
[new_host]
    │
    │ (creates first walk)
    ▼
[active_host]
    │
    │ (creates 5+ walks, 0 reports, verified)
    ▼
[trusted_host]
    │
    │ (gets 2+ reports)
    ▼
[needs_review]
    │
    │ (admin suspends)
    ▼
[suspended_host]
```

A host can also go from `active_host` → `needs_review` → back to `active_host` if the reports are dismissed.

---

## 6. Admin Dashboard Integration

### 6.1 Community Growth Dashboard (`/admin/community`)

The community dashboard shows host availability summary:
- **Total hosts** (all statuses)
- **New hosts (30d)** (recently onboarded)
- **Active hosts (30d)** (hosted a walk in 30 days)
- **Hosts needing review** (2+ reports against them)

### 6.2 Hosts Page (planned for v1.3)

A dedicated `/admin/hosts` page will show:
- Filterable list of all hosts (by status, area, safety score)
- Per-host detail view with full metrics
- Actions: warn, suspend, message host (v1.3)

In Phase 17, the data is available via API; the dedicated page is deferred.

---

## 7. Quality Signals

### 7.1 Positive signals

| Signal | Why it matters |
|--------|----------------|
| High `totalWalksCreated` | Host is actively creating walks |
| High `walksCreated30d` | Host is currently active (not just historical) |
| High `totalParticipants` | Host's walks are popular |
| High `repeatParticipants` | Walkers come back to this host's walks (loyalty) |
| `verificationStatus === "verified"` | Host has completed selfie verification |
| Low `cancelledWalks` | Host follows through on planned walks |

### 7.2 Concerning signals

| Signal | Why it matters |
|--------|----------------|
| High `reports30d` | Recent safety concerns |
| High `cancelledWalks` | Host may be unreliable |
| `accountStatus === "warned"` | Host has been warned by admin |
| `accountStatus === "suspended"` or `"banned"` | Account-level action already taken |
| Low `safetyScore` (<40) | Composite concern |

---

## 8. Privacy

- Host phone numbers are visible to admins only (never to other users).
- Host home addresses are never collected — WalkTogether only stores approximate location.
- Reports against hosts are stored in the `Report` table with `reportedUserId` = host's user ID.
- The `/api/admin/hosts` endpoint is admin-only (401 without admin auth).

---

## 9. Acceptance Criteria

- [x] `/api/admin/hosts` endpoint returns per-host metrics.
- [x] Host statuses are computed: new_host, active_host, trusted_host, needs_review, suspended_host.
- [x] Safety score (0-100) is computed per host.
- [x] Repeat participants are counted (loyalty signal).
- [x] Reports against hosts are tracked (total + 30d).
- [x] Cancelled walks are tracked.
- [x] Admin community dashboard shows host availability summary.
- [x] Endpoint is admin-only (401 without auth).
