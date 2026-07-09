# WalkTogether — Low-Density Area Strategy

**Goal:** Support users in areas with few or no other walkers. Turn "no walkers nearby" into "start your walking community."

---

## 1. The Low-Density Challenge

When a user opens WalkTogether and finds no walkers nearby, they may feel the app doesn't work. Our job is to:
1. **Reframe** the empty state as an opportunity, not a failure
2. **Empower** the user to build their local community
3. **Track** which areas need growth support
4. **Connect** isolated users to nearby areas or group walks

---

## 2. Empty State Design (Already Implemented)

### Current Empty State
- **Title:** "No walkers nearby yet"
- **Message:** "You may be one of the first WalkTogether users in this area. Try increasing your radius, creating a group walk, starting a walking club, or inviting friends from your community."
- **Actions:** Create group walk, Start walking club, Invite friends
- **Encouragement:** "Be the first walker in your area. Your community starts with you. 🚶"

### v1.2 Improvements (Planned)
- Show distance to nearest walker (e.g., "Nearest walker is 15km away in [CITY]")
- Show nearby group walks (even if outside radius)
- Show nearby walking clubs
- "Invite 3 friends" progress tracker
- Area demand counter ("You + 2 others have searched for walkers here")

---

## 3. Low-Density Support Actions

### For Users
| Action | When | How |
|--------|------|-----|
| Show empty state with CTAs | 0 walkers in radius | Already implemented |
| Suggest increasing radius to 1km+ | 0 walkers at 500m | Auto-suggest in empty state |
| Show nearby group walks | 0 walkers but group walks within 5km | v1.2 feature |
| Show nearby clubs | 0 walkers but clubs within 10km | v1.2 feature |
| Send "invite friends" push | User has 0 walkers for 3 days | v1.2 push notification |
| Celebrate first walker in area | First signup from a new area | Admin welcome message |

### For Admins
| Action | When | How |
|--------|------|-----|
| Create admin-hosted group walk | Area has >5 users but 0 group walks | Admin creates walk in that area |
| Send community growth tips | Area has >20 no-walker searches in 7d | Email/push to users in area |
| Identify potential hosts | Area has >10 users but 0 verified hosts | Admin invites active users to verify |
| Monitor emerging areas | Area shows >3 new signups in 7d | Admin dashboard alert |

---

## 4. Area Growth Stages

| Stage | Users | Walks/Week | Group Walks | Clubs | Strategy |
|-------|-------|------------|-------------|-------|----------|
| 🌱 Seed | 1-4 | 0 | 0 | 0 | Empty state + invite friends |
| 🌿 Sprout | 5-9 | 0-1 | 0-1 | 0 | Admin-hosted group walk + host recruitment |
| 🌳 Growing | 10-19 | 1-3 | 1-3 | 0-1 | Community host program + club creation |
| 🌲 Established | 20-49 | 3-10 | 3-5 | 1-3 | Self-sustaining — monitor only |
| 🏔️ Thriving | 50+ | 10+ | 5+ | 3+ | Community-led — admin monitors safety only |

---

## 5. Tracking Low-Density Areas

### Metrics per Area
| Metric | Source | Purpose |
|--------|--------|---------|
| Total users | User count by city | Track growth |
| No-walker searches (7d) | AnalyticsEvent by city | Demand indicator |
| Invite sends (7d) | Share button clicks | Growth activity |
| First group walk created | GroupWalk by city | Community formation |
| First club created | WalkingClub by city | Community maturity |
| Retention after no-walkers | User returns after empty state | UX effectiveness |

### Areas Needing Support (Admin Dashboard)
Show areas where:
- No-walker rate >90%
- Users have been active for >7 days but 0 walks completed
- >5 users but 0 group walks
- >10 users but 0 verified hosts

### Automated Alerts
- **First walker alert:** "First user signed up in [VILLAGE], [COUNTRY]!"
- **Growth alert:** "[CITY] grew from 3 to 8 users this week — consider admin-hosted group walk"
- **Host needed alert:** "[TOWN] has 12 users but no group walks — recruit a host"
- **High no-walkers alert:** "[AREA] has 25 no-walker searches this week — send community growth tips"
