# Beta Test Scenarios

**Phase:** 28
**Status:** Ready for testers
**Last updated:** 2026-07-06

## Overview

Each tester should complete these scenarios over 1-2 hours during the 2-week beta period. The scenarios cover basic flows, walk flow, community features, account/privacy, and language testing.

## How to use this document

- Testers receive this as part of their onboarding message
- Testers check off each item as they complete it
- Testers report any bugs via in-app feedback or email
- Admin tracks completion via the metrics dashboard

## Basic scenarios (15 min)

### Install + startup
- [ ] Install the app from Play Store
- [ ] App icon appears with WalkTogether logo
- [ ] App opens without crash
- [ ] Splash screen displays
- [ ] Login screen loads within 3 seconds

### Login + OTP
- [ ] Enter phone number with country code (e.g. +919876543210)
- [ ] Tap "Send OTP"
- [ ] Receive OTP via SMS within 60 seconds
- [ ] Enter OTP code
- [ ] Tap "Verify & continue"
- [ ] App navigates to profile setup
- [ ] If wrong OTP entered → error message appears
- [ ] Resend OTP button works after 30-second cooldown

### Profile setup
- [ ] Enter name
- [ ] Select age range (18-24, 25-34, 35-44, 45-54, 55+)
- [ ] Select gender (female, male, non-binary)
- [ ] Enter bio (optional)
- [ ] Tap "Continue"
- [ ] Navigates to location setup

### Location setup
- [ ] "Use my GPS location" button prompts for location permission
- [ ] Grant permission → app detects approximate location
- [ ] OR: "Enter location manually" → enter village/town/city/district/state
- [ ] City field is required (validation works if empty)
- [ ] Tap "Save and continue"
- [ ] Navigates to home screen

### Home screen
- [ ] Bottom navigation visible (Nearby / Groups / Clubs / More)
- [ ] Nearby tab shows walkers list OR "No walkers nearby yet"
- [ ] Settings icon (top right) opens Settings
- [ ] Notifications icon opens Notifications
- [ ] Pull-to-refresh works on nearby list

### Settings
- [ ] Settings screen loads
- [ ] Language picker shows 9 languages
- [ ] "Hide me from nearby" toggle works
- [ ] "Download my data" works
- [ ] "Privacy requests" link works
- [ ] "My appeals" link works
- [ ] "Delete my account" shows confirmation dialog
- [ ] "Log out" works → returns to login

## Walk flow scenarios (30 min — coordinate with another tester)

**These scenarios require two testers. Coordinate with your beta testing partner.**

### Walker detail + send request
- [ ] Tap a walker in the nearby list
- [ ] Walker detail screen opens
- [ ] Walker name, distance, trust score visible
- [ ] Verification badge shows if verified
- [ ] Enter a message in the "Send a walk request" field
- [ ] Tap "Send walk request"
- [ ] Success message: "Walk request sent!"
- [ ] App returns to home

### Accept/reject request
- [ ] Other tester receives a walk request
- [ ] Other tester opens "Requests" (More tab → Walk requests)
- [ ] Request appears in "Incoming" tab
- [ ] Tap accept (checkmark) → request status changes to "accepted"
- [ ] OR: Tap decline (X) → request status changes to "declined"

### Chat
- [ ] After acceptance, chat icon appears in requests list
- [ ] Tap chat icon → chat screen opens
- [ ] Type a message + tap send
- [ ] Message appears immediately (optimistic)
- [ ] Other tester receives message in real-time (or on refresh)
- [ ] "Start walk" button visible at top

### Active walk session
- [ ] Tap "Start walk" button
- [ ] Walk session screen opens
- [ ] "Walk in progress" text visible
- [ ] Safety share toggle visible
- [ ] SOS button visible (red, prominent)
- [ ] SOS disclaimer text visible below button
- [ ] "End walk" button visible at bottom

### SOS test
- [ ] Tap SOS button
- [ ] Confirmation dialog appears with warning icon
- [ ] Disclaimer text visible: "WalkTogether is not an emergency service..."
- [ ] Tap "Cancel" → dialog closes, no SOS triggered
- [ ] Tap SOS again → "Trigger SOS"
- [ ] "SOS triggered. Safety contacts notified." message appears
- [ ] "SOS triggered" status card appears on screen
- [ ] **SOS does NOT call emergency services** (verified)

### Safety share
- [ ] Toggle safety share ON
- [ ] Toggle state updates
- [ ] Toggle safety share OFF
- [ ] Toggle state updates

### End walk + rating
- [ ] Tap "End walk"
- [ ] Confirmation dialog appears
- [ ] Confirm → navigates to post-walk screen
- [ ] "How was your walk?" text visible
- [ ] Tap stars to rate (1-5)
- [ ] Tap "Submit rating"
- [ ] "Rating submitted!" message appears

