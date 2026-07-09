# WalkTogether — Host Program v1.3 Report

**Phase:** 18
**Status:** Host program v1.3 features implemented

---

## 1. Overview

Phase 18 enhances the Community Host Program with:
- Localized host onboarding (all 9 languages)
- Host profile badges (Community Host + Trusted Host)
- Host safety checklist (6 items)
- Host quality score explanation
- Host review statuses (5 statuses)
- Host removal appeal copy

---

## 2. Host Profile Badges

### 2.1 Community Host badge

**Key:** `host_program.badge_community_host`

Displayed on a host's profile when `isCommunityHost === true`. Shows "Community Host" (or translated equivalent).

### 2.2 Trusted Host badge

**Key:** `host_program.badge_trusted_host`

Displayed when the host meets the trusted criteria:
- 5+ walks hosted
- 0 reports against them
- Verified account
- Not suspended

Shows "Trusted Host" (or translated equivalent) with a gold star icon.

### 2.3 Where badges appear

- WalkerCard (nearby walker list)
- WalkerDetailSheet (walker detail modal)
- GroupWalkDetail (host section)
- ClubDetail (creator section)
- Profile (self view)

*Note: Badge display in these components is a v1.4 UI task. The translation keys and data are ready in Phase 18.*

---

## 3. Host Safety Checklist

**Keys:** `host_program.safety_checklist_title`, `safety_checklist_intro`, and 6 `checklist_*` keys

### 3.1 Checklist items

1. **Meeting point is a public place** (`checklist_public_place`)
2. **Start time and duration are clear** (`checklist_clear_time`)
3. **Pace is described in the walk title or description** (`checklist_pace_described`)
4. **Women-only / verified-only filter set if needed** (`checklist_women_only`)
5. **I will not ask participants for their home address** (`checklist_no_private_address`)
6. **I will keep group chat respectful** (`checklist_respectful_chat`)

### 3.2 When it shows

The checklist is intended to be shown:
- Before each walk a host creates (v1.4 UI)
- In the host dashboard (v1.4 UI)
- As a refresher in host onboarding (v1.4 UI)

### 3.3 Intro copy

> **Host safety checklist**
> Review this checklist before every walk you host.

---

## 4. Host Quality Score

### 4.1 Score label

**Key:** `host_program.quality_score_label` → "Host quality score"

### 4.2 Score explanation

**Key:** `host_program.quality_score_explanation`

> Based on walks hosted, participant satisfaction, reports, and verification status.

### 4.3 Score formula (from Phase 17)

| Signal | Score change |
|--------|--------------|
| Base | +70 |
| Verified | +10 |
| Per walk hosted | +5 (max +20) |
| Per repeat participant | +5 (max +10) |
| Per report against | -10 (max -30) |
| Suspended/banned | -20 |

**Capped at 0-100.**

### 4.4 Where it's shown

- Admin hosts API (`/api/admin/hosts`) returns `safetyScore` per host
- Admin community dashboard shows host availability summary
- v1.4: Host profile will show the score to other users

---

## 5. Host Review Statuses

**Keys:** `host_program.review_status_*`

### 5.1 Status definitions

| Status | Key | Criteria |
|--------|-----|----------|
| New host | `review_status_new` | Onboarded in last 30 days, hasn't hosted any walks |
| Active host | `review_status_active` | Has hosted ≥1 walk, no recent reports |
| Trusted host | `review_status_trusted` | 5+ walks, 0 reports, verified, not suspended |
| Needs review | `review_status_needs_review` | 2+ reports against them in 30 days |
| Suspended | `review_status_suspended` | Account is suspended or banned |

### 5.2 Status priority

1. `suspended_host` (highest)
2. `needs_review`
3. `trusted_host`
4. `new_host`
5. `active_host` (default)

### 5.3 Where statuses are used

- Admin hosts API returns `hostStatus` per host
- Admin community dashboard shows host availability summary
- v1.4: Host profile will show status badge

---

## 6. Host Removal Appeal

### 6.1 Appeal title

**Key:** `host_program.appeal_title` → "Appeal a host decision"

### 6.2 Appeal body

**Key:** `host_program.appeal_body`

> If you believe a host decision was made in error, you can submit an appeal. Our team will review it within 7 days.

### 6.3 Appeal button

**Key:** `host_program.appeal_button` → "Submit appeal"

### 6.4 Appeal submitted confirmation

**Key:** `host_program.appeal_submitted`

> Appeal submitted. We'll review it within 7 days.

### 6.5 When it shows

The appeal copy is intended for:
- Hosts who have been warned, suspended, or had their host status revoked
- v1.4: A dedicated appeal form in Settings → Community

---

## 7. Localized Host Onboarding

The 8-step host onboarding flow is fully translated across all 9 languages. Each step has a `title` and `body` key:

- `host_onboarding.step_1_title` + `step_1_body` — Choose public places
- `host_onboarding.step_2_title` + `step_2_body` — Set a clear walk time
- `host_onboarding.step_3_title` + `step_3_body` — Describe your pace
- `host_onboarding.step_4_title` + `step_4_body` — Welcome new walkers
- `host_onboarding.step_5_title` + `step_5_body` — Use women-only / verified-only
- `host_onboarding.step_6_title` + `step_6_body` — Remove or report unsafe participants
- `host_onboarding.step_7_title` + `step_7_body` — Never ask for private addresses
- `host_onboarding.step_8_title` + `step_8_body` — Keep group chat respectful

*Note: The HostOnboarding screen currently uses hardcoded English strings. Applying the translations is a v1.4 UI task. The translation keys and data are ready in Phase 18.*

---

## 8. Host Events Tracking

Phase 16/17 tracks these host lifecycle events:

| Event | When |
|-------|------|
| `host_onboarding_started` | User opens Host Onboarding screen |
| `host_onboarding_step_viewed` | User advances to step N |
| `host_onboarding_completed` | User completes onboarding |
| `host_onboarded` (server) | `POST /api/host/onboard` succeeds |
| `first_walk_hosted` (server) | Host creates their first group walk |
| `first_club_created` (server) | Host creates their first club |

---

## 9. Acceptance Criteria

- [x] 18 new `host_program` translation keys added to all 9 locale files
- [x] Host badges (Community Host, Trusted Host) have translated labels
- [x] Host safety checklist has 6 translated items
- [x] Host quality score has translated label + explanation
- [x] 5 host review statuses have translated labels
- [x] Host appeal copy is translated (title, body, button, confirmation)
- [x] Host onboarding 8-step flow is translated
- [x] All safety strings marked `[SAFETY]` for native review
- [ ] Badge display in UI components (v1.4)
- [ ] Checklist display before walk creation (v1.4)
- [ ] Appeal form in Settings (v1.4)
- [ ] Apply translations to HostOnboarding screen (v1.4)
