# WalkTogether — Privacy Policy

**Last updated:** July 2025  
**Effective date:** July 2025

WalkTogether ("we", "us", "our") operates the WalkTogether mobile application and web platform ("the App"). This Privacy Policy explains how we collect, use, store, and protect your personal data when you use the App.

We are committed to complying with the Digital Personal Data Protection Act, 2023 (DPDP Act) of India and applicable data protection laws.

---

## 1. Data We Collect

### 1.1 Account Data
- **Phone number**: Used for OTP-based authentication. We store your phone number to verify your identity during signup and login.
- **Name**: The name you provide during profile setup, visible to other users on your walker card.
- **Age range**: One of 18-24, 25-34, 35-44, 45-54, 55+. We never store your exact date of birth.
- **Gender**: Used for women-only matching filters. You can choose female, male, or non-binary.
- **Profile photo**: Optional. If provided, stored securely and visible to other users.
- **Bio**: Optional text you write about yourself, visible on your profile card.

### 1.2 Location Data
- **Approximate location**: When you grant location permission, we use your GPS coordinates **only on the server** to calculate approximate distance labels ("within 300m", "within 500m") for nearby walkers. **Your exact live coordinates are never shown to other users.**
- **Exact location after mutual match**: Only after both users have mutually accepted a walk request, or after you join a group walk, do we share the public meeting point coordinates with participants. We never share your private home address or real-time GPS with other users.
- **Manual location**: If you choose manual location selection, we store the neighborhood/city you pick — not GPS coordinates.
- **Location retention**: Live location snapshots expire automatically after 1 hour of inactivity. We do not collect background location. We do not track your movement.

### 1.3 Communication Data
- **Chat messages**: One-to-one and group chat messages are stored on our servers. Messages are visible only between matched users or within joined group walk participants.
- **Message moderation**: Messages are automatically scanned for prohibited content. Flagged messages are reviewed by our moderation team. We do not expose private chats to administrators unless they are flagged for moderation.

### 1.4 Safety Data
- **SOS events**: When you trigger SOS during a walk, we record a SafetyEvent with timestamp, session ID, and the users involved. This is retained permanently for safety and compliance.
- **Safety share**: When you activate live safety share, we notify your emergency contact and your walking partner. The share is deactivated when you end the walk or toggle it off.
- **Reports**: When you report a user, we store the report reason, evidence text, reporter ID, and reported user ID. Reports are retained permanently.

### 1.5 Notification Data
- **Push notification tokens**: We store FCM (Firebase Cloud Messaging) tokens or web push subscription keys to send you notifications about walk requests, messages, and safety alerts. You can disable push notifications at any time in Settings.
- **Notification records**: In-app notification records (walk request, chat message, SOS alert, etc.) are stored for 90 days, then automatically deleted.

### 1.6 Analytics Data
- **Event tracking**: We track product analytics events (e.g., "signup_completed", "nearby_search_performed", "walk_request_sent") to understand app usage and improve the product. These events are associated with your user ID but do not include personal message content or exact location.
- **Aggregated metrics**: We aggregate analytics into daily snapshots (total users, active users, walk requests, etc.) for operational dashboards.

### 1.7 Waitlist and Feedback Data
- **Waitlist**: If you join the waitlist during closed pilot, we store your name, phone, city, neighborhood, preferred walking time, safety concerns, and referral source.
- **Feedback**: When you submit feedback, we store your user ID, category, rating, message, and timestamp.

### 1.8 Device and Technical Data
- **IP address**: Logged temporarily for rate limiting and security.
- **Device type**: Push subscription user agent for display purposes.
- **Last active timestamp**: Updated when you use the app, used for presence indicators ("Available now", "Recently active", "Offline").

---

## 2. How We Use Your Data

### 2.1 Core App Functionality
- Match you with nearby walking partners using approximate distance
- Enable chat between mutually matched users
- Suggest public meeting points for walks
- Send notifications about walk requests, messages, and safety events
- Display your profile (name, age range, verified badge, trust score) to other users

### 2.2 Safety and Trust
- Enforce safety rules (women-only groups, verified-only filters, banned/suspended user blocking)
- Process SOS events and safety shares
- Review reports and take moderation action (warn, suspend, ban)
- Calculate trust scores based on completed walks and ratings

### 2.3 Analytics and Improvement
- Track funnel metrics to understand user journeys
- Monitor safety analytics (reports, SOS events, flagged messages)
- Identify and fix bugs through feedback and crash reports

