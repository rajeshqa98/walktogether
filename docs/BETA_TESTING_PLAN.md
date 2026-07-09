# WalkTogether — TestFlight Plan

## Overview
This document covers the iOS TestFlight testing process for WalkTogether's closed pilot.

## Prerequisites
- macOS with Xcode 15+
- Flutter SDK
- Apple Developer account ($99/year)
- Firebase project with iOS app configured
- Backend API deployed with HTTPS URL

## Setup Steps

### 1. Build and Archive
```bash
cd flutter_app
flutter build ios --release
# Open Xcode:
open ios/Runner.xcworkspace
# Product → Archive
```

### 2. Upload to App Store Connect
- In Xcode Organizer: select archive → Distribute App → App Store Connect
- Wait for processing (10-30 minutes)

### 3. Configure TestFlight
- In App Store Connect → your app → TestFlight
- Add test information:
  - Description: "WalkTogether closed pilot — safety-first walking companion"
  - Feedback email: feedback@walktogether.app
  - Reviewer notes: See APP_STORE_REVIEW_NOTES.md

### 4. Add Testers
- **Internal testers:** Apple Developer team members (up to 100)
- **External testing groups:** Up to 10,000 testers per group
- Create group: "Closed Pilot — Hyderabad"
- Add tester emails

### 5. Release Build
- Select build → add to testing group
- Apple may require review for first external testing build (1-2 days)
- Subsequent builds are usually auto-approved

---

## TestFlight Tester Onboarding Message

```
Welcome to WalkTogether's closed pilot! 🚶

WalkTogether is a safety-first app to help you find nearby verified walking partners and join community group walks.

GETTING STARTED:
1. Install the app from TestFlight
2. Tap "Continue as demo user" for quick exploration, OR:
   - Enter your phone number
   - Request OTP (any 4-6 digit code works in dev mode)
   - Complete profile setup
3. Allow location (or pick your area manually)
4. Start finding walkers nearby!

TEST SCENARIOS TO TRY:
✅ Find nearby walkers
✅ Send a walk request
✅ Accept a walk request (check the Requests tab)
✅ Chat with your walking partner
✅ Start a walk session — test the SOS button (it's safe — does NOT call emergency services)
✅ Rate your partner after the walk
✅ Join a group walk
✅ Join a walking club
✅ Submit feedback in Settings

SAFETY FEATURES:
- Your exact location is NEVER shown to other users
- Only approximate distance ("within 300m") is displayed
- SOS button notifies your emergency contact + flags partner for review
- You can report and block any user
- You can hide from nearby walkers anytime in Settings

REPORT BUGS TO: bugs@walktogether.app
REPORT SAFETY CONCERNS TO: safety@walktogether.app
GIVE FEEDBACK: Use the feedback form in Settings

Thank you for helping us make WalkTogether safer! 🙏
```

---

# WalkTogether — Google Play Closed Test Plan

## Overview
This document covers the Google Play closed testing process for WalkTogether's closed pilot.

## Prerequisites
- Google Play Developer account ($25 one-time)
- Signed AAB file
- Firebase project with Android app configured
- Backend API deployed

## Setup Steps

### 1. Create App in Play Console
- Create new app → WalkTogether
- Set package: com.walktogether.app
- Set category: Health & Fitness

