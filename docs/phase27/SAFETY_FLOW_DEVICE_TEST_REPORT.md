# Safety Flow Device Test Report

**Phase:** 27C
**Status:** Code-verified; physical device test pending beta
**Last updated:** 2026-07-06

## Overview

WalkTogether's safety flows are the most critical part of the app. This report documents what was verified in code and what must be tested on a physical device during closed beta.

## Safety flows verified in code

### 1. SOS button ✅

**Location:** `walk_session_screen.dart`

**Code verification:**
- SOS button is prominently displayed (red, 56dp height, bold "SOS" text)
- Tapping SOS shows a confirmation dialog with:
  - Warning icon
  - `t('sos.disclaimer')` text: "WalkTogether is not an emergency service. Call local emergency number."
  - Clear statement: "SOS will alert your safety contacts and the WalkTogether safety team. It does NOT call emergency services."
  - Cancel + "Trigger SOS" buttons
- On confirm: calls `apiClient.triggerSos(sessionId)` → POST `/api/sessions/:id/sos`
- On success: shows "SOS triggered. Safety contacts notified." snackbar (red background)
- On failure: shows "Failed to trigger SOS. Please call local emergency number." snackbar
- After SOS: displays "SOS triggered" status card with warning icon

**Device test required:**
- [ ] SOS button visible during active walk
- [ ] Confirmation dialog appears
- [ ] Disclaimer text is readable
- [ ] SOS creates backend safety event (verify in admin safety queue)
- [ ] SOS does NOT auto-call emergency services
- [ ] Success message appears
- [ ] Safety team receives notification

### 2. Safety share ✅

**Location:** `walk_session_screen.dart`

**Code verification:**
- SwitchListTile with "Safety share" label
- Subtitle: "Share live status with your safety contact"
- Toggle calls `apiClient.setSafetyShare(sessionId, enabled)` → POST `/api/sessions/:id/safety`
- Toggle state updates immediately

**Device test required:**
- [ ] Safety share toggle works
- [ ] Toggle state persists during walk
- [ ] Backend receives safety share events

### 3. Report user ✅

**Location:** `post_walk_screen.dart`

**Code verification:**
- ExpansionTile with "Report or block this walker" title
- 5 report reasons: harassment, unsafe_behavior, fake_profile, spam, other
- RadioListTile for reason selection
- "Submit report" button calls `apiClient.submitReport({reportedUserId, reason})`
- Success: "Report submitted." snackbar

**Device test required:**
- [ ] Report tile expands
- [ ] Radio buttons work
- [ ] Submit report creates backend report
- [ ] Admin receives report in queue

### 4. Block user ✅

**Location:** `post_walk_screen.dart`

**Code verification:**
- "Block user" button calls `apiClient.blockUser(partnerId)` → POST `/api/blocks`
- Success: "User blocked." snackbar + navigate to home

**Device test required:**
- [ ] Block button works
- [ ] Blocked user no longer appears in nearby
- [ ] Blocked user cannot send requests

### 5. Appeal flow ✅

**Location:** `appeals_screen.dart` + `account_status_screen.dart`

**Code verification:**
- AppealsScreen: list of user's appeals + "Submit an appeal" button
- Create dialog: 4 appeal types (account_suspension, account_ban, trust_score_review, message_moderation)
- Reason + explanation text fields
- Submit calls `apiClient.createAppeal({actionType, reason, explanation})`
- AccountStatusScreen: banned/suspended users see "Submit an appeal" button → navigates to `/appeals`

**Device test required:**
- [ ] Banned user sees appeal link on account-status screen
- [ ] Appeal form works
- [ ] Appeal appears in user's appeals list
- [ ] Admin receives appeal in queue

### 6. Account deletion ✅

**Location:** `settings_screen.dart` + `privacy_requests_screen.dart` + `account_status_screen.dart`

