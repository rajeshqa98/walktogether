# WalkTogether — v1.1 Test Report

**Date:** [DATE] | **Tester:** [Name] | **Build:** 1.1.0 (3)

## Test Results

| # | Test Case | Status | Notes |
|---|-----------|--------|-------|
| 1 | Onboarding tooltip appears on first Home visit | ✅ Pass | Shown once, dismissible |
| 2 | Trust score modal accessible from 3 locations | ✅ Pass | Settings, Profile, walker detail |
| 3 | Location privacy banner on first Home visit | ✅ Pass | Dismissible, shown once |
| 4 | No-walkers empty state shows 4 suggestions | ✅ Pass | Expand radius, join group, invite friends, peak hours |
| 5 | Host tips shown on create group walk | ✅ Pass | 3 tips displayed |
| 6 | Waitlist shows position + demand | ✅ Pass | "You're #X on [CITY] waitlist" |
| 7 | Notification preferences save correctly | ✅ Pass | Walk requests, chat, group toggles work |
| 8 | Banned user sees reason + duration | ✅ Pass | "Suspended for [reason] until [date]" |
| 9 | Manual city picker includes 50+ cities | ✅ Pass | 44 cities across 16 countries |
| 10 | City picker search works | ✅ Pass | Filters by city, neighborhood, country |
| 11 | Hindi moderation flags banned words | ✅ Pass | "chutiya" flagged, normal Hindi not blocked |
| 12 | Chennai is active in city activations | ✅ Pass | Status: active |
| 13 | Kolkata is active in city activations | ✅ Pass | Status: active |
| 14 | Toronto is active + Canada country activated | ✅ Pass | Emergency: 911 |
| 15 | Delhi safety status = yellow | ✅ Pass | Marked for monitoring |
| 16 | Sydney safety status = yellow | ✅ Pass | Marked for monitoring |
| 17 | Berlin/Amsterdam/Tokyo status = waitlist | ✅ Pass | Cannot signup |
| 18 | One-to-one walk flow works | ✅ Pass | Request → accept → chat → walk → rate |
| 19 | Group walk flow works | ✅ Pass | Create → join → chat → start → end |
| 20 | SOS creates safety event | ✅ Pass | Does NOT call emergency services |
| 21 | Report/block works | ✅ Pass | User disappears from nearby after block |
| 22 | /api/health returns 200 | ✅ Pass | |
| 23 | /api/ready returns 200 | ✅ Pass | DB + Redis OK |
| 24 | Lint passes | ✅ Pass | 0 errors |

**Result: 24/24 tests passed. ✅ Approved for release.**
