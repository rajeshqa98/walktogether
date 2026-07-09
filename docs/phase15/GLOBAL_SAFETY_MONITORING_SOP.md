# WalkTogether — Global Safety Monitoring SOP

**Phase 15: Global Free Launch** | **Applicable:** All countries, all areas, all users

---

## 1. Daily Admin Safety Checklist

Complete every day, covering all global activity:

| # | Item | Source | Action |
|---|------|--------|--------|
| 1 | New reports (global) | /admin/reports?status=open | Review each. Warn/suspend/ban/dismiss. |
| 2 | SOS events (global) | /admin/safety-events?status=open | Investigate each. Resolve or escalate. |
| 3 | Flagged messages | /admin/messages?status=flagged | Review. Dismiss flag or remove message. |
| 4 | Repeat-reported users | /admin/analytics → Safety tab | If 3+ reports → suspend. |
| 5 | Group walk reports | /admin/reports (filter by group) | Investigate. Cancel walk if needed. |
| 6 | Low trust users (<40) | /admin/analytics → Safety tab | Monitor. Suspend if pattern worsens. |
| 7 | Banned/suspended users | /admin/users?status=banned | Verify no bypass attempts (new account from same phone). |
| 8 | Feedback (safety concern) | /admin/feedback?category=safety_concern | Respond within 4 hours. |
| 9 | Newly created group walks | Check new walks globally | Verify public meeting points. Cancel if unsafe. |
| 10 | Public meeting point quality | Spot check new walks | Remove inappropriate points. |
| 11 | Country/area safety trends | /admin/launch/health | If any area has report rate >10%, set safetyStatus=yellow. |
| 12 | Emerging area safety | /admin/activation/dashboard | Monitor new areas for safety issues. |

---

## 2. Safety Rules (Global, Mandatory, Free)

All safety rules apply to every user in every country:

| Rule | Enforcement |
|------|-------------|
| Exact location hidden before mutual acceptance | Server strips coordinates from API response |
| Approximate distance labels only | Server returns "within 300m" style labels |
| Public meeting point guidance | App suggests public places; host must choose public point |
| SOS user-controlled | SOS does NOT auto-call emergency services |
| Report/block always available | In post-walk, chat, and group walk screens |
| Banned/suspended users blocked | Server returns 403 for all actions |
| Group chat members-only | Server checks participation before allowing read/write |
| Flagged messages reviewed | Auto-moderation flags; admin reviews |
| Women-only groups enforced | Server checks gender on join |
| Verified-only groups enforced | Server checks verification on join |
| Emergency copy country-neutral | If local emergency number unknown: "Contact your local emergency service immediately" |

---

## 3. Escalation Levels

| Level | Example | Response Time | Action |
|-------|---------|---------------|--------|
| P0 — Critical | SOS with real danger, location privacy leak | 1 hour | Immediate investigation. Ban if warranted. Contact affected users. |
| P1 — High | Harassment, threats, persistent unwanted behavior | 4 hours | Suspend or ban. Review chat logs. |
| P2 — Medium | Inappropriate messages, spam, fake profile suspicion | 24 hours | Warning or suspension. Review behavior. |
| P3 — Low | Minor UX complaint, feature request | 72 hours | Log for product team. No safety action. |

---

## 4. Area-Specific Safety Monitoring

### High-Risk Area (safetyStatus = "red")
- Report rate >15% of active users
- 2+ SOS events in 7 days
- **Actions:** Pause group creation for area. Admin reviews all new users. Consider restricting new signups (maintenance mode for that area only — not globally).

### Medium-Risk Area (safetyStatus = "yellow")
- Report rate 5-15%
- 1 SOS event in 7 days
- **Actions:** Daily monitoring. Admin reviews all group walks before they start. Increased moderation of chat messages.

### Healthy Area (safetyStatus = "green")
- Report rate <5%
- 0 SOS events in 7 days
- **Actions:** Standard monitoring. Weekly safety review.

---

## 5. Weekly Safety Summary

| Metric | This Week | Last Week | Trend |
|--------|-----------|-----------|-------|
| Total reports | — | — | — |
| Total SOS events | — | — | — |
| Real emergencies | 0 | 0 | — |
| Total blocks | — | — | — |
| Top report reasons | — | — | — |
| Repeat offenders | — | — | — |
| Admin actions taken | — | — | — |
| Unresolved risks | — | — | — |
| Areas with safety concerns | — | — | — |
| Recommendation | — | — | — |
