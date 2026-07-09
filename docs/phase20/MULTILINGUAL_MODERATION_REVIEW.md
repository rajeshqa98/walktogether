# WalkTogether — Multilingual Moderation Review

**Phase:** 20
**Status:** 10 languages covered; false positive tracking active

---

## 1. Overview

Phase 20 reviews the multilingual moderation system to ensure it covers all 10 languages effectively, avoids over-blocking normal conversation, and tracks false positives.

---

## 2. Language Coverage

| Language | Code | Banned terms | Safety patterns | Status |
|----------|------|--------------|----------------|--------|
| English | en | 15 | Yes | ✅ Complete |
| Hindi | hi | 33 | Yes | ✅ Complete |
| Hinglish | hinglish | 15 | Yes | ✅ Complete |
| Telugu | te | 13 | Yes | ✅ Complete |
| Tamil | ta | 13 | Yes | ✅ Complete |
| Kannada | kn | 14 | Yes | ✅ Complete (Phase 17) |
| Bengali | bn | 17 | Yes | ✅ Complete (Phase 17) |
| Spanish | es | 7 | Yes | ✅ Complete |
| Arabic | ar | 8 | Yes | ✅ Complete |
| French | fr | 6 | Yes | ✅ Complete |

**Total: 141 banned terms across 10 languages.**

---

## 3. Severity Model

| Severity | Behavior | Example terms |
|----------|----------|--------------|
| 3 (block) | Message rejected, persisted as "removed" | Rape, child abuse, severe slurs |
| 2 (flag) | Message delivered, flagged for admin review | Common abusive words |
| 1 (log) | Message delivered, logged only | (Not currently used) |

---

## 4. Safety Pattern Detection (Phase 17)

Regex-based detection for:
- `request_for_home_address` — "What's your home address?", Hindi transliterations
- `request_for_private_meeting` — "Come to my home", "Let's meet at my place"

These are FLAGGED (severity 2 equivalent), never blocked. Phase 19 creates safety signals for these patterns.

---

## 5. False Positive Tracking

### 5.1 How false positives are tracked

1. Message is flagged by moderation
2. If flagged for home_address_request or private_meeting_request, safety signal is created
3. Admin reviews the safety task
4. Admin classifies as `false_positive` or `language_moderation_issue`
5. False positive rate is tracked in effectiveness API

### 5.2 Known false positive risks

| Pattern | Risk | Mitigation |
|---------|------|-----------|
| "What's your address?" | Host asking for meeting point | Flag for review, don't block |
| "Come to my place" | Could be casual | Flag for review, don't block |
| Casual swearing | Normal conversation | Severity 2 (flag), not severity 3 (block) |
| Transliteration variations | May miss some forms | Continuously expand word lists |

---

## 6. Moderation Principles

1. **Prefer flagging over blocking** — only block unambiguous high-severity terms
2. **Normal conversation should not break chat** — casual swearing is flagged, not blocked
3. **All flagged messages are persisted** — admins can review and adjust word lists
4. **False positives are tracked** — `language_moderation_issue` outcome
5. **No auto-ban** — all signals create tasks for admin review

---

## 7. Acceptance Criteria

- [x] 10 languages covered (English, Hindi, Hinglish, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French)
- [x] Severity model works (block/flag/log)
- [x] Safety pattern detection for home address / private meeting requests
- [x] False positives tracked via `language_moderation_issue` outcome
- [x] False positive rate available in effectiveness API
- [x] No over-blocking of normal conversation
- [x] All flagged messages persisted for admin review
