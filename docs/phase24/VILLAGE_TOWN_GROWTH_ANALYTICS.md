# WalkTogether — Village/Town Growth Analytics

**Phase:** 24
**Status:** Implemented

---

## 1. Overview

Analytics for non-metro communities (villages, towns, small cities).

## 2. API

`GET /api/admin/village-growth`

## 3. Metrics Tracked

- Total village/town areas
- Total village/town users
- Active local hosts
- Invite links from village users
- Emerging villages (first walker in last 30 days)
- Villages needing host support
- Villages with safety concerns
- First walker villages
- Growing villages
- Language preference by village/town

## 4. Privacy

- No exact user coordinates exposed
- Area slugs use text (village/town/city/district/state/country)
- Walker counts are coarse

## 5. Acceptance Criteria

- [x] Village/town growth analytics are measurable
- [x] Emerging villages are identified
- [x] Villages needing support are visible