### 2. Closed Testing Track
- Testing → Closed testing → Create release
- Upload AAB file
- Add release notes (see STORE_LISTING_COPY.md → What's New)
- Add tester email list (minimum 12 for new personal accounts)

### 3. Share Opt-in URL
- Play Console → Closed testing → Manage → Copy opt-in URL
- Share with testers via email/WhatsApp

### 4. Wait 14 Days
- New personal accounts require 14 continuous days of closed testing
- Testers must remain opted-in during this period
- Collect feedback during testing

### 5. Apply for Production Access
- After 14 days, apply for production access in Play Console
- Answer questions about testing:
  - How many testers participated?
  - What feedback was received?
  - What bugs were found and fixed?
  - Why is the app ready for production?

---

# WalkTogether — Beta Tester Script

## Test Scenarios

### Scenario 1: Signup + Profile Setup
1. Open app → tap "Continue as demo user"
2. (OR) Enter phone → request OTP → enter any 6 digits → verify
3. Complete profile: enter name, select age range, gender, pace, walk types, languages
4. Tap "Continue"
5. **Expected:** Location permission screen appears

### Scenario 2: Location Setup
1. Read the privacy explanation
2. Tap "Allow location access" → grant permission
3. (OR) Tap "Pick my area manually" → select a city
4. **Expected:** Home screen with nearby walkers appears

### Scenario 3: Find Nearby Walkers
1. On Home screen, change radius (100m / 500m / 1km)
2. Verify walker cards show approximate distance ("within 300m")
3. Verify verified badges and trust scores are visible
4. Verify presence indicators (Available now / Recently active / Offline)
5. Tap a walker card
6. **Expected:** Walker detail screen with profile, meeting point, send request button

### Scenario 4: Send Walk Request
1. On walker detail, select walk type
2. Optional: type a message
3. Tap "Send walk request"
4. **Expected:** Confirmation toast + redirect to Requests tab

### Scenario 5: Accept Walk Request
1. Go to Requests tab → Inbox
2. Find an incoming request (seeded)
3. Tap "Accept"
4. **Expected:** Chat screen opens

### Scenario 6: Chat
1. In chat, type a message and send
2. Verify message appears with timestamp
3. Try sending a banned word (e.g., type a profanity) — should get "flagged" error
4. **Expected:** Messages send successfully, moderation works

### Scenario 7: Start Walk + SOS
1. In chat, tap "Start walking together"
2. Verify walk session screen with live timer
3. Tap SOS button → confirm in dialog
4. Verify safety alert confirmation message
5. Toggle "Live share" on/off
6. Tap "End walk"
7. **Expected:** Post-walk rating screen

### Scenario 8: Rate + Report + Block
1. On post-walk screen, tap 5 stars
2. Tap "Submit rating"
3. Expand "Report or block" section
4. Select a reason → "Submit report"
5. Tap "Block user"
6. Tap "Back to home"
7. **Expected:** Returns to home, walker no longer in nearby list

### Scenario 9: Group Walks
1. Go to Groups tab
2. Browse group walks with filters (Today, Tomorrow, Weekend)
3. Tap a group walk → view details
4. Tap "Join group walk"
5. Verify participant list becomes visible
6. Tap "Open group chat" → send a message
7. **Expected:** Group chat works, participant list visible

### Scenario 10: Walking Clubs
1. In Groups tab → Clubs sub-tab
2. Browse clubs
3. Tap a club → view details, rules, members
4. Tap "Join club"
5. **Expected:** Joined badge appears, can leave club

### Scenario 11: Notifications
1. Go to Notifications tab
2. Verify seeded notifications appear
3. Tap a notification → should navigate to relevant screen
4. Tap "Mark all read"
5. **Expected:** Unread badges clear

### Scenario 12: Settings + Feedback
1. Go to Settings
2. Toggle "Hide me from nearby" → verify it saves
3. Tap "Give feedback" → fill form → submit
4. Tap "Log out"
5. **Expected:** Returns to login screen

---

## Bug Report Template

```
BUG REPORT — WalkTogether

Tester name: ____________
Device: ____________ (e.g., iPhone 14, Samsung Galaxy S23)
OS version: ____________
App version: 1.0.0

What happened:
[Describe what you saw]

What you expected:
[Describe what you expected to happen]

Steps to reproduce:
1. 
2. 
3. 

Screenshot/Video:
[Attach if possible]

Severity: [Critical / High / Medium / Low]
```

## Safety Incident Reporting Process

If a tester experiences a safety concern during testing:

1. **Immediate:** Use the SOS button in the app (safe — does NOT call emergency services)
2. **Within 1 hour:** Email safety@walktogether.app with details
3. **Admin response:** Our team reviews all safety events within 24 hours
4. **Follow-up:** We will contact the tester to understand what happened and take appropriate action

**For real emergencies:** Call 112 (India) or your local emergency number. WalkTogether does not replace emergency services.

## Daily Monitoring Checklist (for Admin)

During closed beta, the admin team should check daily:

- [ ] Reports queue — any new reports? Review and action
- [ ] Safety events — any SOS events? Investigate
- [ ] Flagged messages — any flagged content? Review
- [ ] New users — anyone suspicious?
- [ ] Blocked users — any new blocks?
- [ ] Low trust users — any users below 40 trust score?
- [ ] Group walks — any new group walks? Any with safety concerns?
- [ ] Feedback — any new feedback? Any safety concerns?
- [ ] Analytics dashboard — any anomalies in signup funnel or safety metrics?
- [ ] Crashes — check Firebase Crashlytics (if configured)

## Go/No-Go Criteria for Public Launch

### Must Have (All Required)
- [ ] 14+ days of closed testing completed
- [ ] Minimum 12 testers participated (Google Play requirement)
- [ ] All critical bugs fixed
- [ ] No safety incidents in last 7 days
- [ ] OTP delivery working reliably (MSG91/Twilio)
- [ ] Push notifications working on Android + iOS
- [ ] Privacy Policy + Terms published at public URLs
- [ ] Store listings approved
- [ ] Admin monitoring process documented and active

### Should Have (Important)
- [ ] Real-time chat working via socket.io (with polling fallback)
- [ ] Group walk full flow tested by at least 5 testers
- [ ] Feedback response rate > 50%
- [ ] Crash-free sessions > 95%
- [ ] At least 10 successful walk completions during testing
- [ ] No reports of location privacy violations

### Defer to Post-Launch
- [ ] Offline mode
- [ ] Background location
- [ ] Apple Health / Google Fit integration
- [ ] Advanced AI moderation
- [ ] Payment/premium features
