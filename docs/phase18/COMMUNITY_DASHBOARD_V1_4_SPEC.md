# WalkTogether — Community Dashboard v1.4 Spec

**Phase:** 18
**Status:** v1.4 metrics implemented in API; UI live at `/admin/community`
**API:** `GET /api/admin/community`

---

## 1. Overview

The Admin Community Dashboard v1.4 extends Phase 17's v1.3 dashboard with three new language-focused metrics:

1. **Invite conversion by language** — which languages drive the most invite conversions
2. **Safety reports by language** — which language users file the most reports (moderation gap detection)
3. **Translation adoption** — per-language user counts + completeness percentages

---

## 2. New v1.4 Metrics

### 2.1 Invite conversion by language

**API field:** `inviteConversionByLanguage`

**Shape:**
```json
{
  "en": { "created": 78, "visits": 234, "joins": 45 },
  "hi": { "created": 34, "visits": 102, "joins": 28 },
  "te": { "created": 12, "visits": 45, "joins": 8 }
}
```

**How it's computed:**
- Joins `InviteLink` with `User` (creator's language)
- Aggregates `visitCount` and `joinCount` per language
- Limited to 1000 most recent invite links

**Why it matters:**
- Shows which language users are most active in sharing invites
- Helps prioritize translation review for high-conversion languages
- Identifies languages with low conversion (may need better localized copy)

### 2.2 Safety reports by language

**API field:** `safetyReportsByLanguage`

**Shape:**
```json
{
  "en": 15,
  "hi": 8,
  "te": 3
}
```

**How it's computed:**
- Joins `Report` with `User` (reported user's language)
- Counts reports per language
- Limited to 1000 most recent reports

**Why it matters:**
- If one language has a disproportionately high report rate, it may indicate:
  - Moderation gaps (abuse not being caught by the word list)
  - Cultural misunderstandings
  - Need for language-specific safety education
- Helps prioritize moderation expansion for specific languages

### 2.3 Translation adoption

**API field:** `translationAdoption`

**Shape:**
```json
[
  {
    "code": "en",
    "name": "English",
    "nativeName": "English",
    "userCount": 234,
    "completenessPercent": 100,
    "reviewed": true,
    "rtl": false
  },
  {
    "code": "hi",
    "name": "Hindi",
    "nativeName": "हिन्दी",
    "userCount": 56,
    "completenessPercent": 100,
    "reviewed": false,
    "rtl": false
  }
]
```

**How it's computed:**
- Uses `getAllLocalesMeta()` from the i18n library
- Counts users per language from the `User` table
- Computes completeness via `countTranslatedKeys() / countTranslationKeys()`

**Why it matters:**
- Shows which languages users are actually selecting
- Helps prioritize native speaker review for high-adoption languages
- Identifies languages with low adoption (may need better discovery in the language picker)

---

## 3. Existing v1.3 Metrics (Retained)

The dashboard continues to show all Phase 17 v1.3 metrics:

- Area list with recommendation badges + community health scores
- Host availability (total, new 30d, active 30d, needing review)
- Invite conversion (total created, visits, joins, conversion rate, by target type)
- Language distribution (bar chart)
- Village/town adoption
- 7-day activity trends
- Low-density alerts

---

## 4. Dashboard UI Sections

```
┌─────────────────────────────────────────────┐
│ Community Growth                            │
├─────────────────────────────────────────────┤
│ [First walker] [Needs host] [Growing]       │
│ [Active] [Safety review]                    │
├─────────────────────────────────────────────┤
│ [Total hosts] [New 30d] [Active 30d]        │
│ [Needing review]                            │
├─────────────────────────────────────────────┤
│ Invite conversion                           │
│ Created | Visits | Joins | Conv. rate       │
│ [app: N] [area: N] [group_walk: N] [club: N]│
├─────────────────────────────────────────────┤
│ Language distribution        │ Village/town │
│ [bar chart per language]     │ Village: N   │
│                              │ Town: N      │
│                              │ Total: N     │
├─────────────────────────────────────────────┤
│ 7-day trends                                │
│ [group_walk_created: N] [club_created: N]   │
│ [invite_link_created: N] ...                │
├─────────────────────────────────────────────┤
│ Low-density alerts (N)                      │
│ [area list with days stuck]                 │
├─────────────────────────────────────────────┤
│ Areas table                                 │
│ Area | Walkers | Walks | Clubs | Health |   │
│ Recommendation | Safety | First walker      │
└─────────────────────────────────────────────┘
```

### v1.4 UI additions (planned)

- **Invite conversion by language** panel (bar chart)
- **Safety reports by language** panel (bar chart with alert thresholds)
- **Translation adoption** panel (table with completeness + user count + reviewed status)

*Note: The v1.4 metrics are available in the API response. The UI panels are a v1.4 task.*

---

## 5. API Response Shape (v1.4)

```json
{
  // ... existing v1.3 fields ...

  "inviteConversionByLanguage": {
    "en": { "created": 78, "visits": 234, "joins": 45 },
    "hi": { "created": 34, "visits": 102, "joins": 28 }
  },

  "safetyReportsByLanguage": {
    "en": 15,
    "hi": 8
  },

  "translationAdoption": [
    {
      "code": "en",
      "name": "English",
      "nativeName": "English",
      "userCount": 234,
      "completenessPercent": 100,
      "reviewed": true,
      "rtl": false
    }
  ]
}
```

---

## 6. Access Control

- Dashboard page at `/admin/community` is admin-only
- API at `/api/admin/community` returns 401 without admin auth, 403 for non-admin users
- All data is read-only

---

## 7. Privacy

- No exact user locations exposed
- No user IDs or names in aggregate metrics
- Language distribution shows counts only
- Invite conversion by language shows aggregate counts, not individual user activity
- Safety reports by language shows counts only (no report content)

---

## 8. Acceptance Criteria

- [x] `inviteConversionByLanguage` computed and returned by API
- [x] `safetyReportsByLanguage` computed and returned by API
- [x] `translationAdoption` computed and returned by API
- [x] All v1.3 metrics retained
- [x] API is admin-only (401/403 without admin auth)
- [x] No exact user locations or identities exposed
- [ ] UI panels for v1.4 metrics (v1.4 task)