### 2.4 Pilot Operations
- Control access during closed pilot (invite-only mode)
- Manage waitlist and pilot invites
- Monitor platform health via admin dashboards

---

## 3. What We Do NOT Do

- ❌ **We do not sell your data** to any third party.
- ❌ **We do not show your exact live location** to other users. Only approximate distance labels are shown.
- ❌ **We do not track your background location.** Location is used only in the foreground during active app use.
- ❌ **We do not share your phone number** with other users. Phone numbers are used only for OTP authentication.
- ❌ **We do not expose your private chats** to administrators unless flagged by auto-moderation.
- ❌ **We do not use your data for advertising.**
- ❌ **We do not share your data with social media platforms.**

---

## 4. Data Sharing

### 4.1 With Other Users
Other users can see:
- Your name, age range, gender, and bio (on your profile card)
- Your approximate distance label (e.g., "within 300m")
- Your verified badge and trust score
- Your walking preferences (pace, walk types, languages)
- Your presence status ("Available now", "Recently active", "Offline")
- Your messages (only after mutual match or group walk join)
- The public meeting point name (always); coordinates only after joining

### 4.2 With Service Providers
- **Firebase (Google)**: Push notification delivery via FCM
- **SMS provider (MSG91/Twilio)**: OTP delivery only — they receive your phone number for SMS delivery, nothing else
- **Cloud hosting**: Database and application hosting

### 4.3 Legal Compliance
We may disclose data if required by law, court order, or government request under applicable Indian law, including the DPDP Act.

---

## 5. Data Retention

| Data Type | Retention Period |
|-----------|-----------------|
| Account data | Until account deletion request |
| Live location snapshots | 1 hour after last activity |
| OTP attempt records | 1 hour |
| Chat messages | Retained while account is active |
| Group walk messages | Retained while group walk exists |
| Safety events (SOS) | Permanent (compliance) |
| Reports | Permanent (compliance) |
| Audit logs | Permanent (compliance) |
| Push notification tokens | Until logout or app uninstall |
| In-app notifications | 90 days |
| Analytics events | 90 days (event records); permanent (aggregated daily snapshots) |
| Waitlist entries | Until invited or rejected |
| Feedback | Until reviewed and archived |

---

## 6. Your Rights (India DPDP Act)

Under the Digital Personal Data Protection Act, 2023:

### 6.1 Right to Access
You can request a summary of the personal data we hold about you and how it is being processed.

### 6.2 Right to Correction
You can request correction of inaccurate or incomplete personal data. Most profile data can be updated directly in the App's Settings or Profile screen.

### 6.3 Right to Erasure
You can request deletion of your account and personal data. Account deletion is available in Settings → Account → Delete account. Upon request:
- Your profile, preferences, and presence data are immediately deleted
- Your chat messages are deleted
- Your push subscriptions are deleted
- Safety events, reports, and audit logs are retained for compliance but anonymized
- Deletion is completed within 30 days

### 6.4 Right to Withdraw Consent
You can withdraw consent for:
- Location tracking (disable in Settings → Hide me from nearby)
- Push notifications (disable in Settings → Notifications)
- Analytics (contact us to opt out)

### 6.5 Right to Grievance Redressal
If you have a complaint about how we handle your data, contact our Grievance Officer (see Section 8).

---

## 7. Security Measures

- **OTP codes** are hashed (SHA-256 + server secret) before storage — never plaintext
- **Session tokens** are stored securely (HTTPS-only cookies on web, secure storage on mobile)
- **Rate limiting** prevents brute-force OTP attacks (max 5 attempts, 30-second resend cooldown)
- **Location privacy**: Exact coordinates are computed server-side only and stripped before sending to clients
- **Moderation**: Auto-moderation flags prohibited content; admin reviews flagged messages
- **Access control**: Admin panel requires admin role; all admin actions are audit-logged
- **Banned users** cannot log in or interact with the platform

---

## 8. Contact

**Grievance Officer:** safety@walktogether.app  
**Data Protection Contact:** privacy@walktogether.app  
**Support:** support@walktogether.app

---

## 9. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify you of significant changes via in-app notification or SMS. The "Last updated" date at the top of this policy indicates when it was last revised.

---

## 10. Children's Privacy

WalkTogether is not intended for users under 18. We do not knowingly collect data from children. If you believe a child has provided us with personal data, please contact us immediately.

---

*This Privacy Policy is designed to comply with the Digital Personal Data Protection Act, 2023 (India) and general data protection principles. WalkTogether is a safety-first product — your privacy and physical safety are our top priorities.*
