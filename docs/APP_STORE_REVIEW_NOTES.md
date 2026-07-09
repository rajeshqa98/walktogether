# WalkTogether — App Store Review Notes

## App Information
- **App Name:** WalkTogether
- **Bundle ID:** com.walktogether.app
- **Category:** Health & Fitness / Social Networking
- **Primary Function:** Safety-first walking companion app that helps users find nearby verified walking partners and join community group walks.

---

## Reviewer Demo Credentials

**Phone:** +919999900000  
**OTP:** Use "Continue as demo user" button (bypasses OTP in dev mode)  
**Admin panel:** Not part of the mobile app — web only at /admin

For testing without demo bypass:
1. Enter any phone number (e.g., +919876543210)
2. Tap "Send OTP" — in dev mode, any 4-6 digit code works
3. The OTP code will be displayed on-screen in dev mode

---

## Why Location Is Needed

WalkTogether uses location to find nearby walking partners. Specifically:
- **Foreground location only** — we never request background location
- Location is used to calculate **approximate distance labels** ("within 300m", "within 500m") — exact coordinates are never shown to other users
- After mutual match acceptance, only the **public meeting point coordinates** are shared (parks, cafes, landmarks — never private residences)
- Location snapshots expire after 1 hour of inactivity

**Permission text shown to user before requesting:**  
*"WalkTogether uses your location only to find nearby walking partners. Your exact location is hidden until both users agree to walk together."*

---

## Location Privacy Model

1. User grants foreground location permission
2. App sends GPS coordinates to server
3. Server calculates haversine distance to other users
4. Server converts distance to approximate label ("within 300m")
5. **Server strips exact coordinates** from API response
6. Client only receives the label — never raw coordinates
7. After mutual walk request acceptance, server shares public meeting point coordinates (pre-approved public places only)
8. User's private GPS is never shared with other users at any point

---

## How Moderation Works

1. **Auto-moderation:** Chat messages are scanned for banned words. Flagged messages are persisted for admin review but not delivered to the recipient.
2. **User reports:** Users can report other users during post-walk rating or from chat. Reports include reason (harassment, fake profile, unsafe behavior, spam, inappropriate message, other) and optional evidence text.
3. **Admin review:** Admin panel (web-only) shows all reports with reporter, reported user, reason, and evidence. Admins can warn, suspend, or ban users.
4. **Block:** Users can instantly block any other user. Blocked users cannot see each other or send requests.
5. **Audit trail:** Every admin action is recorded in an immutable audit log.

---

## How Reports Are Handled

1. User submits report (post-walk or from chat)
2. Report appears in admin Reports queue (web panel at /admin/reports)
3. Admin reviews and takes action: mark reviewing, dismiss, resolve, warn user, suspend user, or ban user
4. If 3+ reports exist for the same user, trust score is automatically reduced by 10 points
5. Banned users are hidden from nearby walkers, their presence is set to hidden, trust score is locked, and pending walk requests are cancelled
6. All admin actions create audit log entries

---

## How to Test SOS Without Calling Real Emergency Services

**Important:** The SOS button does NOT call emergency services. It:
1. Shows a confirmation dialog: "Trigger SOS? This will instantly share your live location with your emergency contact..."
2. On confirm: creates a SafetyEvent record (high priority) in the database
3. Notifies the walking partner via push notification
4. Auto-creates a report against the partner for admin review
5. Shows in-app confirmation: "Safety alert prepared. Contact your emergency contact or local emergency service (112 in India)."

**To test:** Start a walk session → tap SOS → confirm in dialog → verify confirmation message appears. No real emergency service is contacted.

---

## Account Deletion Path

1. Open Settings
2. Scroll to "Account" section
3. Tap "Delete account"
4. Confirmation dialog explains data will be deleted within 30 days per DPDP Act
5. On confirm: all user data (profile, chats, ratings, push subscriptions) is deleted
6. Safety events, reports, and audit logs are retained for compliance but anonymized

---

## User-Generated Content Moderation

WalkTogether contains user-generated content in:
- **Chat messages** (one-to-one and group): Auto-moderated for banned words. Flagged messages reviewed by admin.
- **Profile bios**: Visible to other users. Can be reported.
- **Group walk descriptions**: Visible in group walk listings. Can be reported.
- **Feedback messages**: Visible only to admins.

**Moderation features:**
- ✅ Report user flow (post-walk + from chat)
- ✅ Block user flow (instant, bidirectional)
- ✅ Auto-moderation of chat messages
- ✅ Admin moderation panel (web-only)
- ✅ Audit trail for all admin actions
- ✅ User suspension and banning

---

## Privacy Nutrition Labels (App Store)

**Data Used to Track You:** None  
**Data Linked to You:**
- Contact Info: Phone Number (for authentication)
- Location: Precise Location (for nearby matching — but NOT shared with other users)
- User Content: Chat messages (between matched users only)
- Identifiers: Push notification token
- Usage Data: Analytics events (product analytics)

**Data Not Linked to You:**
- Diagnostics: Crash data (if Firebase Crashlytics enabled)

---

## Notification Permission

Notifications are requested **only after user action** (tapping "Enable" in Settings). We do not request notification permission on first launch.

**Notification types:**
- New walk request
- Request accepted/declined
- New chat message
- Group walk started/ended/cancelled
- SOS/safety alerts (always on when push is enabled — cannot be disabled)

---

## App Review Notes

1. This is a **safety-first walking companion app**, NOT a dating app. All marketing, copy, and UX positioning emphasizes safety, community, and fitness.
2. The app uses **invite-only pilot mode** during closed testing. Non-invited users see a waitlist screen. Set `PILOT_MODE=invite_only` in backend env.
3. The admin moderation panel is **web-only** at `/admin` — it is not part of the mobile app.
4. Demo login: Use "Continue as demo user" button on the login screen.
5. The app connects to a backend API at the configured URL. For testing, ensure the backend is running.

---

## TestFlight Notes

1. Upload build via Xcode or `flutter build ipa`
2. Add internal testers in App Store Connect
3. Add external testing group (up to 10,000 testers)
4. Reviewer notes: Use demo login button for quick access
5. TestFlight build expires after 90 days — re-upload as needed
6. Crash reports available in App Store Connect if Crashlytics is configured
