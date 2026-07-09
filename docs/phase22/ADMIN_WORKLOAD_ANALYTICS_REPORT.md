# WalkTogether — Admin Workload Analytics Report

**Phase:** 22
**Status:** Implemented

---

## 1. Overview

Admin workload dashboard tracks per-admin metrics and capacity.

## 2. Metrics Tracked

Per admin: open tasks, reviewing tasks, resolved tasks, dismissed tasks, overdue tasks, appeals handled, reports handled, SOS reviews, false positives corrected, average resolution time, capacity warning.

Summary: total open, total overdue, unresolved critical, unassigned, daily/weekly creation/resolution, capacity warnings.

## 3. API

`GET /api/admin/workload` — returns admin workloads and summary

## 4. Admin Page

`/admin/workload` — dashboard with summary cards, activity cards, and per-admin table

## 5. Capacity Warning

Admin with 10+ open+reviewing tasks gets "OVERLOADED" badge.
