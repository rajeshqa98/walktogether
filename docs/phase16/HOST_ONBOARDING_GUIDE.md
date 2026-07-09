# WalkTogether — Host Onboarding Guide

**Phase:** 16
**Status:** Implemented
**Files:** `src/components/screens/HostOnboarding.tsx`, `src/app/api/host/onboard/route.ts`
**Audience:** Community hosts (existing and aspiring)

---

## 1. What is a Community Host?

A Community Host is any verified WalkTogether user who has completed the free 8-step host onboarding flow and committed to hosting safe, welcoming group walks and walking clubs in their area.

**Hosts are NOT:**
- Paid employees of WalkTogether
- Required to host a minimum number of walks
- Given special moderation powers beyond their own walks/clubs
- Required to share personal contact info

**Hosts ARE:**
- Verified walkers who have completed onboarding
- Eligible for a "Community Host" badge on their profile
- Tracked in the admin Community Growth Dashboard (via `HostEvent` rows)
- Encouraged (but not required) to create the first walk in their area

---

## 2. How to Become a Host

1. Sign up and complete profile setup.
2. Complete selfie verification (Settings → Verify).
3. Open Settings → Community → "Become a Community Host".
4. Walk through the 8-step onboarding flow.
5. On completion: `isCommunityHost = true`, `hostOnboardedAt = now()`.
6. The user is now a host. They can create group walks and walking clubs (verified users could already do this, but now they have the host badge + onboarding context).

The onboarding is **idempotent** — calling `POST /api/host/onboard` again just refreshes the timestamp. There is no test, no quiz, no approval queue.

---

## 3. The 8-Step Onboarding Flow

### Step 1 — Choose public places

> Pick meeting points that are well-lit, public, and easy to reach — parks, markets, plazas, transit stops. Never meet at a private home or isolated spot.

**Points:**
- Parks, markets, and plazas only
- Avoid private homes and isolated locations
- Pick a spot with mobile signal

### Step 2 — Set a clear walk time

> Be specific — date, start time, and expected duration. Walkers should know exactly when to arrive and how long the walk will last.

**Points:**
- Always include start time AND duration
- Wait 10 minutes max for latecomers
- Cancel or postpone early if weather is bad

### Step 3 — Describe your pace

> Be honest about whether your walk is slow & social, normal, or brisk fitness. Walkers should know what to expect before joining.

**Points:**
- Slow = stroll & chat (good for beginners)
- Normal = steady pace
- Fast = brisk workout

### Step 4 — Welcome new walkers

> Greet every new walker by name. Make introductions. A warm welcome is the single biggest reason walkers come back.

**Points:**
- Greet every walker by name
- Introduce regulars to newcomers
- Pair up first-timers with a buddy

### Step 5 — Use women-only / verified-only when needed

> If your group is for women only, mark it as women_only. If you want only verified walkers, mark it as verified_only. These filters are free and always will be.

**Points:**
- Women-only groups: only women can see and join
- Verified-only groups: only selfie-verified walkers can join
- Both filters are completely free

### Step 6 — Remove or report unsafe participants

> As a host, you can remove anyone from your group walk or club. If someone behaves unsafely, report them — our team reviews every report.

**Points:**
- Remove participants who make others uncomfortable
- Use Report/Block from the walker's profile
- Trigger SOS if anyone is in immediate danger

### Step 7 — Never ask for private addresses

> Never ask walkers for their home address, exact location, or personal contact info outside the app. WalkTogether keeps everyone's location approximate by design.

**Points:**
- Never ask for home addresses
- Use in-app chat only — no phone numbers needed
- Approximate location is the safety default

### Step 8 — Keep group chat respectful

> Set the tone. No abusive language, no spam, no unsolicited DMs. WalkTogether moderates group chats in English, Hindi, Hinglish, Telugu, Tamil, and more.

**Points:**
- No abusive, sexual, or hateful language
- No spam or unsolicited promotions
- Flagged messages go to admin review

---

## 4. Host Privileges

Once onboarded, hosts can:

- ✅ Create unlimited group walks (subject to fair-use rate limits)
- ✅ Create unlimited walking clubs
- ✅ Send announcements in group chats
- ✅ Remove participants from their walks/clubs
- ✅ Cancel their own walks
- ✅ Display the "Community Host" badge on their profile

Hosts cannot:

- ❌ Edit or cancel other hosts' walks
- ❌ Ban or suspend users (that's admin-only)
- ❌ See exact locations of walkers who haven't accepted a walk with them
- ❌ Bypass women-only or verified-only eligibility checks

---

## 5. Host Events Tracking

The `HostEvent` Prisma model logs host lifecycle events for the admin dashboard:

| `eventType` | Fired when |
|-------------|------------|
| `onboarded` | User completes host onboarding |
| `first_walk_hosted` | Host creates their first group walk |
| `first_club_created` | Host creates their first walking club |
| `support_requested` | Host requests support (future) |
| `safety_flag` | Host's walk has a safety event (future) |

Each event stores the `areaSlug` so admins can see which areas have active hosts.

---

## 6. Admin View

Admins can see host activity via:
- The Community Growth Dashboard (`/admin/community`) — areas with hosts are tagged "active community"
- The Users page (`/admin/users`) — host badge shown on user profiles

There is no separate "Host Management" admin page in v1.2. Host management is light-touch — hosts are users, not employees.

---

## 7. Common Questions

**Q: Can I lose my host status?**
A: Not in v1.2. If your account is suspended or banned, you lose hosting privileges (creating walks/clubs) but the `isCommunityHost` flag stays. In v1.3, we may add a host-status review process for reported hosts.

**Q: Do I have to host a minimum number of walks?**
A: No. Host the walks you want, when you want. Even one walk a month is enough.

**Q: Can I co-host with a friend?**
A: Yes — both of you should complete host onboarding. Only one person can be the official "host" of a group walk (the creator), but you can invite your friend as a participant and they can help manage the walk.

**Q: What if no one joins my walk?**
A: Try inviting friends directly (via ShareSheet), posting in local WhatsApp groups, or picking a more popular time (weekend mornings work well). Be patient — communities take time to build.

**Q: Is hosting free?**
A: Yes. 100% free. No premium tier. No fees. No paid filters.

---

## 8. Safety Reminders for Hosts

These reminders appear throughout the host experience (in onboarding, in the walk creation form, and on the area page):

1. **Meet only in public places.**
2. **Do not ask for private addresses.**
3. **Use women-only / verified-only filters when appropriate.**
4. **Remove or report anyone who makes others uncomfortable.**
5. **SOS does not automatically call emergency services — call 112/911/100 directly if needed.**

---

## 9. Acceptance Criteria

- [x] Any verified user can complete host onboarding.
- [x] Onboarding is free, in-app, and takes < 5 minutes.
- [x] No test, no quiz, no approval queue.
- [x] Host badge appears on profile after onboarding.
- [x] Host events are tracked for the admin dashboard.
- [x] Onboarding is idempotent (re-completion refreshes timestamp).
