# WalkTogether — False Positive Review Report

**Phase:** 20
**Status:** Classification system implemented; false positive protection active

---

## 1. Overview

Phase 20 introduces a false positive classification system for safety automation tasks. Admins can classify each task as true positive, false positive, or other outcomes. False positive dismissals restore trust score and do not penalize the user.

---

## 2. Classification System

### 2.1 Outcome types

| Outcome | Description | Trust score impact |
|---------|-------------|-------------------|
| `true_positive` | Signal was correct, action taken | None (action already taken) |
| `false_positive` | Signal was incorrect | +10 restoration if trust < 50 |
| `needs_more_context` | Requires further investigation | None |
| `duplicate` | Duplicate of another task | None |
| `user_misunderstanding` | User didn't understand the feature | None |
| `language_moderation_issue` | Moderation incorrectly flagged text | None |

### 2.2 Classification workflow

1. Admin reviews the safety task in the safety queue
2. Admin examines the user context (reports, blocks, previous actions)
3. Admin takes an action:
   - `classify` — classify without changing status
   - `resolve` with outcome — resolve and classify
   - `dismiss` with outcome — dismiss and classify
4. If dismissed as `false_positive`, trust score is restored

### 2.3 API support

```
PATCH /api/admin/safety-tasks/[id]
{
  "action": "dismiss",
  "outcome": "false_positive",
  "resolutionNotes": "User was asking for meeting point, not home address"
}
```

---

## 3. False Positive Protection

### 3.1 Trust score restoration

When a task is dismissed as `false_positive`:
- If user's trust score < 50, restore by +10
- Capped at 100
- Logged in audit trail
- User is not notified (to avoid confusion)

### 3.2 No automatic trust penalty

Phase 20 trust score rules:
- Reports trigger review, not immediate harsh punishment
- Trust reduction is -5 (was -10) when 3+ open reports
- SOS events do NOT automatically penalize anyone
- Only admin-confirmed severe abuse reduces trust strongly
- `trustLocked` prevents further changes for banned users

---

## 4. Tracking by Dimension

### 4.1 Currently tracked

- False positive rate by signal type
- Overall false positive rate
- Outcome distribution

### 4.2 Planned for v1.5

- False positive rate by language
- False positive rate by area
- False positive rate by user type (host vs participant)
- False positive rate by context (group walk vs 1:1)

---

## 5. Acceptance Criteria

- [x] Safety tasks can be classified as true/false positive
- [x] False positive dismissal does not hurt trust score
- [x] False positive dismissal restores trust score (+10 if < 50)
- [x] Classification is tracked in audit logs
- [x] Effectiveness API reports false positive rates
- [x] Safety queue API supports outcome filter