### Report + block
- [ ] Expand "Report or block this walker" section
- [ ] Select a report reason (radio buttons)
- [ ] Tap "Submit report" → "Report submitted." message
- [ ] Tap "Block user" → "User blocked." message + navigate to home
- [ ] Tap "Back to home"

## Community scenarios (15 min)

### Group walks
- [ ] Go to Groups tab (bottom nav)
- [ ] Tap "Browse group walks"
- [ ] Group walks list loads (or empty state)
- [ ] Tap a group walk → detail screen opens
- [ ] Group walk title, meeting point, participant count visible
- [ ] Tap "Join walk" → button changes to "Leave walk"
- [ ] "Group chat" button appears after joining
- [ ] Tap "Group chat" → group chat screen opens
- [ ] Type a message + send → message appears

### Clubs
- [ ] Go to Clubs tab (bottom nav)
- [ ] Tap "Browse walking clubs"
- [ ] Clubs list loads (or empty state)
- [ ] Tap a club → detail screen opens
- [ ] Club name, type, city, member count visible
- [ ] Tap "Join club" → button changes to "Leave club"

## Account + privacy scenarios (15 min)

### Notifications
- [ ] Go to More tab → (notifications icon in top bar)
- [ ] Notifications screen loads
- [ ] Unread notifications highlighted
- [ ] Read notifications show normally

### Privacy requests
- [ ] Go to Settings → "Privacy requests"
- [ ] "Download my data" quick action works
- [ ] "Delete my account" quick action works (shows confirmation)
- [ ] Submit a privacy request (e.g. "Location data cleanup")
- [ ] "Request submitted." message appears
- [ ] Request appears in "Your privacy requests" list

### Data export
- [ ] Go to Settings → "Download my data"
- [ ] "Preparing export…" message appears
- [ ] "Export ready: N fields." message appears
- [ ] (In production: JSON file would be downloaded)

### Account deletion
- [ ] Go to Settings → "Delete my account"
- [ ] Confirmation dialog: "14-day grace period" text visible
- [ ] Tap "Start deletion"
- [ ] App navigates to account-status screen
- [ ] "Account deletion in progress" message visible
- [ ] "Cancel deletion" button visible
- [ ] Tap "Cancel deletion" → returns to home

### Appeals
- [ ] Go to Settings → "My appeals"
- [ ] Appeals screen loads (or empty state)
- [ ] Tap "+" icon → create appeal dialog
- [ ] Select appeal type (dropdown)
- [ ] Enter reason + explanation
- [ ] Tap "Submit" → "Appeal submitted." message

### Feedback
- [ ] Go to More tab → "Give feedback"
- [ ] Select category (general, bug, safety concern, feature request)
- [ ] Tap stars to rate
- [ ] Enter feedback message
- [ ] Tap "Submit feedback" → "Thank you!" message

## Language scenarios (10 min)

### English
- [ ] Go to Settings → Language
- [ ] Select "English"
- [ ] UI updates to English
- [ ] All text readable

### Hindi
- [ ] Select "हिन्दी"
- [ ] UI updates to Hindi
- [ ] Devanagari script renders correctly
- [ ] Safety-critical text (SOS, auth) shows in Hindi
- [ ] No text overflow

### Arabic RTL
- [ ] Select "العربية"
- [ ] Layout flips to right-to-left
- [ ] Text alignment is right-to-left
- [ ] Back button points right
- [ ] Bottom navigation tabs laid out right-to-left
- [ ] No layout overflow
- [ ] App remains usable in RTL mode

### Other languages
- [ ] Test at least one of: తెలుగు, தமிழ், ಕನ್ನಡ, বাংলা, Español, Français
- [ ] Script renders correctly
- [ ] No crash on language switch
- [ ] Language persists after app restart

## Edge cases (10 min)

### Offline
- [ ] Turn off internet (airplane mode)
- [ ] Open app → error states show appropriately
- [ ] Turn internet back on → app recovers

### Empty states
- [ ] If no walkers nearby → "No walkers nearby yet" message
- [ ] If no group walks → "No group walks yet" message
- [ ] If no clubs → "No clubs yet" message
- [ ] If no notifications → "No notifications" message

### Session expiry
- [ ] If session expires (or log out) → app redirects to login
- [ ] Login screen loads correctly

## Completion checklist

- [ ] All basic scenarios completed
- [ ] Walk flow completed (with another tester)
- [ ] Community scenarios completed
- [ ] Account + privacy scenarios completed
- [ ] At least 2 languages tested (English + one other)
- [ ] Arabic RTL tested (if possible)
- [ ] Any bugs reported via in-app feedback

## Bug reporting

For any bug or issue:
1. Note what you were doing
2. Note what you expected
3. Note what actually happened
4. Take a screenshot if possible
5. Report via: More → Give feedback, or email support@walktogether.app
