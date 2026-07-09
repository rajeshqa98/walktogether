# WalkTogether — First Walker Experience

**Phase:** 16
**Status:** Implemented
**Files:** `src/components/screens/FirstWalkerExperience.tsx`, `src/components/screens/Home.tsx` (empty state)

---

## 1. The Problem

In low-density areas — a village, a small town, a new city — a user may sign up and find zero walkers nearby. The default reaction is to leave. WalkTogether's v1.2 goal is to flip this: instead of treating "no walkers nearby" as a failure, treat it as an invitation to start.

The First Walker Experience is the headline feature of this strategy. It tells the user: "You're one of the first walkers here. Every walking community starts with one person. Here's how to start."

---

## 2. When It Shows

The First Walker screen is shown:

1. **From the Home screen empty state** — a "First walker in your area?" button appears when no walkers are found nearby.
2. **From the Area page** — a first-walker banner appears when `isFirstWalker === true` (area has ≤ 1 user).
3. **From Settings** — a "First walker flow" entry in the Community section.

The screen is opt-in — users don't have to view it. But the CTAs are always reachable from the no-walkers empty state.

---

## 3. Screen Content

### Header
- Back button (returns to home)
- "First walker" title

### Hero card

> ✨ **You're one of the first walkers here.**
>
> Every walking community starts with one person. Invite 2–3 friends, create your first group walk, and start building a local walking community.

### Action rows (in priority order)

#### 1. Invite friends (primary)
> Share an invite link via WhatsApp, SMS, or in person.

Tapping opens the ShareSheet with `targetType="app"`. The default message: "Join me on WalkTogether and let's build a walking community in our area."

#### 2. Create first group walk
> Pick a public place, set a time, and welcome new walkers.

Tapping navigates to `group_create`.

#### 3. Start a local walking club
> Morning, evening, women-only, senior — pick your type.

Tapping navigates to `club_create`.

#### 4. Share in WhatsApp / community groups
> Apartment, office, family, neighborhood groups — spread the word.

Tapping opens WhatsApp with a pre-filled message: "Join me on WalkTogether and let's build a walking community in our area." + the app URL.

### Increase radius tip card
> **Increase your radius**
> Try expanding from 500m to 1km or 2km on the home screen to see walkers in nearby neighborhoods.

With a "Go to home →" link.

### Safety tip
Inline safety education card: "Meet only in public places."

### Closing message
> 🛡️ WalkTogether is free, everywhere. Villages, towns, and cities are all welcome. Safety features are always on, always free.

---

## 4. Analytics Events

The First Walker screen fires these events:

| Event | When |
|-------|------|
| `first_walker_invite_clicked` | User taps "Invite friends" |
| `first_walker_create_group_clicked` | User taps "Create first group walk" |
| `first_walker_create_club_clicked` | User taps "Start a local walking club" |
| `first_walker_share_whatsapp_clicked` | User taps "Share in WhatsApp" |

Plus the empty-state events (fired from the Home screen):

| Event | When |
|-------|------|
| `no_walkers_nearby_seen` | Empty state renders |
| `invite_from_empty_state_clicked` | User taps "Invite friends" |
| `create_club_from_empty_state_clicked` | User taps "Start a walking club" |
| `create_group_from_empty_state_clicked` | User taps "Create a group walk" |

These events help measure:
- How often users hit the empty state
- Which CTAs they click
- Conversion rate from empty state → first walk/club created

---

## 5. Design Philosophy

### "Every walking community starts with one person."

This phrase appears in:
- The First Walker hero card
- The Home screen empty state
- The Area page first-walker banner

It's the v1.2 mantra. The point is to reframe "no walkers nearby" from "this app doesn't work here" to "this app needs you to start."

### No pressure

The screen never says "you must invite friends" or "you must create a walk." Every CTA is optional. The user can close the screen and just keep checking back periodically.

### No false promises

We don't promise walkers will magically appear. We promise tools: invite links, group walk creation, club creation, host onboarding. The community has to actually be built by the user.

---

## 6. Integration Points

The First Walker screen weaves together several v1.2 features:

- **ShareSheet** — for the invite friends CTA
- **Group Walk Create** — for the create walk CTA
- **Club Create** — for the start club CTA
- **Safety Education Cards** — for the safety tip
- **Analytics** — for tracking funnel conversion

It's a hub that connects all the community-growth features into a single onboarding moment for low-density users.

---

## 7. Mobile (Flutter)

The Flutter app has a corresponding `FirstWalkerScreen` widget (already implemented in v1.1) with the same hero, action rows, and analytics events.

---

## 8. Acceptance Criteria

- [x] First Walker screen is reachable from Home empty state, Area page, and Settings.
- [x] Screen shows clear hero message: "You're one of the first walkers here."
- [x] All four CTAs work: invite, create walk, start club, share WhatsApp.
- [x] Analytics events fire on each CTA tap.
- [x] Safety tip is shown.
- [x] "Every walking community starts with one person." appears as the closing message.
- [x] Screen is free — no premium gating.
