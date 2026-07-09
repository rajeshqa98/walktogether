# WalkTogether — Trust Appeals Spec

**Phase:** 21
**Status:** Implemented

---

## 1. Overview

Phase 21 adds a user appeal system allowing users to appeal moderation actions including account suspension, bans, host ability suspension, group walk cancellation, club restriction, trust score review, and message moderation flags.

---

## 2. Appeal Model

```prisma
model Appeal {
  id              String    @id @default(cuid())
  userId          String
  actionType      String    // "account_suspension" | "account_ban" | "host_suspension" | "group_walk_cancellation" | "club_restriction" | "trust_score_review" | "message_moderation"
  reason          String    // user's brief reason (min 10 chars)
  explanation     String    // detailed explanation (min 20 chars)
  supportingDetails String? // optional supporting info
  status          String    @default("submitted") // "submitted" | "under_review" | "needs_more_info" | "approved" | "rejected" | "closed"
  adminNotes      String?
  reviewedById    String?
  reviewedAt      DateTime?
  decisionTemplate String?
  createdAt       DateTime  @default(now())
  resolvedAt      DateTime?
}
```

## 3. Appeal Statuses

| Status | Description |
|--------|-------------|
| submitted | User has submitted the appeal |
| under_review | Admin is reviewing |
| needs_more_info | Admin needs more information from user |
| approved | Appeal approved, restriction lifted |
| rejected | Appeal rejected, restriction remains |
| closed | Appeal closed without resolution |

## 4. API Endpoints

| Method | Path | Purpose |
|--------|------|---------|
| GET | `/api/appeals` | User lists their appeals |
| POST | `/api/appeals` | User submits a new appeal |
| GET | `/api/appeals/[id]` | User views a specific appeal |
| GET | `/api/admin/appeals` | Admin lists appeals queue |
| PATCH | `/api/admin/appeals/[id]` | Admin reviews/resolves appeal |

## 5. Acceptance Criteria

- [x] Users can submit appeals for 7 action types
- [x] Admins can review and resolve appeals
- [x] Approved appeals can restore account, host ability, and trust score
- [x] Every admin action creates an audit log entry
- [x] Users receive notifications when appeal is resolved
- [x] Duplicate open appeals for same action type are prevented
