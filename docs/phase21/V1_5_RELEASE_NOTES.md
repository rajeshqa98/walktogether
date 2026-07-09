# WalkTogether — v1.5 Release Notes

**Phase:** 21
**Release:** v1.5 (User Appeals & Community Governance)
**Tagline:** Fair, explainable, and recoverable safety for everyone.

---

## What's New in v1.5

WalkTogether v1.5 adds user appeals, trust score transparency, community governance guidelines, and moderation decision templates — making safety enforcement human, explainable, and recoverable.

**Every feature in v1.5 is free.** No premium tier. No subscriptions. No paid filters. No ads.

---

## Highlights

### 🛡️ User Appeal Flow

Users can now appeal moderation actions:
- Account suspension
- Account ban
- Host ability suspension
- Group walk cancellation
- Club restriction
- Trust score review
- Message moderation flag

**How it works:**
1. User opens Settings → Appeals & Trust
2. User selects action type and writes reason + explanation
3. Appeal is submitted for admin review
4. User receives notification when appeal is resolved
5. Approved appeals can restore account, host ability, and trust score

**Copy is calm and respectful:**
> "Your account is temporarily restricted while our safety team reviews activity. You can submit an appeal if you believe this was a mistake."

### 📋 Admin Appeals Queue

New admin page at `/admin/appeals`:
- Summary cards (submitted, under review, needs info, approved, rejected, closed)
- Filter by status
- Appeal list with user context (name, phone, trust score, status, host badge)
- Admin actions: start review, request info, approve, reject, close
- Approve can restore account, host ability, and trust score (+15)
- Every action creates an audit log entry
- Users receive push notifications on decisions

### 🔍 Trust Score Transparency

Users can now understand their trust score:
> "Trust score helps the community understand reliability and safety. It considers profile verification, completed walks, ratings, safety signals, and reviewed reports. Reports trigger review, not automatic punishment. False positives can be corrected. You can appeal any restriction."

The exact scoring formula is NOT exposed — only the high-level factors.

### 📊 Trust Recovery Rules

Fair recovery rules ensure users can recover from mistakes:
- False positives restore trust (+10 dismissed, +15 appeal approved)
- Completed safe walks slowly improve trust (+1 per 4-5 star rating)
- Good ratings slowly improve trust (+1 per positive rating)
- Old minor issues lose weight over time
- Severe confirmed abuse remains serious (trustLocked)
- SOS events do NOT automatically reduce trust
- Reports trigger review, not automatic punishment (-5 at 3+ reports)

### 📝 Moderation Decision Templates

10 decision templates for consistent messaging:
- Warning issued, temporary suspension, permanent ban
- Appeal approved, appeal rejected
- Host ability restored, group walk cancelled
- False positive confirmed, needs more information
- Safety concern acknowledged

### 🏛️ Community Governance Guidelines

Published guidelines covering:
- Free community-first principle
- Safety-first principle
- No paid safety
- No harassment, no private-location pressure, no dating/spam misuse
- Public meeting point rule
- Women-only group respect
- Host responsibility
- Report/block encouragement
- Appeal rights

### 🤖 Human Review Policy

Safety automation never feels unfair:
- Automation creates tasks, not final punishment
- Admin reviews all serious actions (warn/suspend/ban)
- False positives can be marked and corrected
- Trust can recover from mistakes
- Appeals are available for all restrictions
- Users receive understandable explanations

---

## Behind the Scenes

### New database model
- `Appeal` — user appeals with 7 action types, 6 statuses, admin notes, decision templates

### New API endpoints
- `GET /api/appeals` — User lists their appeals
- `POST /api/appeals` — User submits a new appeal
- `GET /api/appeals/[id]` — User views a specific appeal
- `GET /api/admin/appeals` — Admin lists appeals queue
- `PATCH /api/admin/appeals/[id]` — Admin reviews/resolves appeal

### New screens
- User appeal screen (accessible from Settings → Appeals & Trust)
- Admin appeals queue page (`/admin/appeals`)

---

## Privacy & Safety

v1.5 maintains WalkTogether's privacy-first design:

- ✅ **Approximate location only.** Exact coordinates shared only after accepting a walk.
- ✅ **No exact user coordinates** in appeal data.
- ✅ **Admin sees exact data only** if required for safety review.
- ✅ **SOS** still alerts emergency contacts + safety team. Does NOT auto-call 112/911/100.
- ✅ **Report/Block** still works everywhere.
- ✅ **Appeals** provide a fair recovery path for all users.
- ✅ **False positives** are correctable with trust restoration.
- ✅ **No auto-ban** without admin review.

---

## What's Still Free

Everything. Including:

- ✅ User appeals
- ✅ Admin appeals queue
- ✅ Trust score transparency
- ✅ Trust recovery (false positive restoration)
- ✅ Moderation decision templates
- ✅ Community governance guidelines
- ✅ All existing features (matching, chat, groups, clubs, SOS, etc.)

---

## Free Product Promise (Reaffirmed)

WalkTogether is and always will be:
- **Free** — no premium, no subscriptions, no paid filters
- **Global** — anyone, anywhere can sign up
- **Safety-first** — women-only, verified-only, SOS, moderation always on, always free
- **Community-led** — hosts and walkers build their own local communities
- **Privacy-respecting** — approximate location, coarse counts, no address collection
- **Fair** — appeals available, false positives correctable, trust recoverable

If we ever change any of these, we'll tell you months in advance. We promise.

— The WalkTogether Team
