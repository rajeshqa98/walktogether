# WalkTogether — Global Support Operations SOP

## Support Channels
- **Email:** support@walktogether.app (general), safety@walktogether.app (safety), partnerships@walktogether.app
- **In-app:** Feedback form (Settings → Give feedback)
- **Admin:** Feedback inbox at /admin/feedback

## Daily Support Review
1. Check feedback inbox for new items
2. Filter by category: safety_concern (priority), bug, feature_request, general
3. Respond to safety concerns within 4 hours
4. Respond to bugs within 24 hours
5. Log all responses in admin notes

## Support Response Templates

### Welcome message
"Welcome to WalkTogether! We're excited to have you in our walking community. If you have any questions, just reply to this email or use the feedback form in the app. Stay safe, walk together! 🚶"

### OTP/login help
"Sorry you're having trouble with OTP. Please try: 1) Check your phone number includes country code (+91, +1, etc.). 2) Wait 30 seconds before requesting a new OTP. 3) If you still don't receive it, your carrier may be blocking SMS — try again in 10 minutes. If it persists, let us know your phone number and we'll investigate."

### Location permission help
"If you can't grant location permission: 1) Go to your phone Settings → Apps → WalkTogether → Permissions → Location → Allow. 2) Or use 'Pick my area manually' — you can select your city without sharing GPS. Your exact location is never shared with other users."

### Country/city not active yet
"WalkTogether is launching city by city. Your city [CITY] is currently on our waitlist with [X] other walkers. We'll invite you as soon as we have enough walkers to ensure good matches. Want to speed it up? Share the waitlist link with friends in your city!"

### Waitlist accepted
"Great news! WalkTogether is now active in [CITY]. You can download the app and sign up with your phone number [PHONE]. Welcome to the walking community! 🚶"

### Report received
"Thank you for reporting. We take all reports seriously. Our safety team has received your report and will review it within 24 hours. If you feel unsafe, please contact your local emergency services directly — WalkTogether does not replace emergency services."

### Safety concern received
"Thank you for sharing your safety concern. This has been escalated to our safety team for immediate review. We will respond within 4 hours. If you are in immediate danger, please contact your local emergency number: [EMERGENCY NUMBER]."

### Account suspended
"Your WalkTogether account has been suspended for [REASON] for [DURATION]. During suspension, you cannot send walk requests or messages. If you believe this is an error, you can submit an appeal by replying to this email."

### Appeal received
"We've received your appeal and will review it within 48 hours. We'll get back to you with a decision. Thank you for your patience."

### Group walk cancelled
"The group walk '[WALK TITLE]' has been cancelled by the host. Reason: [REASON]. If you had joined, you don't need to do anything — no further action required."

### Host verification pending
"Your selfie verification is being reviewed. This usually takes 1-2 hours. Once verified, you'll get a verified badge and can host group walks. We'll notify you when it's complete."

---

# WalkTogether — Global Safety Operations SOP

## Daily Admin Safety Checklist

Review EVERY DAY during launch period:

1. **Reports** — Check /admin/reports for new reports. Action each one (warn/suspend/ban/dismiss).
2. **SOS events** — Check /admin/safety-events for any SOS triggers. Investigate each one.
3. **Flagged messages** — Check /admin/messages for auto-moderated content. Review + action.
4. **Blocked users** — Review new blocks. No action needed unless patterns emerge.
5. **Low trust users** — Check users with trust < 40. Monitor behavior.
6. **Group walk reports** — Check if any group walks were reported.
7. **Feedback (safety)** — Check /admin/feedback for safety_concern category. Respond within 4 hours.
8. **New group walks** — Review newly created group walks for safety (public meeting points, reasonable settings).
9. **Public meeting points** — Verify all meeting points are public places (not private residences).
10. **Repeat-reported users** — Check if any user has 3+ reports. Consider suspension.
11. **Country-wise safety trends** — Check analytics heatmap for country/city with high report rates.
12. **City-wise safety trends** — If any city has safetyStatus = "yellow" or "red", investigate.

## Escalation Levels

### Level 1: Minor issue
- Example: User sent a slightly inappropriate message (not banned word)
- Action: Warning + trust score -2
- Response time: 24 hours

### Level 2: Repeated discomfort/report
- Example: User has 2+ reports from different users
- Action: Warning + trust score -5, or 7-day suspension
- Response time: 12 hours

### Level 3: Harassment/safety concern
- Example: Harassment, threats, persistent unwanted behavior
- Action: 30-day suspension or permanent ban
- Response time: 4 hours

### Level 4: SOS/urgent event
- Example: SOS triggered, user reports feeling physically unsafe
- Action: Immediate investigation, ban partner if warranted, contact users involved
- Response time: 1 hour

## Admin Actions Available

| Action | Scope | Effect |
|--------|-------|--------|
| Warn user | User | Status → warned, trust -2 |
| Suspend user | User | Status → suspended, cannot send requests/messages |
| Ban user | User | Status → banned, cannot log in, hidden from nearby, trust locked |
| Cancel group walk | Group walk | Status → cancelled, participants notified |
| Disable city group creation | City | groupCreationEnabled = false for that city |
| Disable country group creation | Country | groupCreationEnabled = false for that country |
| Contact user | User | Send email via support |
| Request more details | User | Email asking for more information |
| Document action | Audit log | Every action creates an audit log entry |

## Country-Specific Safety Monitoring

| Country | Emergency # | Special Considerations |
|---------|-------------|----------------------|
| India | 112 | DPDP Act compliance, women safety focus |
| US | 911 | State-specific privacy laws (CCPA for California) |
| UK | 999 | GDPR compliance |
| Singapore | 999 | PDPA compliance |
| UAE | 999 | Local content regulations |
| Australia | 000 | Privacy Act compliance |

## Safety Incident Response Flow

1. **Detection:** SOS trigger / user report / flagged message / admin notice
2. **Triage:** Determine escalation level (1-4)
3. **Investigate:** Review chat logs, session data, user history
4. **Action:** Apply appropriate action (warn/suspend/ban/cancel)
5. **Document:** Create audit log entry with reason
6. **Follow-up:** Contact affected users, offer support
7. **Review:** Add to daily safety summary, identify patterns

## Pause/Resume City Protocol

If a city needs to be paused (safety concern):
1. Set city status to "paused" via admin API
2. Cancel all active group walks in that city
3. Email affected users with explanation
4. Investigate root cause
5. When resolved: set status back to "active"
6. Document in audit log
