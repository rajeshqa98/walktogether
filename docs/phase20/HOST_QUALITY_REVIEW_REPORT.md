# WalkTogether — Host Quality Review Report

**Phase:** 20
**Status:** Host quality automation reviewed and confirmed

---

## 1. Overview

Phase 19 introduced host quality automation with safety signals for hosts receiving repeated reports. Phase 20 reviews the system and confirms it is working correctly.

---

## 2. Host Quality Tracking

### 2.1 Host statuses

| Status | Criteria | Admin action |
|--------|----------|-------------|
| new_host | Onboarded in last 30 days, no walks | None — welcome |
| active_host | 1+ walks hosted, no reports | None — healthy |
| trusted_host | 5+ walks, 0 reports, verified | Celebrate |
| needs_review | 2+ reports in 30 days | Manual review |
| suspended_host | Account suspended/banned | Already actioned |

### 2.2 Host quality metrics (from Phase 17 `/api/admin/hosts`)

- Total walks created
- Walks created in last 30 days
- Cancelled walks
- Total participants
- Repeat participants (loyalty signal)
- Reports against (total + 30d)
- Safety score (0-100)

### 2.3 Phase 20 additions

- `hostsNeedingReview` count in effectiveness API
- `totalHosts` count in effectiveness API
- Host quality snapshot model (HostQualitySnapshot) ready for periodic rollups
- Admin can suspend host ability via safety task action

---

## 3. Host Quality Score Formula (from Phase 17)

| Signal | Score change |
|--------|-------------|
| Base | +70 |
| Verified | +10 |
| Per walk hosted | +5 (max +20) |
| Per repeat participant | +5 (max +10) |
| Per report against | -10 (max -30) |
| Suspended/banned | -20 |

**Capped at 0-100.**

---

## 4. Host Safety Checklist (from Phase 18)

6-item checklist for hosts to review before each walk:
1. Meeting point is a public place
2. Start time and duration are clear
3. Pace is described
4. Women-only / verified-only filter set if needed
5. I will not ask for home addresses
6. I will keep group chat respectful

### 4.1 Checklist completion tracking

`HostQualitySnapshot.checklistCompleted` field tracks whether the host has completed the checklist. This is currently set to `false` for all hosts — the checklist UI is a v1.5 task.

---

## 5. Host Appeal Process

From Phase 18 translation keys:

- `host_program.appeal_title` → "Appeal a host decision"
- `host_program.appeal_body` → "If you believe a host decision was made in error, you can submit an appeal. Our team will review it within 7 days."
- `host_program.appeal_button` → "Submit appeal"
- `host_program.appeal_submitted` → "Appeal submitted. We'll review it within 7 days."

The appeal form UI is a v1.5 task. The translation keys and data are ready.

---

## 6. Acceptance Criteria

- [x] Host quality automation is reviewed
- [x] Host statuses are correctly computed (5 statuses)
- [x] Host receiving 2+ reports in 30d creates safety signal
- [x] Admin can suspend host ability via safety task action
- [x] Host quality metrics available in effectiveness API
- [x] Host safety checklist model exists (HostQualitySnapshot)
- [x] Host appeal copy is translated in all 9 languages
