# WalkTogether — Safety Automation Effectiveness Report

**Phase:** 20
**Status:** Monitoring infrastructure live; effectiveness metrics available via API

---

## 1. Overview

Phase 19 introduced 10 automated safety signal types. Phase 20 adds monitoring to measure their effectiveness, track false positives, and ensure the automation is reducing admin burden without unfairly penalizing users.

---

## 2. Signal Types and Expected Behavior

| Signal Type | Severity | Expected FP Rate | Auto-Action |
|-------------|----------|-----------------|-------------|
| repeated_reports | high | Low — 2+ reports in 7d is a strong signal | Creates safety task |
| repeated_blocks | medium | Low — 3+ blocks in 7d is strong | Creates safety task |
| unsafe_words | medium | Medium — may catch casual language | Creates safety task |
| home_address_request | high | Low — regex-based, specific patterns | Creates safety task |
| private_meeting_request | high | Low — regex-based, specific patterns | Creates safety task |
| high_report_rate_group | high | Medium — may be coordinated reports | Creates safety task |
| sos_during_walk | high | Very low — SOS is user-initiated | Creates safety task |
| host_repeated_reports | high | Low — 2+ reports against host in 30d | Creates safety task |
| rapid_join_leave | low | High — may be legitimate browsing | Creates safety task (low priority) |
| spam_invite | medium | Medium — may be enthusiastic sharing | Creates safety task |

---

## 3. Effectiveness Metrics

### 3.1 API endpoint

`GET /api/admin/safety-effectiveness` returns:

```json
{
  "signalCounts": { "repeated_reports": 5, "spam_invite": 3, ... },
  "totalSignals": 15,
  "tasksByStatus": { "open": 8, "resolved": 5, "dismissed": 2 },
  "tasksByType": { "repeated_reports": 5, "suspicious_invite": 3, ... },
  "outcomes": { "true_positive": 3, "false_positive": 2, "unclassified": 2 },
  "fpRateBySignalType": {
    "repeated_reports": { "total": 5, "falsePositives": 1, "rate": 20.0 },
    "spam_invite": { "total": 3, "falsePositives": 1, "rate": 33.3 }
  },
  "overallFpRate": 20.0,
  "avgResolutionHours": 4.5,
  "resolvedCount": 7,
  "repeatedOffenderCount": 2,
  "adminActionCounts": { "safety_task_resolve": 3, "safety_task_dismiss": 2, ... },
  "trustDistribution": { "0-20": 1, "21-40": 3, "41-60": 10, "61-80": 25, "81-100": 15 },
  "lowTrustUsers": 4,
  "totalHosts": 8,
  "hostsNeedingReview": 1
}
```

### 3.2 Key metrics to monitor

1. **Overall false positive rate** — target < 25%
2. **Average resolution time** — target < 24 hours
3. **Repeated offender rate** — users with 2+ safety tasks
4. **Urgent task backlog** — open urgent tasks should be 0
5. **Unclassified resolved tasks** — should trend to 0 over time

---

## 4. False Positive Handling

### 4.1 Classification process

Admins classify each resolved/dismissed task with one of:
- `true_positive` — signal was correct
- `false_positive` — signal was incorrect
- `needs_more_context` — requires more investigation
- `duplicate` — duplicate of another task
- `user_misunderstanding` — user didn't understand the feature
- `language_moderation_issue` — moderation incorrectly flagged text

### 4.2 False positive trust restoration

When a task is dismissed as `false_positive`:
- If the user's trust score was reduced (< 50), restore by +10
- The restoration is logged in the audit trail
- The user is not notified (to avoid confusion)

### 4.3 False positive tracking by dimension

The effectiveness API tracks false positives by:
- Signal type (which signals are most error-prone)
- Overall rate (is the system improving over time)

Future v1.5: Track by language, area, user type, group walk vs 1:1, host vs participant.

---

## 5. Admin Action Outcomes

Every admin action on a safety task is tracked:

| Action | Description | Auto-outcome |
|--------|-------------|-------------|
| mark_reviewing | Admin starts reviewing | None |
| resolve | Admin resolves the task | Sets outcome if provided |
| dismiss | Admin dismisses the task | Sets outcome if provided |
| warn_user | User is warned | true_positive |
| suspend_user | User is suspended | true_positive |
| ban_user | User is banned | true_positive |
| suspend_host | Host ability removed | true_positive |
| cancel_group_walk | Group walk cancelled | true_positive |
| add_note | Internal note added | None |
| classify | Classify outcome only | Sets outcome |

---

## 6. Acceptance Criteria

- [x] Safety automation effectiveness API exists
- [x] Signal counts by type are tracked
- [x] Task counts by status/type are tracked
- [x] Outcome distribution is tracked
- [x] False positive rate by signal type is tracked
- [x] Average resolution time is tracked
- [x] Repeated offender count is tracked
- [x] Admin action outcomes are tracked
- [x] Trust score distribution is tracked
- [x] Host quality summary is tracked
