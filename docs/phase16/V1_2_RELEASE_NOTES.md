# WalkTogether — v1.2 Release Notes

**Phase:** 16
**Release:** v1.2 (Community Growth)
**Date:** Phase 16 release
**Tagline:** Build a walking community anywhere — free, safe, for everyone.

---

## What's New in v1.2

WalkTogether v1.2 turns the app from "find walkers near you" into "grow your own local walking community." Anyone — anywhere in the world, including villages and small towns — can now build a walking community from scratch, even if they're the very first walker in their area.

**Every feature in v1.2 is free.** No premium tier. No subscriptions. No paid filters. No ads. Safety features remain mandatory and always free.

---

## Highlights

### 🌟 First Walker Experience
If you're one of the first walkers in your area, you'll see a special flow with clear actions:
- Invite friends via WhatsApp or shareable link
- Create your first group walk
- Start a local walking club
- Share in your apartment, office, or community groups

**Message:** "Every walking community starts with one person."

### 📍 Local Area Page
A new page for every user location showing:
- Coarse walker count (privacy-safe — never exact)
- Group walks in your area
- Walking clubs in your area
- CTAs to create walks, start clubs, and invite friends
- First-walker banner if you're the only one

### 🔗 Community Invite Links
Share WalkTogether with four types of links:
- **App invite** — generic "join WalkTogether" link
- **Area invite** — link to your local area page
- **Group walk invite** — link to a specific walk (host only)
- **Club invite** — link to a specific walking club (creator only)

Default share copy: *"Join me on WalkTogether and let's build a walking community in our area."*

Links work in the mobile app (if installed) and the web/PWA fallback.

### 🎓 Community Host Onboarding
An 8-step in-app flow that teaches you how to host safe, welcoming group walks:
1. Choose public places
2. Set clear walk time
3. Describe your pace
4. Welcome new walkers
5. Use women-only / verified-only when needed
6. Remove or report unsafe participants
7. Never ask for private addresses
8. Keep group chat respectful

Free, no test, no approval queue. Just education.

### 🏘️ Better Village & Town Support
You can now enter your village, town, district, state, country, timezone, and an optional landmark. If exact geocoding isn't available, you can still use the app — your location will be approximate, and group walks + clubs work without GPS.

### 🔍 Local Walking Clubs Discovery
Browse clubs by type:
- Morning walkers
- Evening walkers
- Women walkers
- Senior walkers
- Dog walkers
- Beginner fitness
- Office walkers

All free, all in your area.

### 🛡️ Safety Education Cards
Small, dismissible safety tips appear throughout the app:
- "Meet only in public places."
- "Do not share your home address."
- "Use report/block if someone makes you uncomfortable."
- "For night walks, prefer groups or verified walkers."
- "SOS does not automatically call emergency services."

### 🌐 Language Preference
Pick your preferred UI language: English, Hindi, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, or French. (Full translations roll out in v1.3 — v1.2 ships the preference field and infrastructure.)

### 📊 Community Growth Dashboard (Admin)
Admins get a new dashboard at `/admin/community` showing:
- Areas with first walkers
- Areas needing host support
- Growing areas
- Active communities
- Areas with safety concerns

Each area gets a recommendation badge: First walker, Needs host, Growing, Active community, or Safety review.

### 🔔 New Notifications
New free notification types:
- Someone joined your club
- Someone joined your group walk
- (More to come in v1.3: new walker in area, new club nearby, new walk nearby, walk reminders)

### 🚫 Better Moderation
Group chats and direct messages are now moderated in:
- English
- Hindi (Devanagari + Roman)
- Hinglish (transliterated)
- Telugu
- Tamil
- Spanish
- Arabic
- French

High-severity terms are auto-blocked. Medium-severity terms are flagged for admin review (still visible to participants). We prefer flagging over blocking to avoid censoring normal conversation.

---

## Behind the Scenes

### Database changes
- New `User` fields: `village`, `town`, `district`, `stateRegion`, `countryCode`, `timezone`, `landmark`, `language`, `isCommunityHost`, `hostOnboardedAt`
- New `GroupWalk` and `WalkingClub` fields: `country`, `stateRegion`, `district`, `village`
- New models: `InviteLink`, `InviteLinkVisit`, `AreaActivity`, `HostEvent`, `InviteAbuseFlag`

