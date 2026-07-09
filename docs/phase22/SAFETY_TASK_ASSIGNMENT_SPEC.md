# WalkTogether — Safety Task Assignment Spec

**Phase:** 22
**Status:** Implemented

---

## 1. Overview

Safety task auto-assignment and manual assignment/reassignment with due dates and overdue tracking.

## 2. Features

- Auto-assign: finds least-busy admin and assigns oldest unassigned task
- Manual assign: admin assigns task to specific admin
- Reassignment: admin can reassign tasks
- Due dates: high-priority tasks get 4-hour due date
- Overdue tracking: tasks past dueAt are flagged
- Audit logging: every assignment/reassignment creates audit log

## 3. API

`POST /api/admin/safety-tasks/assign`
- `{ action: "auto_assign" }` — auto-assign oldest unassigned to least-busy admin
- `{ taskId, adminId, dueAt? }` — manual assignment

## 4. Rules

- Critical SOS tasks stay visible to all admins until acknowledged
- Automation can assign review tasks, but not punish users
- Every assignment/reassignment creates audit log entry

## 5. Schema Changes

SafetyTask model extended with:
- `dueAt` — due date for high-priority tasks
- `assignedAt` — when the task was assigned
- `acknowledgedAt` — when an admin acknowledged
