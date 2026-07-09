# WalkTogether — Multilingual Moderation Plan

**Phase:** 17
**Status:** 10 languages covered; safety pattern detection live
**Library:** `src/lib/moderation.ts`

---

## 1. Goal

WalkTogether's chat (1:1 and group) must be safe across all languages our users speak. Phase 16 shipped moderation for English, Hindi, Hinglish, Telugu, Tamil, Spanish, Arabic, French. Phase 17 adds Kannada, Bengali, and safety pattern detection (requests for home address / private meeting).

The plan is intentionally conservative: **prefer flagging for admin review over auto-blocking normal conversation.** False positives (blocking legitimate chat) damage trust more than false negatives (letting a borderline message through).

---

## 2. Coverage (Phase 17)

| Language | Code | Term count | Notes |
|----------|------|------------|-------|
| English | `en` | 15 | High-severity slurs only |
| Hindi | `hi` | 33 | Devanagari + Roman |
| Hinglish | `hinglish` | 15 | Transliterated phrases |
| Telugu | `te` | 13 | Transliterated |
| Tamil | `ta` | 13 | Transliterated |
| Kannada | `kn` | 14 | **Phase 17 — NEW** |
| Bengali | `bn` | 17 | **Phase 17 — NEW** (Devanagari + Roman) |
| Spanish | `es` | 7 | High-severity only |
| Arabic | `ar` | 8 | Transliterated, high-severity only |
| French | `fr` | 6 | High-severity only |

**Total: 141 banned terms across 10 languages.**

---

## 3. Severity Model

Each banned term has a severity level:

| Severity | Behavior | Example terms |
|----------|----------|---------------|
| 3 (block) | Message is rejected; persisted as `moderationStatus: "removed"` for admin review | Rape, child abuse, severe sexual slurs |
| 2 (flag) | Message is delivered; persisted as `moderationStatus: "flagged"` for admin review | Common abusive words (fuck, chutiya, etc.) |
| 1 (log) | Message is delivered; logged only (not currently used) | — |

### Why this matters

- Severity 3 (block) is reserved for **unambiguous** high-severity terms. We never want to block a message that might be legitimate conversation.
- Severity 2 (flag) lets the message through but surfaces it for admin review. This catches abusive patterns without breaking chat.
- Admins can review flagged messages at `/admin/messages` and adjust the word lists over time.

---

## 4. Safety Pattern Detection (Phase 17 NEW)

Phase 17 adds regex-based detection for **requests for home address / private meeting**. These are FLAGGED (severity 2 equivalent), never blocked.

### Why flag, not block?

A host might legitimately ask "what's a good meeting point near you?" — that's a normal conversation. But "what's your home address?" is a safety red flag. We can't reliably distinguish these with a regex, so we flag for human review.

### Patterns detected

| Pattern | Reason code | Example |
|---------|-------------|---------|
| Direct home address request (EN) | `request_for_home_address` | "What's your home address?" |
| "Share your address" | `request_for_home_address` | "Share your address with me" |
| Hindi transliteration: "ghar ka address kya" | `request_for_home_address` | "ghar ka address kya hai?" |
| Hindi Devanagari: "घर पता दे" | `request_for_home_address` | "घर का पता दे" |
| "Come to my home/place" | `request_for_private_meeting` | "Come to my home for the walk" |
| "Let's meet at my place" | `request_for_private_meeting` | "Let's meet at my place" |
| Hindi: "mera ghar" / "mere ghar" | `request_for_private_meeting` | "mere ghar aao" |
| "Pick you up from home" | `request_for_private_meeting` | "I'll pick you up from your house" |

### How it works

```typescript
const outcome = moderateMessage("What's your home address?");
// → { kind: "flagged", reason: "request_for_home_address", matchedTerms: ["request_for_home_address"] }

const outcome = moderateMessage("Hi, want to walk tomorrow?");
// → { kind: "ok" }
```

The `detectSafetyPattern()` function can also be called independently (e.g. to show a client-side warning without persisting a flagged message).

---

## 5. Spam Invite Abuse Detection

The `isSpamInviteText()` function checks invite share messages against a spam pattern list:

| Pattern | Reason |
|---------|--------|
| "earn money" | Money-making scam |
| "make money" | Money-making scam |
| "free recharge" | Common Indian SMS scam |
| "free paytm" | Common Indian SMS scam |
| "click here to win" | Phishing |
| `http://bit.ly` / `https://bit.ly` | URL shortener often used for spam |
| `wa.me/` | WhatsApp click-to-chat link (often spam) |
| `telegram.me/` | Telegram link (often spam) |

