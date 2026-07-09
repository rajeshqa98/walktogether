# WalkTogether — Safety Automation Tuning Spec

**Phase:** 22
**Status:** Spec defined; thresholds in safety-automation.ts

---

## 1. Overview

Admin controls for automation sensitivity. Phase 22 defines the spec; full UI tuning is v1.6.

## 2. Current Thresholds (in src/lib/safety-automation.ts)

| Signal | Threshold | Tunable? |
|--------|-----------|---------|
| repeated_reports | 2+ in 7d | Hardcoded |
| repeated_blocks | 3+ in 7d | Hardcoded |
| unsafe_words | 3+ in 24h | Hardcoded |
| home_address_request | Regex match | Hardcoded |
| private_meeting_request | Regex match | Hardcoded |
| sos_during_walk | Any SOS | Hardcoded |
| host_repeated_reports | 2+ in 30d | Hardcoded |
| rapid_join_leave | 5+ in 24h | Hardcoded |
| spam_invite | 20+ with <5% conversion | Hardcoded |

## 3. Planned v1.6 Controls

- Admin UI for threshold tuning
- Language-specific sensitivity
- Enable/disable individual signals
- Mark signal reliable/unreliable
- View false positive rate per signal
