# WalkTogether — v1.4 Monitoring Report

**Phase:** 20
**Status:** Monitoring infrastructure live
**Reporting period:** Phase 19 launch → Phase 20 monitoring rollout

---

## 1. Purpose

This report defines the v1.4 safety automation monitoring framework. Phase 19 shipped safety automation, safety review tasks, admin safety queue, and user-facing safety nudges. Phase 20 wraps those features in a measurement layer so product and safety teams can answer:

- Are safety signals being generated correctly?
- What is the false positive rate?
- How quickly are safety tasks being resolved?
- Are trust score changes fair?
- Is host quality automation working?
- Is multilingual moderation effective?

---

## 2. Monitoring Infrastructure

### 2.1 Safety Automation Effectiveness API

New endpoint: `GET /api/admin/safety-effectiveness`

Returns:
- Signal counts by type (last 30 days)
- Task counts by type, status, priority
- Outcome distribution (true_positive, false_positive, etc.)
- False positive rate by signal type
- Average resolution time (hours)
- Repeated offender count
- Admin action outcomes
- Trust score distribution
- Host quality summary

### 2.2 Enhanced Safety Tasks API

`GET /api/admin/safety-tasks` now includes:
- User context (report count, block count, previous tasks, previous admin actions)
- Outcome filter (`?outcome=false_positive`)
- Sort options (`?sort=oldest` for oldest unresolved first)
- Outcome summary in response (truePositives, falsePositives, unclassified)

### 2.3 Enhanced Safety Task Actions

`PATCH /api/admin/safety-tasks/[id]` now supports:
- `classify` action — classify outcome without resolving
- `outcome` field — true_positive, false_positive, needs_more_context, duplicate, user_misunderstanding, language_moderation_issue
- `resolutionNotes` field — notes about the resolution
- False positive dismissal restores trust score (+10 if < 50)
- `resolvedById` field — which admin resolved the task

---

## 3. Tracked Metrics

### 3.1 Signal metrics

| Signal type | Count | Severity | Resolved rate | FP rate |
|-------------|-------|----------|---------------|---------|
| repeated_reports | tracked | high | tracked | tracked |
| repeated_blocks | tracked | medium | tracked | tracked |
| unsafe_words | tracked | medium | tracked | tracked |
| home_address_request | tracked | high | tracked | tracked |
| private_meeting_request | tracked | high | tracked | tracked |
| high_report_rate_group | tracked | high | tracked | tracked |
| sos_during_walk | tracked | high | tracked | tracked |
| host_repeated_reports | tracked | high | tracked | tracked |
| rapid_join_leave | tracked | low | tracked | tracked |
| spam_invite | tracked | medium | tracked | tracked |

### 3.2 Task metrics

| Metric | Description |
|--------|-------------|
| Open tasks | Tasks awaiting review |
| Urgent tasks | High-priority open tasks |
| Reviewing tasks | Tasks being reviewed |
| Resolved tasks | Tasks marked resolved |
| Dismissed tasks | Tasks dismissed as false positive |
| Average resolution time | Hours from creation to resolution |
| Repeated offenders | Users with 2+ safety tasks |

### 3.3 Outcome metrics

| Outcome | Description |
|---------|-------------|
| true_positive | Signal was correct, action taken |
| false_positive | Signal was incorrect, no action needed |
| needs_more_context | Requires further investigation |
| duplicate | Duplicate of another task |
| user_misunderstanding | User didn't understand the feature |
| language_moderation_issue | Moderation incorrectly flagged text |

### 3.4 Trust score metrics

| Metric | Description |
|--------|-------------|
| Trust distribution | Count of users in 5 trust score bands |
| Low trust users | Active users with trust < 40 |
| Trust changes from reports | -5 per 3+ open reports (Phase 20: was -10) |
| Trust changes from ratings | +1 for 4-5 stars, -3 for 1-2 stars (Phase 20: was +2/-5) |
| Trust restoration | +10 when false positive dismissed (Phase 20: new) |

---

## 4. Acceptance Criteria

- [x] Safety automation effectiveness API exists
- [x] Safety tasks support outcome classification
- [x] False positive dismissal restores trust score
- [x] Safety queue shows user context (reports, blocks, previous actions)
- [x] Trust score rules are fairer (reduced penalties, false positive protection)
- [x] All metrics are admin-only (401 without auth)
