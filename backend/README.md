# WalkTogether Minimal Backend (Dev)

100% free • safety-first • community-first
No payments, no subscriptions, no premium features, no ads

## Quick Start

```bash
cd wt-backend
npm install
node server.js
```

Server runs on `http://0.0.0.0:3000` (accessible from your Android phone on the same Wi-Fi).

## Dev OTP

- **OTP code:** `123456` (always, for all phone numbers)
- The OTP request response includes `devCode: "123456"` for easy testing

## API Endpoints

All routes match the Flutter app's API client exactly.

### Auth
- `GET  /api/auth/csrf` — CSRF token (NextAuth compatibility)
- `POST /api/auth/otp/request` — Request OTP (returns devCode)
- `POST /api/auth/otp/verify` — Verify OTP
- `POST /api/auth/callback/phone-otp` — Sign in (returns session cookie)
- `POST /api/auth/logout` — Logout

### User
- `GET  /api/me` — Get current user
- `PATCH /api/me` — Update profile

### Walkers
- `GET /api/walkers` — List nearby walkers (coarse distance only, no exact coordinates)

### Walk Requests
- `GET  /api/requests` — List incoming + outgoing requests
- `POST /api/requests` — Send walk request
- `PATCH /api/requests/:id` — Accept/decline/cancel

### Messages
- `GET  /api/requests/:requestId/messages` — List messages
- `POST /api/requests/:requestId/messages` — Send message

### Sessions (Walk)
- `POST /api/sessions` — Start walk session
- `GET  /api/sessions/:id` — Get session
- `PATCH /api/sessions/:id` — End session

### Safety
- `POST /api/sessions/:sessionId/sos` — Trigger SOS
- `POST /api/sessions/:sessionId/safety` — Toggle safety share

### Reports + Blocks
- `POST /api/reports` — File report
- `POST /api/blocks` — Block user
- `GET  /api/blocks` — List blocked users
- `DELETE /api/blocks/:id` — Unblock

### Notifications
- `GET  /api/notifications` — List notifications
- `POST /api/notifications/read-all` — Mark all read

### Push
- `POST   /api/me/push-subscription` — Register push token
- `DELETE /api/me/push-subscription` — Remove push token

### Group Walks
- `GET  /api/group-walks` — List group walks
- `POST /api/group-walks` — Create group walk
- `GET  /api/group-walks/:id` — Get group walk detail
- `POST /api/group-walks/:id/join` — Join
- `POST /api/group-walks/:id/leave` — Leave
- `GET  /api/group-walks/:id/messages` — Group chat messages
- `POST /api/group-walks/:id/messages` — Send group message
- `GET  /api/group-walks/:id/participants` — List participants

### Clubs
- `GET  /api/clubs` — List clubs
- `POST /api/clubs` — Create club
- `GET  /api/clubs/:id` — Get club detail
- `POST /api/clubs/:id/join` — Join
- `POST /api/clubs/:id/leave` — Leave
- `GET  /api/clubs/:id/walks` — Club walks

### Feedback
- `POST /api/feedback` — Submit feedback

### Privacy
- `GET  /api/privacy-requests` — List privacy requests
- `POST /api/privacy-requests` — Create privacy request
- `PATCH /api/privacy-requests` — Cancel privacy request

### Account Deletion
- `GET    /api/me/deletion` — Get deletion status
- `POST   /api/me/deletion` — Start 14-day grace period
- `DELETE /api/me/deletion` — Cancel deletion

### Data Export
- `GET /api/me/export` — Export user data (phone partially redacted)

### Appeals
- `GET  /api/appeals` — List appeals
- `POST /api/appeals` — Submit appeal

### Area + Host
- `GET  /api/area` — Area info
- `POST /api/host/onboard` — Become community host

### Health
- `GET /api/health` — Health check
- `GET /api/ready` — Readiness check

## Privacy Rules

- **No exact coordinates** — nearby walkers API returns coarse distance only
- **Phone redaction** — data export partially redacts phone number
- **No other users' private data** — export excludes other users' phone/email/coordinates
- **Session-based auth** — all endpoints require session cookie

## Testing from Flutter App

1. Start backend: `node server.js`
2. Find your Mac's Wi-Fi IP: `ifconfig | grep inet` (e.g. `192.168.1.5`)
3. Rebuild Flutter app with your IP:
   ```bash
   cd flutter_app
   flutter build apk --release \
     --dart-define=API_BASE_URL=http://192.168.1.5:3000
   ```
4. Install on phone: `adb install -r build/app/outputs/flutter-apk/app-release.apk`
5. Open app → enter phone number → tap "Send OTP" → use code `123456`

## Free Product Promise

WalkTogether is 100% free for everyone. No payments. No subscriptions. No premium features. No ads. Safety is not a paid feature — it's a right.
