# WalkTogether — Host Appeal Flow

**Phase:** 21
**Status:** Implemented

---

## 1. Overview

Hosts can appeal restrictions including host ability suspension, group walk cancellation, host status downgrade, and club restriction.

## 2. Appealable Host Actions

| Action | Appeal type |
|--------|------------|
| Host ability suspension | `host_suspension` |
| Group walk cancellation | `group_walk_cancellation` |
| Host status downgrade | `trust_score_review` |
| Club restriction | `club_restriction` |

## 3. Admin Resolution Options

When reviewing a host appeal, admin can:

| Action | Effect |
|--------|--------|
| Approve + restore host ability | `isCommunityHost = true` |
| Approve + keep restriction | Appeal approved but host ability not restored |
| Reject | Restriction remains |
| Require host re-training | Mark host as `needs_review` |
| Mark trusted host | Host status upgraded |

## 4. Host Status Flow

```
new_host → active_host → trusted_host
                ↓              ↓
          needs_review ←──────┘
                ↓
          suspended_host
                ↓
         (appeal submitted)
                ↓
     ┌──────────┴──────────┐
  approved              rejected
     ↓                      ↓
active_host         suspended_host
```

## 5. Acceptance Criteria

- [x] Hosts can appeal host ability suspension
- [x] Hosts can appeal group walk cancellation
- [x] Admin can restore host ability via appeal approval
- [x] Admin can keep restriction via appeal rejection
- [x] Every action creates audit log
