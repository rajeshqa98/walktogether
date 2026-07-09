# WalkTogether — Community Health Review Report

**Phase:** 20
**Status:** Area-level community health scoring reviewed and validated

---

## 1. Overview

Phase 20 reviews the area-level community health score to ensure it works correctly for cities, towns, and villages, and that it does not expose exact user locations.

---

## 2. Community Health Score Formula (from Phase 17)

| Signal | Score change |
|--------|-------------|
| Base | +20 |
| totalUsers >= 2 | +15 |
| totalUsers >= 5 | +15 |
| groupWalksCount >= 1 | +15 |
| clubsCount >= 1 | +15 |
| recommendation === "active_community" | +10 |
| recommendation === "growing" | +10 |
| safetyConcernLevel === "red" | -30 |
| safetyConcernLevel === "yellow" | -15 |

**Capped at 0-100.**

### 2.1 Score interpretation

| Score | Color | Meaning |
|-------|-------|---------|
| 80-100 | Emerald | Healthy area |
| 60-79 | Teal | Growing well |
| 40-59 | Amber | Needs attention |
| 0-39 | Red | Stuck or unsafe |

---

## 3. Recommendation Badges

| Badge | Criteria | Admin action |
|-------|----------|-------------|
| first_walker | totalUsers <= 1 | Show first-walker flow |
| needs_host | 2+ users, 0 walks, 0 clubs | Assign host |
| growing | First walk or club created | Monitor |
| active_community | 2+ walks or 2+ clubs | Celebrate |
| safety_review | safetyConcernLevel === "red" | Safety review |

### 3.1 Phase 20 validation

- ✅ Health score does not expose exact user locations
- ✅ Low-density areas get growth nudges (first-walker flow, invite friends)
- ✅ Safety-review areas are visible to admin dashboard
- ✅ Villages/towns are represented properly (area slug includes village/town)
- ✅ Walker counts are coarse (hidden when <= 3)

---

## 4. Area Dashboard Metrics (Phase 17-19)

The admin community dashboard at `/admin/community` shows:
- Area list with recommendation badges + health scores
- Host availability (total, new 30d, active 30d, needing review)
- Invite conversion (created, visits, joins, conversion rate)
- Language distribution
- Village/town adoption
- 7-day trends
- Low-density alerts
- Safety summary (Phase 19: open tasks, urgent, signals, SOS count)

---

## 5. Privacy Validation

- ✅ No exact user coordinates in area dashboard
- ✅ Walker counts are approximate (coarse, hidden when <= 3)
- ✅ Area slug uses text (village/town/city/district/state/country), not coordinates
- ✅ Admin sees exact data only for safety review (via safety task)
- ✅ Group walk coordinates only visible to joined participants

---

## 6. Acceptance Criteria

- [x] Health score does not expose exact user locations
- [x] Low-density areas get growth nudges
- [x] Safety-review areas are visible to admin
- [x] Villages/towns are represented properly
- [x] Health score formula is fair and transparent
- [x] Recommendation badges are correctly computed
