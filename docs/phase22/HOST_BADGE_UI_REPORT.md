# WalkTogether — Host Badge UI Report

**Phase:** 22
**Status:** Implemented

---

## 1. Overview

Host badges now displayed in all user-facing screens.

## 2. Where Badges Appear

- Group walk card (Groups list) — Phase 22 NEW
- Group walk detail — Phase 18B
- Club detail — Phase 18B
- Host onboarding success — Phase 18B
- Admin host quality page — via /api/admin/hosts

## 3. Badge Types

- Community Host (Award icon, primary color)
- Trusted Host (Star icon, emerald color)
- Needs Review (AlertTriangle icon, amber)
- Suspended (Ban icon, red)

## 4. Component

`src/components/HostBadge.tsx` — reusable, language-aware

## 5. User Explanation

"Hosts help organize safe public walks. Host status is based on completed walks, reports, feedback, and safety review."
