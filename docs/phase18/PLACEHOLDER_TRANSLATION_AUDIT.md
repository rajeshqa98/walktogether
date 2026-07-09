# WalkTogether — Placeholder Translation Audit

**Phase:** 18D
**Status:** Safety-critical placeholders eliminated; non-safety documented

---

## 1. Audit Summary

| Category | Total Keys | Safety-Critical | Placeholders Remaining | Status |
|----------|-----------|----------------|----------------------|--------|
| `safety` | 11 | ✅ | 0 | Complete (Phase 18) |
| `safety_v1_3` | 10 | ✅ | 0 | Complete (Phase 18) |
| `sos` | 7 | ✅ | 0 | Complete (Phase 18) |
| `report_block` | 6 | ✅ | 0 | Complete (Phase 18) |
| `location` | 10 | ✅ | 0 | Complete (Phase 18) |
| `village_town` | 17 | ✅ | 0 | Complete (Phase 18) |
| `no_walkers` | 8 | ✅ | 0 | Complete (Phase 18) |
| `host_onboarding` | 21 | ✅ | 0 | Complete (Phase 18) |
| `login` | 15 | ✅ | 0 | Complete (Phase 18D) |
| `post_walk` | 23 | ✅ | 0 | Complete (Phase 18D) |
| `walk_session_screen` | 14 | ✅ | 0 | Complete (Phase 18D) |
| `common` | 17 | Partial | 0 | Complete (Phase 18) |
| `profile_setup` | 21 | ❌ | 21 | English placeholder (v1.4) |
| `walker_card` | 8 | ❌ | 8 | English placeholder (v1.4) |
| `walker_detail` | 15 | ❌ | 15 | English placeholder (v1.4) |
| `requests_screen` | 14 | Partial | 13 | chat_unlocks translated; rest v1.4 |
| `chat_screen` | 8 | Partial | 6 | moderation translated; rest v1.4 |
| `groups_screen` | 26 | ❌ | 26 | English placeholder (v1.4) |
| `group_walk_create` | 17 | ❌ | 17 | English placeholder (v1.4) |
| `group_chat` | 8 | Partial | 6 | moderation translated; rest v1.4 |
| `club_create` | 16 | ❌ | 16 | English placeholder (v1.4) |
| `notifications_screen` | 13 | ❌ | 13 | English placeholder (v1.4) |
| `profile_screen` | 18 | ❌ | 18 | English placeholder (v1.4) |
| `settings_sections` | 28 | ❌ | 28 | English placeholder (v1.4) |

**Totals:**
- Safety-critical: 147 keys, **0 placeholders** ✅
- Non-safety: 245 keys, **187 placeholders** (acceptable for v1.3 beta)

---

## 2. Translation Scripts Created

### `scripts/translate-safety-critical.py`
First pass: translated 54 keys for Hindi, 30 keys each for other 7 languages.

### `scripts/translate-safety-remaining.py`
Second pass: translated 24 additional keys for Telugu/Tamil/Kannada/Bengali/Arabic, 22 for Spanish/French.

### `scripts/propagate-translations.py`
Ensures all locale files have the same set of keys (from Phase 18C).

---

## 3. Per-Language Placeholder Count

| Language | Total Keys | Translated | Placeholders | % Complete |
|----------|-----------|-----------|-------------|------------|
| en | 518 | 518 | 0 | 100% |
| hi | 518 | 331 | 187 | 64% |
| te | 518 | 331 | 187 | 64% |
| ta | 518 | 331 | 187 | 64% |
| kn | 518 | 331 | 187 | 64% |
| bn | 518 | 331 | 187 | 64% |
| es | 518 | 331 | 187 | 64% |
| ar | 518 | 331 | 187 | 64% |
| fr | 518 | 331 | 187 | 64% |

**All 9 languages have 518 keys.** The 187 non-safety placeholders fall back to English automatically.

---

## 4. Acceptable Placeholder Policy

Placeholders are acceptable when:
1. ✅ The key is NOT safety-critical (login, SOS, report/block, moderation)
2. ✅ The English fallback renders correctly
3. ✅ The language is marked "Beta" in the language picker
4. ✅ The native review note is displayed: "Translations are beta and should be reviewed by native speakers before public promotion."

Placeholders are NOT acceptable when:
1. ❌ The key is safety-critical (SOS disclaimer, report reasons, moderation warnings)
2. ❌ The key affects user safety decisions
3. ❌ The key is in a legal/policy context

All safety-critical placeholders have been eliminated in Phase 18D. ✅
