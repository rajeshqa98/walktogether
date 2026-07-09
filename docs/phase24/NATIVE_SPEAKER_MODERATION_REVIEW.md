# WalkTogether — Native Speaker Moderation Review

**Phase:** 24
**Status:** Implemented

---

## 1. Overview

Review workflow for language-sensitive moderation decisions.

## 2. API

`GET /api/admin/native-speaker-review`

## 3. Features

- Lists safety tasks with `language_moderation_issue` outcome
- Groups by user language
- Shows admin language skills
- Coverage status per language (term count, flagged count, needs review)
- Tasks needing native review with context

## 4. Languages Covered

English, Hindi, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French

## 5. Review Outcomes (via safety task API)

- Mark true violation
- Mark false positive
- Request native speaker review (via outcome classification)

## 6. Acceptance Criteria

- [x] Native speaker review workflow exists
- [x] Language-specific issues are tracked
- [x] Admin language skills are visible
