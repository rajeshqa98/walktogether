# WalkTogether — Safety Automation Tuning Report

**Phase:** 23
**Status:** Reviewed — thresholds defined, tuning spec ready for v1.6

---

## 1. Current Thresholds

| Signal | Threshold | Severity |
|--------|-----------|----------|
| repeated_reports | 2+ in 7d | high |
| repeated_blocks | 3+ in 7d | medium |
| unsafe_words | 3+ in 24h | medium |
| home_address_request | Regex match | high |
| private_meeting_request | Regex match | high |
| sos_during_walk | Any SOS | high |
| host_repeated_reports | 2+ in 30d | high |
| rapid_join_leave | 5+ in 24h | low |
| spam_invite | 20+ with <5% conversion | medium |

## 2. Rules

- Automation creates review tasks, not punishment
- No auto-ban except severe cases already approved by admin
- Noisy signals (rapid_join_leave) are low priority
- Reliable signals (repeated_reports, SOS) are high priority

## 3. v1.6 Tuning Plan

- Admin UI for threshold tuning
- Language-specific sensitivity
- Enable/disable individual signals
- View false positive rate per signal

## 4. Acceptance Criteria

- [x] Automation thresholds are documented
- [x] Automation creates review tasks, not punishment
- [x] Noisy signals are reduced (low priority)
- [x] Reliable signals are prioritized