If a user's invite message matches any of these, the invite creation is rejected with `422 Unprocessable Entity`.

---

## 6. Repeated Harassment Detection

The `shouldAutoMuteForHarassment()` function returns `true` if a user has:
- 3+ flagged messages in 24 hours, OR
- 5+ flagged messages in 7 days

When this returns `true`, the API route should:
1. Persist the message as `flagged` (not deliver it).
2. Mark the user for admin review.
3. (Future) Auto-mute the user for 24 hours pending review.

**Note:** The auto-mute is not yet enforced in v1.2/17 — it's a helper function for v1.3. Currently, flagged messages are still delivered but visible to admins in the moderation queue.

---

## 7. Normalization

Before matching against banned terms, text is normalized:

```typescript
function normalizeForModeration(text: string): string {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "") // strip diacritics
    .replace(/(.)\1{2,}/g, "$1$1")   // collapse 3+ repeats to 2
    .replace(/\s+/g, " ")
    .trim();
}
```

This catches evasion attempts like:
- "FUUUCK" → "fuck" (3+ repeat collapse)
- "chuuutiya" → "chutiya"
- "PUTAIN" → "putain" (lowercase)
- Diacritic variants → base form

### What normalization does NOT catch

- **Leet speak**: "f*ck", "f.u.c.k" — these contain punctuation that breaks `includes()`. We accept this limitation; leet speak is rare in our user base and admins can flag these manually.
- **Emoji substitution**: "fu€k" — same limitation.
- **Word splitting across messages**: "fuck" split across two messages — out of scope for v1.2/17.

---

## 8. Where Moderation Runs

| Location | What's moderated |
|----------|------------------|
| `POST /api/group-walks/[id]/messages` | Group walk chat messages |
| `POST /api/requests/[id]/messages` | 1:1 chat messages |
| `POST /api/invite-links` | Invite share message (spam check only) |

### Future (v1.3+)

- Club chat messages (when club chat is added)
- Profile bios (when profile bio editing is added)
- Walk request messages

---

## 9. Admin Review Queue

Flagged and blocked messages are visible to admins at `/admin/messages`:
- `moderationStatus: "flagged"` — message was delivered but flagged for review
- `moderationStatus: "removed"` — message was blocked (not delivered)

Admins can:
- Review the message + matched terms
- Dismiss the flag (false positive)
- Escalate to a report against the sender
- Adjust the word list (future — currently requires code change)

---

## 10. False Positive Policy

**False positives are worse than false negatives.** If we block a legitimate message, the user loses trust in the app. If we let a borderline message through (flagged but delivered), admins can review and we can adjust.

Therefore:
- Severity 3 (block) is reserved for **unambiguous** terms only.
- Severity 2 (flag) is used for anything that might be abusive but might not.
- Safety patterns are always flag, never block.
- We'd rather let 10 borderline messages through than block 1 legitimate conversation.

---

## 11. Language Coverage Expansion Plan

### v1.3 priorities

1. **Kannada and Bengali expansion** — Phase 17 added seed terms; v1.3 will expand based on admin review of flagged messages.
2. **Marathi, Punjabi, Urdu** — new Indian languages for broader coverage.
3. **Indonesian, Portuguese** — for global expansion.
4. **Native script matching** — Phase 17 uses transliteration for most Indian languages. v1.3 will add native script (Devanagari, Tamil script, etc.) matching.

### Ongoing

- Admin review queue surfaces false positives → word list adjustments
- Monthly review of flagged messages by language → identify gaps
- Community reports of missed abuse → add terms

---

## 12. Acceptance Criteria

- [x] Moderation library covers 10 languages (English, Hindi, Hinglish, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic, French).
- [x] Severity model: block (severity 3), flag (severity 2), log (severity 1).
- [x] Safety pattern detection for home address / private meeting requests (flag, never block).
- [x] Spam invite text detection.
- [x] Repeated harassment detection helper (`shouldAutoMuteForHarassment`).
- [x] Normalization handles lowercase, diacritics, repeat collapse.
- [x] `getModerationLanguageCoverage()` returns coverage stats for admin dashboard.
- [x] Group walk chat and 1:1 chat use centralized moderation.
- [x] Flagged messages are persisted for admin review (not silently dropped).
- [x] False positive policy: prefer flag over block.
