# WalkTogether — Tester Feedback Summary

**Beta Period:** [START DATE] to [END DATE]  
**Total Feedback Submissions:** 9  
**Last Updated:** [DATE]

---

## 1. Feedback by Category

| Category | Count | Must Fix | Should Fix | Nice to Have | Not Planned |
|----------|-------|----------|------------|--------------|-------------|
| Safety concerns | 2 | 0 | 1 | 1 | 0 |
| Confusing UX | 2 | 0 | 2 | 0 | 0 |
| Missing features | 2 | 0 | 0 | 2 | 0 |
| Bugs | 1 | 0 | 0 | 0 | 1 (fixed) |
| Trust concerns | 1 | 0 | 1 | 0 | 0 |
| Location/privacy | 1 | 0 | 0 | 1 | 0 |
| **Total** | **9** | **0** | **4** | **4** | **1** |

---

## 2. Detailed Feedback Items

### Item 1: Safety — Isolated meeting point at 6 AM
- **Category:** Safety concern
- **Rating:** 4/5
- **Tester:** Tester 3 (Friends/family group)
- **Message:** "The meeting point was a public park but it felt isolated at 6 AM. There was no one around. Maybe suggest meeting points that are busier at early hours."
- **Priority:** Should fix
- **Action:** Add time-of-day safety tips. If walk is before 7 AM, show additional tip: "For early morning walks, choose well-lit, popular meeting points with other people around."
- **Target:** v1.1.0

### Item 2: Safety — Wanted more info before meeting
- **Category:** Safety concern
- **Rating:** 4/5
- **Tester:** Tester 5 (Women safety group)
- **Message:** "I wanted to know more about the person before agreeing to walk. The trust score helps but I wish I could see how many walks they've completed and their recent ratings."
- **Priority:** Nice to have
- **Action:** Walker detail screen already shows completed walks count. Consider adding "recent ratings" display in v1.1.0.
- **Target:** v1.1.0

### Item 3: UX — How to send a walk request
- **Category:** Confusing UX
- **Rating:** 3/5
- **Tester:** Tester 4 (Hyderabad pilot)
- **Message:** "I found walkers nearby but couldn't figure out how to send a request. I tapped on the card but didn't see a clear 'Send request' button."
- **Priority:** Should fix
- **Action:** Add onboarding tooltip on home screen: "Tap a walker's card to view their profile and send a walk request."
- **Target:** v1.1.0

### Item 4: UX — Trust score explanation
- **Category:** Confusing UX
- **Rating:** 4/5
- **Tester:** Tester 7 (Group walk testers)
- **Message:** "What does the trust score mean? How is it calculated? I see numbers like 78 and 42 but don't know if that's good or bad."
- **Priority:** Should fix
- **Action:** Add "How is my trust score calculated?" info screen accessible from Settings and walker detail.
- **Target:** v1.1.0

### Item 5: Feature — Walking routes
- **Category:** Missing feature
- **Rating:** 5/5
- **Tester:** Tester 1 (Internal)
- **Message:** "It would be great to see suggested walking routes from the meeting point. Like a 1km loop or a 2km path."
- **Priority:** Nice to have
- **Action:** Consider for v1.2.0 — would require map integration (Google Maps or Mapbox).
- **Target:** v1.2.0

### Item 6: Feature — Schedule walks for later
- **Category:** Missing feature
- **Rating:** 5/5
- **Tester:** Tester 8 (Group walk testers)
- **Message:** "I want to schedule a walk for tomorrow morning, not just walk right now. Group walks have scheduling but one-to-one doesn't."
- **Priority:** Nice to have
- **Action:** Consider scheduled walk requests for v1.2.0.
- **Target:** v1.2.0

### Item 7: Bug — Chat message delayed
- **Category:** Bug
- **Rating:** 3/5
- **Tester:** Tester 5 (Women safety group)
- **Message:** "Messages were delayed by 3-5 seconds. Not a huge deal but made the conversation feel laggy."
- **Priority:** Fixed
- **Action:** Reduced socket reconnection interval from 10s to 3s. Fixed in v1.0.1.
- **Status:** ✅ Fixed

### Item 8: Trust — Nervous about walking with strangers
- **Category:** Trust concern
- **Rating:** 4/5
- **Tester:** Tester 6 (Women safety group)
- **Message:** "I'm nervous about walking with someone I don't know. The verified badge helps but I wish there was a way to video call or voice call before meeting."
- **Priority:** Should fix
- **Action:** Video/voice call is a significant feature — defer to v1.2.0. In the meantime, improve trust signals: add "completed walks" badge more prominently, consider mutual friends feature.
- **Target:** v1.2.0 (call feature) / v1.1.0 (improved trust signals)

### Item 9: Privacy — What location data is shared?
- **Category:** Location/privacy
- **Rating:** 5/5
- **Tester:** Tester 2 (Internal)
- **Message:** "I want to know exactly what location data is shared with other users. The app says 'approximate' but how approximate?"
- **Priority:** Nice to have
- **Action:** Privacy Policy already covers this. Add a brief in-app explanation: "Other users see 'within 300m' style labels — never your exact coordinates. After you accept a walk, only the public meeting point is shared."
- **Target:** v1.1.0

---

## 3. Feedback Themes

### Theme 1: Trust is the biggest barrier
Multiple testers expressed hesitation about walking with strangers. The trust score and verified badge help, but new users (especially women) want more reassurance. **Key insight: trust features are critical for adoption.**

### Theme 2: Onboarding needs improvement
Two testers found the app confusing initially — specifically how to send a walk request and what trust scores mean. **Key insight: add contextual tooltips for first-time users.**

### Theme 3: Safety features appreciated
All testers who tested SOS and safety share felt reassured by these features. The SOS confirmation dialog was clear and didn't cause panic. **Key insight: safety-first positioning resonates with users.**

### Theme 4: Group walks are popular
7 out of 24 testers joined group walks, and feedback was positive. Group walks feel safer than one-to-one for many users. **Key insight: promote group walks as the entry point for new users.**

### Theme 5: Feature requests are future-focused
Missing features (walking routes, scheduled walks, video calls) are all valid but not launch blockers. Users are satisfied with the core flow. **Key insight: v1.0 has the right scope.**

---

## 4. Action Items Summary

### Must Fix Before Launch (0 items)
None — no must-fix items identified.

### Should Fix Soon (4 items → v1.1.0)
1. Add time-of-day safety tips for early morning/late evening walks
2. Add onboarding tooltip: "Tap a walker's card to send a request"
3. Add trust score explanation info screen
4. Add in-app privacy explanation: "What location data is shared?"

### Nice to Have (4 items → v1.2.0+)
1. Walking route suggestions from meeting point
2. Scheduled one-to-one walk requests
3. Video/voice call before meeting
4. Recent ratings display on walker detail

### Fixed (1 item → v1.0.1)
1. Chat message delay (socket reconnection interval reduced)

---

## 5. Overall Tester Sentiment

| Question | Positive | Neutral | Negative |
|----------|----------|---------|----------|
| "Would you use WalkTogether again?" | 8 | 1 | 0 |
| "Do you feel safe using the app?" | 7 | 2 | 0 |
| "Would you recommend it to a friend?" | 7 | 2 | 0 |
| "Is the app easy to use?" | 6 | 3 | 0 |

**Overall sentiment:** Positive. No negative feedback. Testers appreciate the safety-first approach and find the core flow usable. Trust features are the key differentiator.
