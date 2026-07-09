# Beta Safety Monitoring SOP

**Phase:** 28
**Status:** Active throughout beta
**Last updated:** 2026-07-06
**Owner:** Safety Lead + Admin Team

## Overview

This Standard Operating Procedure (SOP) defines how admins monitor safety during the closed Android beta. **Safety monitoring is the #1 priority during beta.** Any real safety concern must be reviewed before expanding beta.

## Daily monitoring schedule

**Frequency:** Every day during the beta period (including weekends)
**Time:** Morning (before 10 AM local time) + evening (after 6 PM)
**Duration:** 15–30 minutes per check

## Daily admin checklist

### Morning check (before 10 AM)

1. **SOS events**
   - [ ] Open admin → Safety Events
   - [ ] Check for any new SOS events in the last 24 hours
   - [ ] For each SOS: verify it was a test (not a real emergency)
   - [ ] If real emergency: contact the user + document the incident

2. **Reports filed**
   - [ ] Open admin → Reports
   - [ ] Check for new reports in the last 24 hours
   - [ ] Triage each report: is it a safety concern or a minor issue?
   - [ ] For safety concerns: review chat logs + take action (warn/suspend/ban)

3. **Blocks**
   - [ ] Open admin → check new blocks
   - [ ] Look for patterns (e.g. multiple users blocking the same person)

4. **Flagged messages**
   - [ ] Open admin → Messages → flagged
   - [ ] Review auto-flagged messages
   - [ ] Apply correct outcome (true_positive / false_positive)
   - [ ] For true positives: remove message + take action on sender

5. **Appeal submissions**
   - [ ] Open admin → Appeals
   - [ ] Check for new appeals
   - [ ] Review each appeal within SLA (24h critical, 48h suspension, 72h ban)

6. **Suspended/banned users**
   - [ ] Check if any new suspensions/bans were triggered
   - [ ] Verify each was justified (not a false positive)

7. **Safety review tasks**
   - [ ] Open admin → Safety Queue
   - [ ] Check for new safety tasks
   - [ ] Assign + resolve within SLA

8. **Low trust users**
   - [ ] Check users with trust score < 30
   - [ ] Review their recent activity for safety concerns

9. **Privacy requests**
   - [ ] Open admin → Privacy Requests
   - [ ] Check for new privacy requests
   - [ ] Process within SLA (3–30 days depending on type)

10. **Deletion requests**
    - [ ] Check for new account deletion requests
    - [ ] Verify 14-day grace period is correctly tracked
    - [ ] Process finalizations for grace-period-expired requests

11. **Feedback (safety concerns)**
    - [ ] Open admin → Feedback
    - [ ] Filter by category "safety_concern"
    - [ ] Review each safety concern immediately
    - [ ] Respond to the user within 24 hours

### Evening check (after 6 PM)

1. Repeat the morning checklist for the afternoon's activity
2. Check for any SOS events that occurred during the day
3. Verify all P0/P1 bugs have been addressed

## Safety incident response

### If a real SOS is triggered (not a test)

1. **Immediate (within 5 minutes):**
   - Review the SOS event in admin → Safety Events
   - Check the user's walk session details
   - Attempt to contact the user via phone (if available)
   - If the user is in danger: advise them to call local emergency number

2. **Within 1 hour:**
   - Document the incident in an IncidentReport (admin → Incidents)
   - Notify the Safety Lead + Product Lead
   - Review chat logs between the user and their walk partner
   - If the walk partner is a threat: suspend them immediately

3. **Within 24 hours:**
   - Follow up with the user to confirm they're safe
   - Complete incident postmortem
   - Implement prevention measures if needed

### If a report indicates harassment or unsafe behavior

1. **Immediate (within 1 hour):**
   - Review the reported user's chat logs + recent activity
   - If clear evidence of harassment: suspend the user immediately
   - If unclear: gather more info (review more chat logs, check other reports)

2. **Within 24 hours:**
   - Apply final action: warn / suspend / ban (with audit log + reason)
   - If ban: freeze trust score (trustLocked = true)
   - Notify the reporter: "Thank you for your report. We have reviewed it and taken action."
   - Do NOT tell the reporter what specific action was taken

3. **If the reported user appeals:**
   - Process the appeal through the normal appeal workflow
   - Do NOT auto-reinstate — review the original evidence

### If a user is targeted by multiple reports

1. Check if 3+ users have reported the same person within 7 days
2. If yes: this triggers an automated safety signal
3. Review the user's activity immediately
4. If pattern confirmed: suspend or ban (with admin review — no auto-ban)
5. Document in SafetyTask

### If a flagged message is a true positive

1. Remove the message (set moderationStatus = "removed")
2. Review the sender's other messages for patterns
3. If this is the sender's first offense: warn (reduce trust score by 5)
4. If repeat offense: suspend (reduce trust score by 20, suspend for 7 days)
5. If severe (threats, harassment): ban (trust score frozen)

### If a user submits a safety concern via feedback

1. Review immediately (within 1 hour)
2. Categorize: is this a bug, a user concern, or a systemic safety issue?
3. If bug: fix as P1 (high priority)
4. If user concern: investigate + take action
5. If systemic: escalate to Safety Lead + Product Lead
6. Respond to the user within 24 hours

## Weekly safety review

Every Friday, the Safety Lead conducts a weekly review:

1. **SOS events this week:** How many? All tests? Any real emergencies?
2. **Reports this week:** How many? What types? Actions taken?
3. **Blocks this week:** How many? Any patterns?
4. **Flagged messages:** False positive rate? Any language issues?
5. **Appeals:** How many? Approved/rejected ratio?
6. **Safety tasks:** How many open? Overdue?
7. **Trust score distribution:** Any concerning drops?
8. **Privacy requests:** How many? Processing on time?
9. **Deletion requests:** How many? Any cancellations?

Document the review in the worklog.

## Escalation matrix

| Severity | Example | Response time | Escalate to |
|---|---|---|---|
| Critical | Real SOS, data leak, child safety | Immediate | Safety Lead + Product Lead + Legal |
| High | Harassment report, threat, stalker pattern | 1 hour | Safety Lead |
| Medium | Inappropriate message, minor dispute | 24 hours | Admin on duty |
| Low | Profile photo violation, minor spam | 72 hours | Admin queue |

## Beta expansion gate

**The beta CANNOT expand beyond the initial tester group until:**

1. All critical safety incidents from the beta are resolved
2. No unresolved safety P1 bugs
3. The Safety Lead signs off on safety readiness
4. The Product Lead signs off on product readiness
5. No pattern of safety concerns has been identified

If any safety concern is unresolved, the beta stays at its current size until resolved.

## Free product promise

Safety monitoring does NOT involve any paid features. All safety features (SOS, report, block, safety share, appeal, moderation) are free for everyone. The admin safety queue is a core part of the product, not a premium feature.

## Acceptance criteria

- [ ] Daily safety checklist completed every day
- [ ] All SOS events reviewed
- [ ] All reports reviewed within SLA
- [ ] All safety concerns from feedback reviewed within 1 hour
- [ ] Weekly safety review documented
- [ ] No unresolved safety P1 bugs before beta expansion
