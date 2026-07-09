# WalkTogether

**100% free • safety-first • community-first walking companion app**

Find safe, verified walking partners nearby. Join group walks, build walking clubs, and walk together in your city, town, or village.

No payments. No subscriptions. No premium features. No ads. Safety is not a paid feature — it's a right.

## Repository Structure

```
walktogether/
├── flutter_app/     # Flutter mobile app (Android + iOS)
├── backend/         # Minimal Node.js backend for local/dev testing
├── docs/            # Phase documentation (Phases 27–29)
└── README.md        # This file
```

## Quick Start (Local Development)

### 1. Start the Backend

```bash
cd backend
npm install
npm run dev
```

Backend runs on `http://0.0.0.0:3000` (accessible from your Android phone on the same Wi-Fi).

**Dev OTP:** Always `123456` for any phone number.

Verify backend is running:
```bash
curl http://localhost:3000/api/health
# Expected: {"status":"ok","timestamp":"..."}
```

### 2. Find Your Mac's Wi-Fi IP

```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
# Example: 192.168.1.5
```

### 3. Build & Install Flutter App

```bash
cd flutter_app
flutter pub get
dart analyze

flutter build apk --release \
  --dart-define=API_BASE_URL=http://YOUR_MAC_IP:3000 \
  --dart-define=SOCKET_URL=http://YOUR_MAC_IP:3003

adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### 4. Test on Phone

1. Open WalkTogether app
2. Enter any phone number (e.g. `+919999900000`)
3. Tap "Send OTP"
4. Enter OTP: `123456`
5. Tap "Verify & continue"
6. Complete profile setup
7. Set location (manual village/town/city entry)
8. Home screen loads with nearby walkers

## Backend API

The backend (`backend/server.js`) is a minimal Express.js server with in-memory storage that matches every API route the Flutter app calls.

**Key endpoints:**
- `GET  /api/health` — Health check
- `POST /api/auth/otp/request` — Request OTP (returns devCode: "123456")
- `POST /api/auth/otp/verify` — Verify OTP
- `POST /api/auth/callback/phone-otp` — Sign in (returns session cookie)
- `GET  /api/me` — Get current user
- `PATCH /api/me` — Update profile
- `GET  /api/walkers` — List nearby walkers (coarse distance only)
- `POST /api/requests` — Send walk request
- `GET  /api/requests` — List walk requests
- `POST /api/sessions/:id/sos` — Trigger SOS
- `POST /api/reports` — File report
- `POST /api/blocks` — Block user
- `GET  /api/group-walks` — List group walks
- `GET  /api/clubs` — List clubs
- `POST /api/feedback` — Submit feedback
- `GET  /api/me/export` — Data export (phone partially redacted)
- `POST /api/me/deletion` — Start 14-day account deletion grace period
- `GET  /api/appeals` — List appeals
- `POST /api/appeals` — Submit appeal

See `backend/README.md` for the full API reference.

## Privacy & Safety

- **No exact coordinates** — nearby walkers API returns coarse distance only
- **Phone redaction** — data export partially redacts phone number (`+91*****0000`)
- **No other users' private data** in exports
- **Foreground location only** — app never tracks background location
- **SOS disclaimer** — "WalkTogether is NOT an emergency service. Call local emergency number."
- **14-day account deletion grace period** — cancel any time
- **Manual review** — no auto-ban without admin review

## Free Product Promise

WalkTogether is and will always be 100% free for everyone:
- No payments
- No subscriptions
- No premium features
- No ads
- No monetization

Safety is not a paid feature — it's a right.

## Documentation

- Phase 27: `docs/phase27/` — Mobile feature parity + build verification
- Phase 28: `docs/phase28/` — Closed Android beta plan
- Phase 29: `docs/phase29/` — Beta execution + go/no-go criteria

## License

WalkTogether is free for everyone. No payments, no subscriptions, no premium features, no ads.
