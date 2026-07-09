# WalkTogether — Moderation Wordlist Expansion Report

**Phase:** 22
**Status:** Implemented

---

## 1. Overview

Phase 22 expands moderation word lists for Kannada, Bengali, Spanish, Arabic, and French.

## 2. Expansion Summary

| Language | Phase 17 terms | Phase 22 terms | Added |
|----------|---------------|---------------|-------|
| Kannada | 14 | 17 | +3 |
| Bengali | 17 | 20 | +3 |
| Spanish | 7 | 13 | +6 |
| Arabic | 8 | 12 | +4 |
| French | 6 | 9 | +3 |

## 3. Safety Patterns

Existing safety pattern detection (Phase 17) covers:
- Home address requests (English + Hindi)
- Private meeting requests (English + Hindi)

## 4. Rules

- Flag questionable content for admin review
- Avoid over-blocking normal conversation
- Track false positives by language
- Allow admin to mark false positive
- False positive should not harm trust score
