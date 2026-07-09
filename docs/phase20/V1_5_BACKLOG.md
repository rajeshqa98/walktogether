# WalkTogether — v1.5 Backlog

**Phase:** 20
**Status:** Defined; not yet scheduled
**Release target:** v1.5

---

## 1. Purpose

This backlog defines the next release (v1.5) based on Phase 20 review findings. Every item is **free** — no monetization, no premium tier, no paid features.

---

## 2. v1.5 Themes

1. **Better safety task assignment** — distribute workload among admins
2. **Admin workload analytics** — track admin review speed and quality
3. **Host badge improvements** — display trusted host badge in UI
4. **Trust score transparency** — show users their trust score and how to improve
5. **User appeal flow** — let users appeal safety decisions
6. **Stronger community reporting** — improved report flow with categories
7. **Local language moderation improvements** — expand word lists based on FP data
8. **Better village/town dashboard** — village-specific growth metrics
9. **Advanced low-density growth nudges** — automated growth suggestions

---

## 3. Detailed Items

### 3.1 Better safety task assignment

**Priority:** P1
**Effort:** 12 hours

**Scope:**
- Auto-assign tasks to least-busy admin
- Admin can self-assign tasks
- Track admin workload (open tasks per admin)
- Task reassignment between admins
- Admin availability status (online/away/offline)

### 3.2 Admin workload analytics

**Priority:** P1
**Effort:** 8 hours

**Scope:**
- Track admin review speed (time from assignment to resolution)
- Track admin accuracy (false positive rate per admin)
- Admin workload dashboard (tasks per admin, resolution time)
- Identify bottlenecks (tasks stuck in "reviewing" too long)

### 3.3 Host badge improvements

**Priority:** P1
**Effort:** 6 hours

**Scope:**
- Display "Trusted Host" badge on WalkerCard
- Display "Community Host" badge on Profile screen
- Host badge in GroupWalkDetail (already done in Phase 18B)
- Host badge in ClubDetail (already done in Phase 18B)
- Trust score explanation modal for users

### 3.4 Trust score transparency

**Priority:** P1
**Effort:** 10 hours

**Scope:**
- Show trust score on user's own Profile
- Show trust score breakdown (walks, ratings, verification, reports)
- Explain how to improve trust score
- Show trust score on WalkerCard (already shown)
- Trust score history graph

### 3.5 User appeal flow

**Priority:** P1
**Effort:** 12 hours

**Scope:**
- Settings → "Appeal a safety decision" form
- User can submit appeal with explanation
- Appeal creates a safety task with type "appeal"
- Admin reviews appeal in safety queue
- User notified when appeal is resolved
- All appeal copy translated in 9 languages (keys already exist)

### 3.6 Stronger community reporting

**Priority:** P2
**Effort:** 8 hours

**Scope:**
- Report flow with categories (harassment, unsafe, spam, etc.)
- Evidence upload (screenshot)
- Report history for user
- Admin can see all reports by a user
- Report resolution notification to reporter

### 3.7 Local language moderation improvements

**Priority:** P2
**Effort:** 16 hours

**Scope:**
- Expand word lists based on false positive data
- Add phrase-level matching (not just word-level)
- Improve transliteration coverage
- Add Marathi, Punjabi, Urdu (new languages)
- Native script matching for Devanagari, Tamil, etc.
- Track missed abusive messages (from admin reviews)

### 3.8 Better village/town dashboard

**Priority:** P2
**Effort:** 10 hours

**Scope:**
- Village/town-specific growth metrics
- Village/town leaderboard (coarse, no exact locations)
- Village/town invite conversion tracking
- Village/town host coverage map
- Village/town language preference

### 3.9 Advanced low-density growth nudges

**Priority:** P2
**Effort:** 8 hours

**Scope:**
- Automated growth suggestions for low-density areas
- "Invite 3 friends" challenge with progress tracking
- Area growth campaign templates
- Community ambassador program for low-density areas
- WhatsApp share copy specifically for villages/towns

---

## 4. Items Explicitly Excluded from v1.5

- ❌ Payments, subscriptions, premium tiers
- ❌ Paid filters or paid safety features
- ❌ Ads or sponsored content
- ❌ In-app purchases
- ❌ Paid host certification
- ❌ Selling user data
- ❌ Paid "boost" for group walks or clubs

---

## 5. Priority Matrix

| Item | Priority | Effort | Impact |
|------|----------|--------|--------|
| Safety task assignment | P1 | 12h | High (admin efficiency) |
| Admin workload analytics | P1 | 8h | High (admin management) |
| Host badge improvements | P1 | 6h | Medium (host retention) |
| Trust score transparency | P1 | 10h | High (user trust) |
| User appeal flow | P1 | 12h | High (user fairness) |
| Stronger community reporting | P2 | 8h | Medium (safety) |
| Local language moderation | P2 | 16h | Medium (moderation) |
| Village/town dashboard | P2 | 10h | Medium (growth) |
| Low-density growth nudges | P2 | 8h | Low (engagement) |

**Total effort:** ~90 hours (P1 = 48h, P2 = 42h)

---

## 6. Acceptance Criteria for v1.5

- [ ] All P1 items complete (safety assignment, analytics, badges, trust, appeals)
- [ ] At least 3 P2 items complete
- [ ] No monetization features added
- [ ] All features remain free
- [ ] Compliance scanner still passes
- [ ] Phase 20 monitoring continues to track all v1.5 features
