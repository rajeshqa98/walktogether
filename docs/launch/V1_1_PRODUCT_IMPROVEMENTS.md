# WalkTogether — v1.1 Product Improvements

**Based on:** 30-day global launch feedback + beta learnings  
**Target Release:** [DATE]  
**Status:** Ready for development

---

## Priority Matrix

| Priority | Count | Description |
|----------|-------|-------------|
| 🔴 Must fix (v1.1) | 5 | Safety + privacy + crash fixes |
| 🟡 Should fix (v1.1) | 7 | UX + onboarding + trust improvements |
| 🟢 Nice to have (v1.2) | 5 | Features deferred to next release |

---

## v1.1 Improvement List

### 🔴 Must Fix (5 items)

#### 1. Better onboarding explanation
- **Problem:** 2 testers + 3 launch users didn't understand how to send a walk request
- **Fix:** Add first-time tooltip on Home screen: "Tap a walker's card to view their profile and send a walk request"
- **Files:** `home_screen.dart` (Flutter), `Home.tsx` (web)
- **Effort:** 2 hours

#### 2. Clearer trust score explanation
- **Problem:** Users don't understand what trust scores mean or how they're calculated
- **Fix:** Add "How is my trust score calculated?" info modal accessible from Settings, Profile, and walker detail
- **Content:** "Trust score is based on: completed walks (+1 each), positive ratings (+2 per 4-5 star), reports (-5 to -10), verification (+5). Range: 0-100."
- **Files:** New `TrustScoreInfo` component
- **Effort:** 3 hours

#### 3. Stronger location privacy copy
- **Problem:** Users want clearer explanation of what location data is shared
- **Fix:** Add in-app privacy banner on Home screen (first visit): "Other users see 'within 300m' style labels — never your exact coordinates. After you accept a walk, only the public meeting point is shared."
- **Files:** `home_screen.dart`, `Home.tsx`
- **Effort:** 1 hour

#### 4. Time-of-day safety tips
- **Problem:** Tester felt unsafe at 6 AM meeting point (isolated park)
- **Fix:** If walk is scheduled before 7 AM or after 9 PM, show safety tip: "For early morning/late evening walks, choose well-lit, popular meeting points with other people around."
- **Files:** `GroupWalkDetail.tsx`, `walk_session_screen.dart`
- **Effort:** 2 hours

#### 5. Better no-walkers-nearby state
- **Problem:** Users see empty state but don't know what to do
- **Fix:** Add actionable empty state: "No walkers in your radius. Try: 1) Expand your radius to 1km, 2) Join a group walk, 3) Invite friends to WalkTogether, 4) Come back during peak hours (6-8 AM, 6-8 PM)"
- **Files:** `home_screen.dart`, `Home.tsx`
- **Effort:** 1 hour

### 🟡 Should Fix (7 items)

#### 6. Better group host guidance
- **Problem:** New hosts don't know best practices
- **Fix:** Add "Host tips" section on create group walk screen: "Choose a well-lit public park. Set max participants to 8-10 for your first walk. Send an announcement in group chat before the walk."
- **Effort:** 1 hour

#### 7. Improved waitlist city messaging
- **Problem:** Waitlist users don't know their position or estimated launch
- **Fix:** Show waitlist position + city demand: "You're #28 on the [CITY] waitlist. We launch when we reach 50 walkers. Invite friends to speed it up!"
- **Effort:** 2 hours

#### 8. Better notification controls
- **Problem:** Users want granular control over which notifications they receive
- **Fix:** Add notification preference toggles in Settings: Walk requests (on/off), Chat messages (on/off), Safety alerts (always on, locked)
- **Effort:** 3 hours

#### 9. Clearer blocked/suspended account messages
- **Problem:** Banned/suspended users see generic error
- **Fix:** Show specific message: "Your account has been suspended for [reason] until [date]. If you believe this is an error, contact support@walktogether.app"
- **Effort:** 2 hours

#### 10. Better manual location picker
- **Problem:** Only 9 cities available for manual selection
- **Fix:** Expand to 50+ global cities. Add search functionality. Group by country.
- **Effort:** 4 hours

#### 11. Crash/performance fixes
- **Problem:** 1% crash rate (mostly older Android devices)
- **Fix:** Add null safety checks on group chat load. Optimize image loading. Reduce API payload size.
- **Effort:** 4 hours

#### 12. Hindi banned word list
- **Problem:** Auto-moderation only catches English banned words
- **Fix:** Add 20+ Hindi banned words to moderation list for Indian cities
- **Effort:** 1 hour

### 🟢 Nice to Have (v1.2 — deferred)

#### 13. Walking route suggestions
- **Fix:** Integrate Google Maps directions API for suggested walking routes from meeting point
- **Effort:** 8 hours

#### 14. Scheduled one-to-one walks
- **Fix:** Add "schedule for later" option on walk request
- **Effort:** 6 hours

#### 15. Video/voice call before meeting
- **Fix:** In-app voice call before walk (no phone number exchange)
- **Effort:** 16 hours

#### 16. Apple Health / Google Fit integration
- **Fix:** Sync walk duration + steps to health apps
- **Effort:** 6 hours

#### 17. Multi-language support
- **Fix:** Add Hindi, Telugu, Spanish, Arabic translations
- **Effort:** 40 hours

---

## v1.1 Development Effort Estimate

| Category | Items | Total Effort |
|----------|-------|-------------|
| Must fix | 5 | 9 hours |
| Should fix | 7 | 17 hours |
| Testing + QA | — | 4 hours |
| **Total** | **12** | **30 hours** |

**Target timeline:** 1 week development + 2 days testing = 9 days

---

## v1.1 Success Criteria

- [ ] Onboarding tooltip shown to all new users on first Home screen visit
- [ ] Trust score info modal accessible from 3 locations
- [ ] Location privacy banner shown on first visit (dismissible)
- [ ] Time-of-day safety tips appear for walks before 7 AM / after 9 PM
- [ ] No-walkers empty state shows 4 actionable suggestions
- [ ] Host tips section on create group walk screen
- [ ] Waitlist shows position + city demand
- [ ] Notification preference toggles in Settings
- [ ] Banned/suspended users see specific reason + duration
- [ ] Manual location picker has 50+ cities with search
- [ ] Crash rate <0.5% (down from 1%)
- [ ] Hindi banned words added to moderation
