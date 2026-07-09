# WalkTogether — User Appeal Flow

**Phase:** 21
**Status:** Implemented

---

## 1. Overview

Users can appeal moderation actions through a dedicated appeal screen accessible from Settings → Appeals & Trust.

## 2. User Flow

1. User opens Settings → "Appeals & Trust" section
2. User taps "Submit an Appeal"
3. User selects action type (7 options)
4. User writes reason (min 10 chars) and explanation (min 20 chars)
5. User optionally adds supporting details
6. User submits appeal
7. Appeal appears in user's appeal list with status "Submitted"
8. User receives notification when appeal is reviewed

## 3. Appealable Actions

- Account suspension
- Account ban
- Host ability suspension
- Group walk cancellation
- Club restriction
- Trust score review
- Message moderation flag

## 4. Restriction Notice

When a user's account is restricted (warned/suspended/banned), the appeal screen shows:

> "Your account is temporarily restricted while our safety team reviews activity. You can submit an appeal if you believe this was a mistake."

## 5. Trust Score Transparency

The appeal screen includes a trust score explanation:

> "Trust score helps the community understand reliability and safety. It considers profile verification, completed walks, ratings, safety signals, and reviewed reports. Reports trigger review, not automatic punishment. False positives can be corrected. You can appeal any restriction."

## 6. Acceptance Criteria

- [x] Suspended user sees appeal option
- [x] Banned user sees appeal option
- [x] User can submit appeal with reason and explanation
- [x] User can see appeal status
- [x] User receives notification when appeal is resolved
- [x] Copy is calm and respectful
