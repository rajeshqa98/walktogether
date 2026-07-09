# WalkTogether — Trust Score History Report

**Phase:** 24
**Status:** Implemented

---

## 1. Overview

Every trust score change is now recorded in the TrustScoreHistory table with reason, source event, and delta.

## 2. TrustScoreHistory Model

- userId, scoreBefore, scoreAfter, delta
- reason: "positive_walk" | "negative_walk" | "report" | "false_positive_restored" | "appeal_approved" | "admin_action" | "verification" | "host_onboarding"
- sourceEvent: "walk_session" | "report" | "appeal" | "safety_task" | "admin"
- sourceEntityId, adminAction

## 3. Recording Points

- Ratings API: positive_walk (+1), negative_walk (-3)
- Reports API: report (-5 at 3+ open reports)
- Future: false_positive_restored, appeal_approved, admin_action

## 4. Admin API

`GET /api/admin/trust-history?userId=<id>` — returns full history with fairness warnings (sudden drops, restorations, repeated false positives).

## 5. Fairness Warnings

- Sudden drops (delta <= -10)
- Trust restored after appeal/false positive
- Repeated false positives (2+ events)

## 6. Acceptance Criteria

- [x] Trust score history records changes
- [x] History is visible to admins
- [x] Fairness warnings are computed
- [x] Formula details are not exposed
