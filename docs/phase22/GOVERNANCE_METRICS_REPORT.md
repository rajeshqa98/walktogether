# WalkTogether — Governance Metrics Report

**Phase:** 22
**Status:** Implemented

---

## 1. Overview

Governance metrics track appeal outcomes, false positive corrections, and enforcement.

## 2. API

`GET /api/admin/governance-metrics`

## 3. Metrics

- Appeals: submitted, approved, rejected, open, avg resolution time, common reasons
- False positives: corrected count, trust restored count
- Enforcement: suspensions upheld, bans upheld
- Outcomes: distribution by type
- Language issues: count of language_moderation_issue outcomes

## 4. Key Metrics to Monitor

- Appeal approval rate (target: 20-40%)
- Average appeal resolution time (target: < 48h)
- False positive correction rate
- Most common appeal reasons
- Most common moderation mistakes