### New API endpoints
- `POST /api/invite-links` — create invite link
- `GET /api/invite-links/[code]` — resolve invite link
- `GET /api/area` — get area page
- `GET /api/clubs/nearby` — nearby clubs with filters
- `POST /api/host/onboard` — complete host onboarding
- `GET /api/admin/community` — admin community dashboard
- `POST /api/analytics/events` — client-side analytics

### New screens
- `area_page` — local area community page
- `host_onboarding` — 8-step host onboarding
- `first_walker` — first walker in area special flow
- `share_sheet` (modal) — invite link share sheet

---

## Privacy & Safety

v1.2 maintains WalkTogether's privacy-first design:

- ✅ **Approximate location only.** Exact coordinates are shared only after you accept a walk request.
- ✅ **Coarse walker counts.** Area pages never show counts ≤3 to avoid singling out individuals.
- ✅ **No meeting point exposure.** Invite links never expose meeting point coordinates.
- ✅ **Women-only and verified-only filters** are still enforced at join time, regardless of how the user arrived (invite link, search, etc.).
- ✅ **SOS** still alerts your emergency contacts and our safety team. SOS does NOT auto-call 112/911/100 — you must call emergency services directly if you're in danger.
- ✅ **Report/Block** still works everywhere.
- ✅ **Moderation** now covers 8+ languages.

---

## What's Still Free

Everything. Including:

- ✅ Matching with nearby walkers
- ✅ Group walks (create + join)
- ✅ Walking clubs (create + join)
- ✅ Women-only groups
- ✅ Verified-only groups
- ✅ All safety features (SOS, report/block, approximate location)
- ✅ Invite links (unlimited, with fair-use rate limits)
- ✅ Host onboarding
- ✅ Area page
- ✅ Language preference
- ✅ All notifications

---

## What's NOT in v1.2 (Coming in v1.3+)

- Full UI translations (Hindi first, then Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French)
- Geocoding API integration (so village/town entries get real coordinates)
- Profile photo upload
- Walking route suggestions
- Scheduled one-to-one walks
- Apple Health / Google Fit sync
- Offline mode
- RTL layout for Arabic
- "New walker in your area" push notifications (infrastructure is ready, rollout in v1.3)

---

## Mobile App (Flutter)

The Flutter app already supports the v1.2 features (since Phase 14-15). The web/PWA now matches parity:
- Area page
- First walker flow
- Host onboarding
- Invite link share and resolution
- Language preference

Mobile deep linking:
- `/?invite=wt-XXXXXXXX` opens the corresponding screen in the app if installed.

---

## Upgrade Notes

v1.2 is a backwards-compatible release. No data migration is required — the schema additions are all nullable or have defaults.

For developers:
1. Pull the latest `main` branch.
2. Run `bun run db:push` to apply schema changes.
3. Run `bun run lint` to verify.
4. The dev server picks up the new Prisma client automatically.

For users:
- No action required. The next time you open the app, you'll see the new features.
- Your existing account, walks, clubs, and messages are unaffected.

---

## Acknowledgments

v1.2 was built based on learnings from the Phase 15 global free launch. The Phase 15 v1.2 improvement backlog identified 15 features; v1.2 ships the top 13. The remaining 2 (profile photo upload, walking route suggestions) are deferred to v1.3.

Thank you to every walker who signed up in Phase 15 — including those in villages and towns we'd never heard of. You showed us that the app needed to support community building from scratch, not just matching in dense cities. v1.2 is for you.

---

## Free Product Promise

WalkTogether is and always will be:
- **Free** — no premium, no subscriptions, no paid filters
- **Global** — anyone, anywhere can sign up
- **Safety-first** — women-only, verified-only, SOS, moderation always on
- **Community-led** — hosts and walkers build their own local communities
- **Privacy-respecting** — approximate location, coarse counts, no address collection

If we ever change any of these, we'll tell you months in advance. We promise.

— The WalkTogether Team
