# WalkTogether — Moderation False-Positive Dashboard

**Phase:** 24
**Status:** Implemented

---

## 1. Overview

Admin dashboard for moderation quality tracking.

## 2. API

`GET /api/admin/moderation-fp-dashboard`

## 3. Metrics Tracked

- Total flagged messages (1:1 + group)
- Confirmed violations vs false positives
- Language-specific false positive rates
- Safety pattern false positives (home_address, private_meeting)
- Admin outcomes
- Terms needing native language review

## 4. Admin Actions (available via safety task API)

- Mark true violation
- Mark false positive
- Request native speaker review

## 5. Acceptance Criteria

- [x] Moderation false positives can be reviewed
- [x] False positive rate is tracked
- [x] Language-specific issues are visible
