# WalkTogether — v1.6 Release Notes

**Phase:** 24
**Release:** v1.6 (Governance Intelligence)
**Tagline:** Smarter safety, fairer appeals, better village growth — free for everyone.

---

## What's New in v1.6

### Appeal Timeline + SLA Tracking
- Every appeal status change is recorded as a timeline event
- SLA due dates computed per action type (48h-120h)
- Overdue appeal badges
- Aging buckets (0-24h, 24-48h, 48-72h, 72-120h, 120h+)
- Admin view: open appeals, overdue, by status/action type/language/country

### Trust Score History
- Every trust score change recorded with reason and source
- Admin API: `GET /api/admin/trust-history?userId=<id>`
- Fairness warnings: sudden drops, restorations, repeated false positives
- Wired into ratings API and reports API

### Moderation False-Positive Dashboard
- Admin API: `GET /api/admin/moderation-fp-dashboard`
- Tracks flagged messages, confirmed violations, false positives
- Language-specific false positive rates
- Safety pattern false positives

### Village/Town Growth Analytics
- Admin API: `GET /api/admin/village-growth`
- Tracks first walkers, invite activity, host coverage, safety concerns
- Emerging villages, villages needing host support

### Community Host Growth Analytics
- Admin API: `GET /api/admin/host-growth`
- Tracks onboarding, status changes, walk creation, reports, appeals
- Host badge visibility audit (all 5 locations verified)

### Admin Workload Balancing
- Admin API: `GET /api/admin/workload-balancing`
- Capacity tracking (max 15 tasks per admin)
- Auto-assignment suggestions
- Overdue escalation recommendations

### Native Speaker Moderation Review
- Admin API: `GET /api/admin/native-speaker-review`
- Lists tasks with language_moderation_issue outcome
- Groups by user language
- Shows admin language skills
- Coverage status per language

## Free Product Promise

WalkTogether is and always will be free. No premium, no subscriptions, no ads. Safety features are mandatory and always free.

— The WalkTogether Team
