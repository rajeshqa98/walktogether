# WalkTogether — Global Free Launch Monitoring

**Phase:** 15 | **Mode:** Global Free Launch | **Last Updated:** [DATE]

---

## 1. Monitoring Philosophy

WalkTogether is now **free and open globally**. Anyone from any country, city, town, or village can sign up and use the app. Monitoring focuses on **community growth** and **safety**, not access control.

### Key Principles
- Track usage by **approximate area only** (country, state, city/town/village)
- Never expose exact user coordinates in dashboards unless required for safety review
- Monitor **density growth** — where are new communities forming?
- Monitor **safety health** — are safety systems working everywhere?
- Use data to **support growth**, not restrict access

---

## 2. Daily Metrics Dashboard

### Global Overview
| Metric | Source | Target | Alert |
|--------|--------|--------|-------|
| New signups (24h) | AnalyticsEvent: signup_completed | Growing | <5/day = investigate |
| Active users (24h) | User.lastActiveAt | Growing | Decline >20% = investigate |
| Nearby searches (24h) | AnalyticsEvent: nearby_search_performed | Growing | — |
| No-walkers rate | Searches with 0 results / total searches | <80% | >90% = growth needed |
| Walk requests sent (24h) | AnalyticsEvent: walk_request_sent | Growing | — |
| Walks completed (24h) | WalkSession status=ended | Growing | — |
| Group walks created (24h) | AnalyticsEvent: group_walk_created | Growing | — |
| Walking clubs created (24h) | AnalyticsEvent: club_created | Growing | — |
| Reports (24h) | Report count | <5/day | >10/day = safety review |
| SOS events (24h) | SafetyEvent type=sos_triggered | <3/day | >5/day = urgent review |
| Feedback (24h) | UserFeedback count | Growing | — |
| Crash-free sessions | Firebase Crashlytics | >97% | <95% = engineering review |
| OTP success rate | Server logs | >95% | <90% = provider investigation |
| Push delivery rate | FCM logs | >95% | <90% = FCM investigation |

### Area-Based Metrics (by country → state → city/town/village)

Track the following for each approximate area:
- Total users
- Active users (24h/7d)
- New signups (7d)
- Nearby searches (7d)
- No-walkers-nearby rate
- Walk requests sent (7d)
- Walks completed (7d)
- Group walks active
- Walking clubs active
- Reports (7d)
- SOS events (7d)
- Recommendation badge (see below)

---

## 3. Recommendation Badges

Each area gets a badge based on its health:

| Badge | Condition | Meaning |
|-------|-----------|---------|
| 🌱 **Growing** | New signups >3 in 7d AND no-walkers rate <80% | Community forming, healthy growth |
| 🚶 **Needs Walkers** | No-walkers rate >80% AND <10 total users | Early stage, needs community building |
| 🏠 **Needs Host** | >10 users BUT 0 group walks AND 0 clubs | Has users but no community leader |
| ⚠️ **Safety Review** | Report rate >10% OR >2 SOS in 7d | Safety concerns need admin attention |
| ✅ **Healthy Community** | >20 users, >5 walks completed, report rate <5% | Self-sustaining walking community |

---

## 4. Emerging Communities Detection

Automatically flag areas showing growth signals:
- **First walker:** Area with first-ever signup (welcome + onboarding tips)
- **First group walk:** Area with first group walk created (celebrate + share)
- **First walking club:** Area with first club created
- **Growing fast:** Area with >5 new signups in 7 days
- **High invite activity:** Area with high share/invite events

### Admin Actions for Emerging Communities
1. Send welcome message to first walker in a new area
2. Offer host verification to active users in growing areas
3. Create admin-hosted group walks in areas with >5 users but no hosts
4. Share community growth tips via push notification

---

## 5. No-Walkers-Nearby Monitoring

Track areas where users consistently find no walkers:

| Metric | Description | Action |
|--------|-------------|--------|
| No-walkers search count | Total searches returning 0 results by area | If >20 searches in 7d → growth push |
| No-walkers rate | % of searches with 0 results | If >90% → show community growth CTA |
| User retention after no-walkers | % of users who return after seeing empty state | If <20% → improve empty state UX |
| Group walk creation after no-walkers | % of users who create group walk after empty state | Track conversion |

### Growth Push for Low-Density Areas
When an area has >20 no-walker searches in 7 days:
1. Push notification to existing users: "Invite friends to WalkTogether — be the walking community in your area!"
2. Admin creates 1-2 group walks in that area (if public meeting points exist)
3. Email users in that area with community growth tips
4. Track if invites result in new signups
