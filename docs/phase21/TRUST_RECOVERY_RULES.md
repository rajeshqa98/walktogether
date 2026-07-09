# WalkTogether — Trust Recovery Rules

**Phase:** 21
**Status:** Implemented (Phase 20 rules confirmed in Phase 21)

---

## 1. Overview

Trust recovery rules ensure that users can recover from mistakes and false positives, while severe confirmed abuse remains serious.

## 2. Recovery Rules

| Rule | Effect |
|------|--------|
| False positives restore trust | +10 when false positive dismissed (Phase 20), +15 when appeal approved (Phase 21) |
| Completed safe walks slowly improve trust | +1 per 4-5 star rating (Phase 20: was +2) |
| Good ratings slowly improve trust | +1 per positive rating |
| Old minor issues lose weight over time | Reports older than 30 days carry less weight |
| Severe confirmed abuse remains serious | Banned users have trustLocked = true |
| SOS events do not automatically reduce trust | SOS creates safety task but no trust penalty |
| Reports trigger review, not automatic punishment | -5 at 3+ open reports (Phase 20: was -10) |

## 3. Trust Score Changes

### Positive
| Signal | Change |
|--------|--------|
| 4-5 star walk rating | +1 |
| Selfie verification | +10 (one-time) |
| Host onboarding | +5 (one-time) |
| False positive dismissed | +10 |
| Appeal approved | +15 |

### Negative
| Signal | Change |
|--------|--------|
| 1-2 star walk rating | -3 |
| 3+ open reports | -5 |
| Admin warning | -5 |
| Admin suspension | -10 |
| Admin ban | Trust locked |

### Protections
- trustLocked prevents changes for banned users
- False positive dismissal restores trust if < 50
- SOS events do NOT penalize
- Reports trigger review (safety task), not immediate punishment

## 4. Acceptance Criteria

- [x] False positives restore trust
- [x] Completed safe walks slowly improve trust
- [x] Good ratings slowly improve trust
- [x] Severe confirmed abuse remains serious (trustLocked)
- [x] SOS events do not automatically reduce trust
- [x] Reports trigger review, not automatic punishment
- [x] Appeal approval can restore trust (+15)
