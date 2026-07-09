# WalkTogether — Trust Score Fairness Review

**Phase:** 23
**Status:** Reviewed — rules are fair, false positives protected

---

## 1. Trust Score Rules (Phase 20/21)

- Positive walks: +1 (slow improvement)
- Negative walks: -3 (gentle)
- 3+ open reports: -5 (triggers review, not harsh punishment)
- False positive dismissed: +10 restoration
- Appeal approved: +15 restoration
- SOS events: NO automatic trust penalty
- Banned users: trustLocked (frozen)

## 2. Trust Score Distribution

Tracked in monitoring API:
- 0-20, 21-40, 41-60, 61-80, 81-100 bands
- Low trust users (active users with trust < 40)
- Trust restored count (false positives + appeal approvals)

## 3. Fairness Principles

1. Positive walks improve trust slowly
2. Reports trigger review, not automatic harsh punishment
3. False positives should not damage trust
4. SOS events should not automatically penalize anyone
5. Confirmed severe abuse reduces trust strongly (trustLocked)

## 4. Acceptance Criteria

- [x] Trust score behavior is reviewed for fairness
- [x] False positives do not damage trust
- [x] Trust can recover
- [x] SOS events do not penalize
