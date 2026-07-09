# WalkTogether — Admin Workload Balancing Spec

**Phase:** 24
**Status:** Implemented

---

## 1. Overview

Improved admin assignment logic with capacity tracking and suggestions.

## 2. API

`GET /api/admin/workload-balancing`

## 3. Features

- Admin capacity: max 15 open tasks per admin
- Utilization rate tracking
- Overload warnings (>15 active tasks)
- Auto-assignment suggestions (least-busy non-overloaded admin)
- Manual reassignment (via existing assign API)
- Overdue escalation recommendations
- Language and area tags per admin

## 4. Rules

- Does NOT auto-resolve tasks
- Does NOT auto-punish users
- Suggestions only — admin must confirm

## 5. Acceptance Criteria

- [x] Admin workload balancing is improved
- [x] Capacity warnings work
- [x] Assignment suggestions are generated
- [x] Overdue escalations are recommended
