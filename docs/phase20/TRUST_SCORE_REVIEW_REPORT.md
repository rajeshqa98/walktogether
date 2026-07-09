# WalkTogether — Trust Score Review Report

**Phase:** 20
**Status:** Trust score rules updated for fairness

---

## 1. Overview

Phase 20 reviews and updates trust score rules to be fairer and more transparent. The key principle: reports should trigger review, not immediate harsh punishment. False positives should not damage trust.

---

## 2. Trust Score Rules (Phase 20)

### 2.1 Positive signals

| Signal | Trust change | Notes |
|--------|-------------|-------|
| Walk completed with 4-5 star rating | +1 | Was +2 (Phase 20: slower improvement) |
| Walk completed with 3 star rating | 0 | No change |
| Selfie verification | +10 (one-time) | Unchanged |
| Host onboarding completed | +5 (one-time) | Unchanged |

### 2.2 Negative signals

| Signal | Trust change | Notes |
|--------|-------------|-------|
| Walk completed with 1-2 star rating | -3 | Was -5 (Phase 20: gentler) |
| 3+ open reports against user | -5 | Was -10 (Phase 20: gentler) |
| Admin warns user | -5 | Unchanged |
| Admin suspends user | -10 | Unchanged |
| Admin bans user | Trust locked | Unchanged |

### 2.3 Restoration

| Signal | Trust change | Notes |
|--------|-------------|-------|
| False positive dismissal | +10 | Phase 20: NEW |
| Admin restores user | +5 | Unchanged |

### 2.4 Protections

- `trustLocked` — banned users' trust is frozen
- False positive dismissal restores trust if < 50
- SOS events do NOT automatically penalize anyone
- Reports trigger review (safety task), not immediate punishment

---

## 3. Trust Score Distribution

The effectiveness API (`GET /api/admin/safety-effectiveness`) returns trust score distribution:

| Band | Count | Notes |
|------|-------|-------|
| 0-20 | tracked | Very low trust — review needed |
| 21-40 | tracked | Low trust — monitor |
| 41-60 | tracked | Medium trust — default starting range |
| 61-80 | tracked | Good trust |
| 81-100 | tracked | High trust — eligible for trusted host |

Also tracked:
- `lowTrustUsers` — active users with trust < 40

---

## 4. Key Changes from Phase 19

| Rule | Phase 19 | Phase 20 | Rationale |
|------|----------|----------|-----------|
| Report trust reduction | -10 | -5 | Reports should trigger review, not harsh punishment |
| Positive rating trust gain | +2 | +1 | Prevent trust inflation |
| Negative rating trust reduction | -5 | -3 | Gentler for poor (but not abusive) walks |
| False positive restoration | None | +10 | False positives should not damage trust |
| trustLocked check | Not checked | Checked before update | Banned users' trust is frozen |

---

## 5. Acceptance Criteria

- [x] Positive walks improve trust slowly (+1, was +2)
- [x] Reports trigger review, not immediate harsh punishment (-5, was -10)
- [x] False positives do not damage trust (+10 restoration)
- [x] SOS events do not automatically penalize anyone
- [x] Admin-confirmed severe abuse reduces trust strongly (ban → trust locked)
- [x] Trust score distribution is tracked in effectiveness API
- [x] trustLocked is checked before any trust score update
