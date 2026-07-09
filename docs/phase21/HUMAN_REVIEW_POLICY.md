# WalkTogether — Human Review Policy

**Phase:** 21
**Status:** Implemented

---

## 1. Overview

Safety automation never feels unfair. Automation creates tasks for review, not final punishment. Every serious action requires admin review.

## 2. Core Rules

1. **Automation creates tasks, not final punishment** — Signals create SafetyTasks, not bans
2. **Admin reviews serious actions** — Warn/suspend/ban require admin action
3. **False positives can be marked** — 6 outcome types including `false_positive`
4. **Trust can recover** — False positive restores +10, appeal approval restores +15
5. **Appeals are available** — Users can appeal any restriction
6. **User receives understandable explanation** — Decision templates provide clear messaging

## 3. Automation vs Human Review

| Action | Automated? | Human review? |
|--------|-----------|---------------|
| Signal detection | ✅ Automated | — |
| Safety task creation | ✅ Automated | — |
| Trust score -5 (3+ reports) | ✅ Automated | Review triggered |
| Warning user | ❌ | ✅ Required |
| Suspending user | ❌ | ✅ Required |
| Banning user | ❌ | ✅ Required |
| Canceling group walk | ❌ | ✅ Required |
| Suspending host | ❌ | ✅ Required |
| Restoring account | ❌ | ✅ Required (via appeal) |
| Restoring trust (false positive) | ❌ | ✅ Required (admin dismisses) |

## 4. Appeal Rights

Every user has the right to appeal:
- Account suspension
- Account ban
- Host ability suspension
- Group walk cancellation
- Club restriction
- Trust score review
- Message moderation flag

Appeals are reviewed by admins within a reasonable timeframe. Users receive notifications about appeal decisions.

## 5. No Auto-Ban Policy

WalkTogether does NOT auto-ban users. The only exception is if severe abuse is already defined and confirmed by an admin. All automated signals create safety tasks for human review.

## 6. Acceptance Criteria

- [x] Automation creates tasks, not final punishment
- [x] Admin reviews all serious actions
- [x] False positives can be marked and corrected
- [x] Trust can recover from mistakes
- [x] Appeals are available for all restrictions
- [x] Users receive understandable explanations
