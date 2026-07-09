# WalkTogether — Admin Dashboard v1.5 Spec

**Phase:** 20
**Status:** Spec defined; metrics available via API

---

## 1. Overview

The Admin Dashboard v1.5 extends the existing dashboard with safety automation effectiveness metrics, false positive rates, trust score distribution, and admin action outcomes.

---

## 2. New Metrics Available

### 2.1 Safety automation effectiveness

Available via `GET /api/admin/safety-effectiveness`:

| Metric | Description |
|--------|-------------|
| Signal counts by type | Count of each signal type in last 30 days |
| Task counts by status | Open, reviewing, resolved, dismissed |
| Task counts by type | Repeated reports, SOS review, host review, etc. |
| Outcome distribution | True positive, false positive, needs more context, etc. |
| FP rate by signal type | False positive rate per signal type |
| Overall FP rate | Aggregate false positive rate |
| Average resolution time | Hours from creation to resolution |
| Repeated offender count | Users with 2+ safety tasks |
| Admin action counts | Count of each admin action type |
| Trust score distribution | Users in 5 trust score bands |
| Low trust users | Active users with trust < 40 |
| Total hosts | All community hosts |
| Hosts needing review | Open host_review tasks |

### 2.2 Enhanced safety queue

Available via `GET /api/admin/safety-tasks`:

| Feature | Description |
|---------|-------------|
| User context | Report count, block count, previous tasks, previous admin actions |
| Outcome filter | Filter by true_positive, false_positive, etc. |
| Sort options | Priority (default) or oldest unresolved first |
| Outcome summary | True positives, false positives, unclassified counts |

### 2.3 Community dashboard (existing + extended)

The existing `/admin/community` dashboard now includes:
- Safety summary (open tasks, urgent, high, signals, SOS count)
- Tasks by type breakdown
- All existing community growth metrics

---

## 3. Dashboard Sections (v1.5)

### 3.1 Safety automation effectiveness panel

```
┌──────────────────────────────────────────┐
│ Safety Automation Effectiveness          │
├──────────────────────────────────────────┤
│ Total signals (30d): 15                  │
│ Open tasks: 8                            │
│ Urgent tasks: 1                          │
│ Avg resolution time: 4.5h                │
│ Overall FP rate: 20.0%                   │
│ Repeated offenders: 2                    │
├──────────────────────────────────────────┤
│ Signal type    │ Count │ FP rate │       │
│ repeated_report│ 5     │ 20.0%   │       │
│ spam_invite    │ 3     │ 33.3%   │       │
│ ...            │ ...   │ ...     │       │
└──────────────────────────────────────────┘
```

### 3.2 Trust score distribution panel

```
┌──────────────────────────────────────────┐
│ Trust Score Distribution                 │
├──────────────────────────────────────────┤
│ 0-20:   ████ (4)                         │
│ 21-40:  ██████████ (10)                  │
│ 41-60:  ████████████████████ (20)        │
│ 61-80:  ████████████████████████ (25)    │
│ 81-100: ██████████████ (14)              │
├──────────────────────────────────────────┤
│ Low trust users (< 40): 14               │
└──────────────────────────────────────────┘
```

### 3.3 Outcome distribution panel

```
┌──────────────────────────────────────────┐
│ Safety Task Outcomes                     │
├──────────────────────────────────────────┤
│ True positive:     3 (42.9%)             │
│ False positive:    2 (28.6%)             │
│ Needs more context: 1 (14.3%)            │
│ Duplicate:         0 (0%)                │
│ User misunderstanding: 1 (14.3%)         │
│ Language issue:    0 (0%)                │
│ Unclassified:      2                     │
└──────────────────────────────────────────┘
```

---

## 4. API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `GET /api/admin/safety-effectiveness` | Safety automation effectiveness metrics |
| `GET /api/admin/safety-tasks` | Safety task queue with user context |
| `PATCH /api/admin/safety-tasks/[id]` | Task actions with outcome classification |
| `GET /api/admin/community` | Community dashboard with safety summary |
| `GET /api/admin/hosts` | Host quality metrics |
| `GET /api/admin/i18n` | Translation + moderation coverage |
| `GET /api/admin/compliance` | Free product compliance scan |

---

## 5. Acceptance Criteria

- [x] Safety automation effectiveness API exists
- [x] False positive rate is tracked by signal type
- [x] Trust score distribution is available
- [x] Host quality summary is available
- [x] Average resolution time is tracked
- [x] Admin action outcomes are tracked
- [x] All APIs are admin-only (401 without auth)
- [x] Safety queue shows user context
- [x] Outcome classification is supported
