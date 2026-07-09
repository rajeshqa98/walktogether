# WalkTogether — Appeal Timeline + SLA Spec

**Phase:** 24
**Status:** Implemented

---

## 1. Overview

Appeal lifecycle tracking with SLA due dates, overdue badges, and aging buckets.

## 2. SLA Targets

| Action type | SLA |
|-------------|-----|
| account_ban | 72 hours |
| account_suspension | 48 hours |
| host_suspension | 72 hours |
| trust_score_review | 5 days (120h) |
| message_moderation | 72 hours |
| General (default) | 5 days (120h) |

## 3. AppealTimeline Model

Records every status change: submitted, review_started, info_requested, user_responded, decision_made, closed.

## 4. API

`GET /api/admin/appeal-sla` — returns open appeals with SLA info, overdue badges, aging buckets, summary by action type/language/country.

## 5. Aging Buckets

0-24h, 24-48h, 48-72h, 72-120h, 120h+

## 6. Acceptance Criteria

- [x] Appeal timeline events are created
- [x] SLA due dates are computed per action type
- [x] Overdue appeals are flagged
- [x] Aging buckets are tracked
