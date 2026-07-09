# WalkTogether — Trust Score Transparency

**Phase:** 21
**Status:** Implemented

---

## 1. Overview

Trust score is explained to users without exposing the exact scoring formula. The explanation is calm, clear, and actionable.

## 2. User-Facing Explanation

> "Trust score helps the community understand reliability and safety. It considers profile verification, completed walks, ratings, safety signals, and reviewed reports. Reports trigger review, not automatic punishment. False positives can be corrected. You can appeal any restriction."

## 3. What Is Communicated

| Factor | Shown to users? | Details |
|--------|----------------|---------|
| Profile verification | ✅ High-level | "Profile verification" |
| Completed walks | ✅ High-level | "Completed walks" |
| Ratings | ✅ High-level | "Ratings" |
| Safety signals | ✅ High-level | "Safety signals" |
| Reviewed reports | ✅ High-level | "Reviewed reports" |
| Exact formula | ❌ Not shown | Internal only |
| Trust score number | ✅ Shown on walker card | Numeric (0-100) |
| How to improve | ✅ Implied | "Completed walks, ratings, verification" |
| How to appeal | ✅ Shown | "You can appeal any restriction" |

## 4. Key Principles

1. **Transparent but not formulaic** — Users know what factors matter, not the exact weights
2. **Fair and recoverable** — Trust can recover; false positives are corrected
3. **Reports trigger review** — Not automatic punishment
4. **SOS doesn't penalize** — SOS events do not automatically reduce trust
5. **Appeal available** — Users can appeal any restriction

## 5. Where Trust Score Appears

- Walker card (visible to other users)
- Walker detail sheet (visible to other users)
- Settings (self view, with explanation)
- Appeal screen (with transparency copy)

## 6. Acceptance Criteria

- [x] Trust score explanation exists in appeal screen
- [x] Explanation covers key factors without exposing formula
- [x] Users can appeal trust score decisions
- [x] False positives are correctable
- [x] Reports trigger review, not automatic punishment