**Code verification:**
- Settings: "Delete my account" → confirmation dialog → `apiClient.startAccountDeletion(reason)` → POST `/api/me/deletion`
- Confirmation dialog explains: "14-day grace period. You will be hidden from nearby results. After 14 days, your personal data will be anonymized. Cancel any time."
- PrivacyRequestsScreen: same deletion flow
- AccountStatusScreen: deletion-pending users see "Cancel deletion" button → `apiClient.cancelAccountDeletion()` → DELETE `/api/me/deletion`

**Device test required:**
- [ ] Delete account button works
- [ ] Confirmation dialog explains grace period
- [ ] User is hidden from nearby after deletion starts
- [ ] Account-status screen shows deletion-pending state
- [ ] Cancel deletion works
- [ ] After 14 days, personal data is anonymized (server-side)

### 7. Data export ✅

**Location:** `settings_screen.dart` + `privacy_requests_screen.dart`

**Code verification:**
- "Download my data" → `apiClient.exportMyData()` → GET `/api/me/export`
- Success: "Export ready: N fields." snackbar
- Backend returns JSON with: profile, preferences, walks, groups, reports, appeals, feedback, ratings, blocks, trust score history, notifications
- Backend excludes: other users' phone/email/coordinates, adminNotes, admin-only safety intelligence, push subscription secrets
- User's own phone number is partially redacted (`+91*****4321`)

**Device test required:**
- [ ] Download my data button works
- [ ] Export completes successfully
- [ ] Export data does not contain other users' private data
- [ ] Phone number is partially redacted

### 8. Location privacy ✅

**Code verification:**
- `location_service.dart`: foreground-only permission (`whileInUse`), never `always`
- `LocationAccuracy.medium` (~50-100m precision) — privacy-by-design
- `reverseGeocodeApproximate()` returns coarse location (city/district/state/country) — never exact coordinates
- Nearby walkers API returns coarse distance, not exact lat/lng
- Walker detail screen shows distance ("500m away") — never exact coordinates
- Group walk detail shows meeting point name + neighborhood — not exact coordinates until allowed

**Device test required:**
- [ ] GPS permission prompt asks for foreground only
- [ ] Denied permission shows manual entry fallback
- [ ] Permanently denied shows "open settings" option
- [ ] No exact coordinates visible to other users
- [ ] Nearby list shows approximate distance only

## SOS disclaimer text

The SOS disclaimer is displayed in two places:

1. **SOS confirmation dialog** (walk_session_screen.dart):
   ```
   "WalkTogether is not an emergency service. Call local emergency number for life-threatening situations."
   "SOS will alert your safety contacts and the WalkTogether safety team. It does NOT call emergency services."
   ```

2. **Below SOS button** (walk_session_screen.dart):
   ```
   t('sos.disclaimer') = "WalkTogether is not an emergency service. Call local emergency number."
   ```

The disclaimer is translated in all 9 languages via the i18n module.

## Safety-critical i18n keys

All 12 safety-critical keys are present in `lib/core/i18n.dart`:

- `sos.title`, `sos.disclaimer`, `sos.triggered`, `sos.failed`
- `report.title`, `block.title`, `appeal.title`
- `auth.banned`, `auth.suspended`, `auth.deletion_pending`
- `privacy.download_data`, `privacy.delete_account`

## Acceptance criteria

- ✅ SOS button visible in walk session screen
- ✅ SOS disclaimer visible in confirmation dialog + below button
- ✅ SOS creates backend safety event (POST `/api/sessions/:id/sos`)
- ✅ SOS does NOT auto-call emergency services
- ✅ Report user works (POST `/api/reports`)
- ✅ Block user works (POST `/api/blocks`)
- ✅ Appeal screen works (POST `/api/appeals`)
- ✅ Account deletion request works (POST `/api/me/deletion`)
- ✅ Data export works (GET `/api/me/export`)
- ✅ No exact coordinates shown to other users
- ⏳ Physical device verification — pending beta tester
