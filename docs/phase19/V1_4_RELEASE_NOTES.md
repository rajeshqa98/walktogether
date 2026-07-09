# WalkTogether — v1.4 Release Notes

**Phase:** 19
**Release:** v1.4 (Safety Automation + Global Scaling)
**Tagline:** Safer communities, automated admin tools, free for everyone.

---

## What's New in v1.4

WalkTogether v1.4 adds safety automation, admin safety queue, community health scoring, host quality automation, and user-facing safety nudges — all while keeping every feature 100% free.

**Every feature in v1.4 is free.** No premium tier. No subscriptions. No paid filters. No ads.

---

## Highlights

### 🛡️ Safety Automation

10 automated signal types detect risky behavior:
- Repeated reports against same user
- Repeated blocks against same user
- Home address requests in chat
- Private meeting requests in chat
- SOS during active walk
- Host receiving repeated reports
- Rapid join/leave patterns
- Spam invite behavior
- High report rate in group walks
- Repeated unsafe words in chat

**Never auto-bans** — all signals create safety tasks for admin review.

### 📋 Safety Review Tasks

New task system for safety review work:
- 8 task types (repeated reports, SOS review, host review, unsafe chat, etc.)
- 4 priority levels (low, medium, high, urgent)
- Linked to users, group walks, clubs, reports, and SOS events
- Admin assignment and notes
- Full lifecycle tracking (open → reviewing → resolved/dismissed)

### 🔍 Admin Safety Queue

New admin page at `/admin/safety-queue`:
- Summary cards (open, urgent, high, reviewing, resolved, dismissed)
- Filter by status and priority
- Task list with user info and context
- Admin actions: mark reviewing, resolve, dismiss, warn, suspend, ban, cancel walk
- **Every action creates an audit log entry**

### 🏥 Community Health Score

Admin dashboard now includes safety summary:
- Open safety tasks count
- Urgent and high-priority task counts
- Open safety signals count
- Tasks by type breakdown
- Recent SOS count (7-day)

### 🔔 User-Facing Safety Nudges

Contextual safety reminders appear before user actions:
- Before walk request: "Meet only in public places."
- Before chat: "Do not share your home address."
- Before group walk: "Confirm the meeting point is public."
- During night/evening: "For late walks, prefer groups or verified walkers."
- During SOS: "This does not automatically call emergency services."

All nudges are:
- Language-aware (translated in all 9 languages)
- Session-based (shown once per session, then dismissed)
- Non-intrusive (small amber card, dismissible)

### 🌍 Global Community Scaling

Admin community dashboard extended with:
- Safety task counts
- Signal counts by type
- Recent SOS activity
- All existing community growth metrics retained

---

## Behind the Scenes

### New database models
- `SafetySignal` — detected risky behavior patterns
- `SafetyTask` — review tasks for admins
- `HostQualitySnapshot` — periodic host quality rollups

### New API endpoints
- `GET /api/admin/safety-tasks` — list safety tasks with filters
- `PATCH /api/admin/safety-tasks/[id]` — take admin actions on tasks

### Safety automation wired into
- Report creation (`POST /api/reports`)
- Block creation (`POST /api/blocks`)
- SOS trigger (`POST /api/sessions/[id]/sos`)
- Group walk chat moderation (`POST /api/group-walks/[id]/messages`)
- 1:1 chat moderation (`POST /api/requests/[id]/messages`)

---

## Privacy & Safety

v1.4 maintains WalkTogether's privacy-first design:

- ✅ **Approximate location only.** Exact coordinates shared only after accepting a walk.
- ✅ **No exact user coordinates exported** in safety tasks or signals.
- ✅ **Admin sees exact data only if required for safety review.**
- ✅ **Group walk coordinates only visible to joined users.**
- ✅ **SOS** still alerts emergency contacts + safety team. Does NOT auto-call 112/911/100.
- ✅ **Report/Block** still works everywhere.
- ✅ **Moderation** covers 10 languages.
- ✅ **Safety nudges** are language-aware and contextual.
- ✅ **No auto-ban** without admin review.

---

## What's Still Free

Everything. Including:

- ✅ All safety automation features
- ✅ Admin safety queue
- ✅ Safety review tasks
- ✅ User-facing safety nudges
- ✅ Community health scoring
- ✅ Host quality monitoring
- ✅ All 9 language translations
- ✅ All existing features (matching, chat, groups, clubs, SOS, etc.)

---

## Free Product Promise (Reaffirmed)

WalkTogether is and always will be:
- **Free** — no premium, no subscriptions, no paid filters
- **Global** — anyone, anywhere can sign up
- **Safety-first** — women-only, verified-only, SOS, moderation always on, always free
- **Community-led** — hosts and walkers build their own local communities
- **Privacy-respecting** — approximate location, coarse counts, no address collection

If we ever change any of these, we'll tell you months in advance. We promise.

— The WalkTogether Team
