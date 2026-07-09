# WalkTogether — Delhi Safety Observation Plan

**City:** Delhi NCR, India  
**Start Date:** [DATE]  
**Duration:** 7 days  
**Reason:** 37.5% report rate (3 of 8 active users reported) + 1 real SOS event

## Daily Metrics to Track

| Metric | Source | Threshold |
|--------|--------|-----------|
| New reports | /admin/reports?status=open | >2/day = concern |
| SOS events | /admin/safety-events | >1 during 7 days = pause |
| Flagged messages | /admin/messages?status=flagged | >3 during 7 days = concern |
| Repeat-reported users | /admin/analytics → Safety | Any user with 2+ reports = suspend |
| Group walk reports | /admin/reports (filter) | Any group walk report = investigate |
| Completed walks | /admin/pilot | Track for context |
| Admin actions | /admin/audit-logs | Document all actions |
| Crash rate | Firebase Crashlytics | >2% = concern |
| OTP success rate | Server logs | <90% = concern |

## Decision Matrix (After 7 Days)

| Condition | Action |
|-----------|--------|
| 0 new SOS events AND report rate <20% | ✅ Continue active — safety status → green |
| 0 new SOS events AND report rate 20-30% | ⚠️ Continue active — keep safety status yellow |
| 1+ new SOS events OR report rate >30% | 🔴 Pause city — move to invite-only, restrict new invites |
| 1+ new SOS events + repeat offender | 🔴 Pause city + ban offender + investigate all Delhi users |

## Additional Safety Measures for Delhi
1. Show additional safety tip on Home screen for Delhi users: "For walks in Delhi, always choose well-lit, busy meeting points. Avoid isolated areas, especially early morning or late evening."
2. Admin reviews all Delhi group walks before they start (verify meeting points)
3. Delhi users get priority support response (2-hour SLA for safety concerns)
4. Weekly safety summary includes Delhi-specific section

## Observation Log Template

### Day [X] — [DATE]
- New reports: [count]
- SOS events: [count]
- Flagged messages: [count]
- Active users: [count]
- Completed walks: [count]
- Admin actions: [list]
- Assessment: [Green/Yellow/Red]
- Notes: [observations]

---

# WalkTogether — Sydney Density Observation Plan

**City:** Sydney, Australia  
**Start Date:** [DATE]  
**Duration:** 7 days  
**Reason:** Low density (3 active users) + 1 SOS event

## Daily Metrics to Track

| Metric | Source | Threshold |
|--------|--------|-----------|
| Active users (24h) | /admin/pilot | <3 = concern |
| Nearby searches | Analytics events | <2/day = concern |
| No-walkers-nearby rate | Feedback/analytics | >80% searches = 0 results = concern |
| Walk requests sent | Analytics events | 0 during 7 days = concern |
| Request acceptance rate | Analytics events | <30% = concern |
| Group walk interest | Group walk views | <3 views = concern |
| Waitlist growth | Waitlist entries | <2 new = concern |
| New signups | User count | 0 during 7 days = concern |

## Decision Matrix (After 7 Days)

| Condition | Action |
|-----------|--------|
| Active users ≥5 AND ≥2 walks completed | ✅ Continue active |
| Active users 3-4 AND admin creates 2+ group walks | ⚠️ Continue with admin-hosted group walks |
| Active users <3 for 7 consecutive days | 🔴 Move to waitlist-only |
| 0 new signups for 7 days | 🔴 Move to waitlist-only |

## Density Improvement Strategies
1. Admin creates 2-3 group walks in Sydney public parks (admin-hosted)
2. Recruit 2-3 verified hosts from waitlist
3. Partner with Sydney walking communities (via partnership outreach)
4. Send targeted WhatsApp message to Sydney waitlist users
5. Promote Sydney group walks on Instagram/LinkedIn

## Observation Log Template

### Day [X] — [DATE]
- Active users: [count]
- Nearby searches: [count]
- Walk requests sent: [count]
- New signups: [count]
- Group walk views: [count]
- Waitlist growth: [count]
- Admin-hosted group walks: [count]
- Assessment: [Continue/Monitor/Pause]
- Notes: [observations]
