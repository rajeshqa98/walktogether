# WalkTogether — Moderation Decision Templates

**Phase:** 21
**Status:** Implemented

---

## 1. Overview

Decision templates provide consistent, clear messaging for moderation outcomes. Admins select a template when resolving appeals or safety tasks.

## 2. Templates

| Template key | Message |
|-------------|---------|
| warning_issued | Warning issued. The user has been warned about their behavior. |
| temporary_suspension | Temporary suspension upheld. The user's account remains suspended. |
| permanent_ban | Permanent ban upheld. The user's account remains banned. |
| appeal_approved | Appeal approved. The restriction has been lifted. |
| appeal_rejected | Appeal rejected. The restriction remains in place. |
| host_ability_restored | Host ability restored. The user can host group walks and clubs again. |
| group_walk_cancelled | Group walk cancellation upheld for safety reasons. |
| false_positive_confirmed | False positive confirmed. Trust score has been restored. |
| needs_more_information | More information is needed from the user to proceed. |
| safety_concern_acknowledged | Safety concern acknowledged. The restriction remains as a precaution. |

## 3. Usage

Templates are used in:
- `PATCH /api/admin/appeals/[id]` — `decisionTemplate` field
- `PATCH /api/admin/safety-tasks/[id]` — `resolutionNotes` field (manual)

## 4. Acceptance Criteria

- [x] 10 decision templates defined
- [x] Templates available in admin appeals API
- [x] Template stored on appeal record
- [x] Template visible to user in appeal status
