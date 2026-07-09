# WalkTogether — City Health Score Specification

**Purpose:** Define a computed health score (0-100) for each active city, used in the admin launch dashboard to recommend expansion, monitoring, or pausing.

## Score Components

| Component | Weight | Score Logic |
|-----------|--------|-------------|
| Safety (reports + SOS) | 35% | 100 - (reportRate * 5) - (sosCount * 10) |
| Engagement (walks + searches) | 25% | min(walksPerUser * 20, 100) |
| Growth (new signups + waitlist) | 20% | min(signupsPerDay * 10, 100) |
| Stability (crash rate + OTP) | 10% | 100 - crashRate*100 - (100-otpRate) |
| Density (active users + hosts) | 10% | min(activeUsers * 5, 100) |

## Score Thresholds

| Score | Status | Recommendation | Color |
|-------|--------|----------------|-------|
| 80-100 | Healthy | ✅ Expand — open signup or activate more neighborhoods | 🟢 Green |
| 60-79 | Stable | ⚠️ Monitor — continue invite-only, watch trends | 🟡 Yellow |
| 40-59 | At Risk | ⚠️ Monitor closely — restrict new invites, investigate issues | 🟠 Orange |
| 0-39 | Critical | 🔴 Pause — move to waitlist-only or invite-only | 🔴 Red |

## Recommendation Badges

| Badge | Condition | Action |
|-------|-----------|--------|
| EXPAND | Score ≥80 AND active users ≥10 AND safety=green | Open signup + activate nearby cities |
| MONITOR | Score 60-79 OR safety=yellow | Continue current mode, daily review |
| RESTRICT | Score 40-59 OR safety=yellow for 7+ days | Stop new invites, restrict group creation |
| PAUSE | Score <40 OR safety=red OR SOS event | Move to waitlist-only, cancel group walks |
| WAITLIST | City not yet active | Collect waitlist, activate when ready |

## API Integration
The `/api/admin/launch/health` endpoint returns per-city metrics. The health score is computed client-side in the dashboard based on the formula above.

## Example Scores

| City | Safety | Engagement | Growth | Stability | Density | **Total** | **Badge** |
|------|--------|------------|--------|-----------|---------|-----------|-----------|
| Hyderabad | 95 | 85 | 90 | 99 | 100 | **92** | EXPAND |
| Bangalore | 100 | 80 | 85 | 99 | 90 | **90** | EXPAND |
| Delhi | 65 | 60 | 70 | 98 | 50 | **65** | MONITOR |
| Sydney | 90 | 30 | 40 | 99 | 20 | **56** | RESTRICT |
| Toronto | 100 | 50 | 60 | 98 | 40 | **70** | MONITOR |
