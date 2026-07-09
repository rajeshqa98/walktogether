# Beta Metrics Review

**Phase:** 29
**Status:** Template — fill in after beta
**Last updated:** 2026-07-06
**Owner:** Product Lead + SRE Lead

## Overview

This report compiles all metrics collected during the closed Android beta. Metrics are compared against targets and feed into the go/no-go decision.

## Metrics summary

### Acquisition + onboarding

| Metric | Value | Target | Met? |
|---|---|---|---|
| Install count | [N] | ≥ 20 | [ ] |
| Signup completion rate | [N]% | ≥ 80% | [ ] |
| OTP success rate | [N]% | ≥ 95% | [ ] |
| Profile completion rate | [N]% | ≥ 80% | [ ] |
| Location setup success rate | [N]% | ≥ 80% | [ ] |

### Engagement

| Metric | Value | Target | Met? |
|---|---|---|---|
| Nearby searches | [N] | — | — |
| Walk requests sent | [N] | — | — |
| Walk request acceptance rate | [N]% | ≥ 30% | [ ] |
| Chat messages sent | [N] | — | — |
| Walks started | [N] | — | — |
| Walk completion rate | [N]% | ≥ 70% | [ ] |
| Group walk joins | [N] | — | — |
| Club joins | [N] | — | — |
| Feedback submissions | [N] | — | — |

### Safety

| Metric | Value | Target | Met? |
|---|---|---|---|
| SOS events (tests) | [N] | — | — |
| Real emergencies | [N] | 0 | [ ] |
| Reports filed | [N] | — | — |
| Blocks | [N] | — | — |
| Flagged messages | [N] | — | — |
| False positive rate | [N]% | < 10% | [ ] |
| Appeals submitted | [N] | — | — |
| Safety incidents | [N] | 0 critical | [ ] |

### Privacy + account

| Metric | Value | Target | Met? |
|---|---|---|---|
| Privacy requests | [N] | — | — |
| Data exports completed | [N] | — | — |
| Account deletion requests | [N] | — | — |
| Location leak reports | [N] | 0 | [ ] |

### Stability

| Metric | Value | Target | Met? |
|---|---|---|---|
| Crash-free sessions | [N]% | ≥ 95% | [ ] |
| Crash-free users | [N]% | ≥ 95% | [ ] |
| ANR rate | [N]% | < 0.5% | [ ] |
| Uninstall rate (7-day) | [N]% | < 20% | [ ] |

### Push notifications

| Metric | Value | Target | Met? |
|---|---|---|---|
| FCM tokens registered | [N] | — | — |
| Push delivery success | [N]% | ≥ 95% | [ ] |
| Notification taps | [N] | — | — |

### Performance

| Metric | Value | Target | Met? |
|---|---|---|---|
| App startup time (cold) | [N]s | < 3s | [ ] |
| Home screen load time | [N]s | < 2s | [ ] |
| Nearby search latency (p95) | [N]ms | < 1500ms | [ ] |
| Chat send latency | [N]ms | < 500ms | [ ] |
| Socket reconnect time | [N]s | < 5s | [ ] |
| Memory usage (active walk) | [N]MB | < 150MB | [ ] |

## Funnel analysis

### Onboarding funnel

```
Installs: [N] (100%)
  → Signups: [N] ([N]%)
    → Profile setup: [N] ([N]%)
      → Location setup: [N] ([N]%)
        → First nearby search: [N] ([N]%)
          → First walk request: [N] ([N]%)
            → First accepted: [N] ([N]%)
              → First chat: [N] ([N]%)
                → First walk started: [N] ([N]%)
                  → First walk completed: [N] ([N]%)
                    → First rating: [N] ([N]%)
```

### Drop-off points

| Drop-off | Count | Rate | Likely cause |
|---|---|---|---|
| Install → Signup | [N] | [N]% | [cause] |
| Signup → Profile | [N] | [N]% | [cause] |
| Profile → Location | [N] | [N]% | [cause] |
| Location → Nearby search | [N] | [N]% | [cause] |
| Nearby → Walk request | [N] | [N]% | [cause] |
| Walk request → Accepted | [N] | [N]% | [cause] |
| Accepted → Chat | [N] | [N]% | [cause] |
| Chat → Walk started | [N] | [N]% | [cause] |
| Walk started → Completed | [N] | [N]% | [cause] |
| Walk completed → Rating | [N] | [N]% | [cause] |

## Daily metrics trend

### Active testers per day

| Day | Active testers | New signups | Walks started | Walks completed |
|---|---|---|---|---|
| Day 1 | [N] | [N] | [N] | [N] |
| Day 2 | [N] | [N] | [N] | [N] |
| ... | ... | ... | ... | ... |
| Day 14 | [N] | [N] | [N] | [N] |

### Crash-free sessions per day

| Day | Crash-free % | ANR % | OTP success % |
|---|---|---|---|
| Day 1 | [N]% | [N]% | [N]% |
| Day 2 | [N]% | [N]% | [N]% |
| ... | ... | ... | ... |
| Day 14 | [N]% | [N]% | [N]% |

## Tester group comparison

| Group | Install | Signup | Walk flow | Feedback | Bugs |
|---|---|---|---|---|---|
| City users | [N] | [N]% | [N]% | [N] | [N] |
| Small-town | [N] | [N]% | [N]% | [N] | [N] |
| Village | [N] | [N]% | [N]% | [N] | [N] |
| Women safety | [N] | [N]% | [N]% | [N] | [N] |
| Host | [N] | [N]% | [N]% | [N] | [N] |
| Group walk | [N] | [N]% | [N]% | [N] | [N] |
| Multilingual | [N] | [N]% | [N]% | [N] | [N] |
| Low-density | [N] | [N]% | [N]% | [N] | [N] |

## Geographic metrics

| Location | Testers | Walks | Reports | Feedback |
|---|---|---|---|---|
| [city 1] | [N] | [N] | [N] | [N] |
| [city 2] | [N] | [N] | [N] | [N] |
| [town 1] | [N] | [N] | [N] | [N] |
| [village 1] | [N] | [N] | [N] | [N] |

## Key findings

### What worked well
1. [finding]
2. [finding]
3. [finding]

### What needs improvement
1. [finding]
2. [finding]
3. [finding]

### Surprising findings
1. [finding]
2. [finding]

## Go/no-go metrics check

| Criterion | Target | Actual | Pass? |
|---|---|---|---|
| Crash-free sessions ≥ 95% | ≥ 95% | [N]% | [ ] |
| OTP success rate ≥ 95% | ≥ 95% | [N]% | [ ] |
| Location setup success ≥ 80% | ≥ 80% | [N]% | [ ] |
| Walk completion rate ≥ 70% | ≥ 70% | [N]% | [ ] |
| Core walk flow completion ≥ 50% | ≥ 50% | [N]% | [ ] |
| Uninstall rate < 20% | < 20% | [N]% | [ ] |
| Real emergencies = 0 | 0 | [N] | [ ] |
| Location leaks = 0 | 0 | [N] | [ ] |

## Recommendations

Based on the metrics:

1. [recommendation 1]
2. [recommendation 2]
3. [recommendation 3]

## Acceptance criteria

- [ ] All 6 metric categories measured
- [ ] Metrics compared against targets
- [ ] Funnel analysis completed
- [ ] Drop-off points identified
- [ ] Daily trends documented
- [ ] Tester group comparison completed
- [ ] Go/no-go metrics check completed
