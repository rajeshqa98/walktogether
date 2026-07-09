# WalkTogether — v1.2 Improvement Backlog

**Based on:** Phase 15 global free launch learnings | **No monetization features**

---

## Priority Matrix

| Priority | Count | Description |
|----------|-------|-------------|
| 🔴 High | 5 | Core UX + safety improvements |
| 🟡 Medium | 6 | Growth + community features |
| 🟢 Low | 4 | Polish + future readiness |

---

## v1.2 Backlog

### 🔴 High Priority

#### 1. Better village/town search with geocoding
- **Problem:** Custom location entry stores text but not coordinates — user can't be found in nearby search
- **Fix:** Integrate free geocoding API (Nominatim/OpenStreetMap) to convert text to coordinates
- **Effort:** 8 hours

#### 2. Local language support (Hindi first)
- **Problem:** App is English-only; many village/town users prefer Hindi
- **Fix:** Add Hindi translations for all screens. Auto-detect from phone locale.
- **Effort:** 40 hours

#### 3. Host onboarding flow
- **Problem:** No in-app host recruitment or onboarding
- **Fix:** Settings → "Become a Community Host" → read guidelines → create first walk → host badge
- **Effort:** 6 hours

#### 4. Community invite links
- **Problem:** Users share generic app link; recipients don't know which area/club to join
- **Fix:** Deep links that pre-fill location or auto-join a specific group walk/club
- **Effort:** 8 hours

#### 5. Improved moderation language coverage
- **Problem:** Only English + Hindi moderation; other languages may miss abuse
- **Fix:** Add Spanish, Arabic, Bahasa, Tamil, Telugu banned word lists
- **Effort:** 4 hours

### 🟡 Medium Priority

#### 6. Better group walk discovery
- **Problem:** Group walks only shown in Groups tab; users on Home don't see them
- **Fix:** Show "Nearby group walks" section on Home screen when no walkers found
- **Effort:** 4 hours

#### 7. Nearby walking clubs
- **Problem:** Clubs only shown in Groups → Clubs tab
- **Fix:** Show "Walking clubs near you" on Home or Groups screen
- **Effort:** 3 hours

#### 8. Public place suggestions (global)
- **Problem:** Only 18 preset meeting points; doesn't cover global locations
- **Fix:** Use OpenStreetMap POI API to suggest parks/cafes near user's location
- **Effort:** 8 hours

#### 9. Stronger safety education
- **Problem:** Safety tips are passive; users may not read them
- **Fix:** Interactive safety checklist before first walk. "Walk safety quiz" for new users.
- **Effort:** 6 hours

#### 10. Improved trust score explanation
- **Problem:** Trust score modal exists but could be more visual
- **Fix:** Visual breakdown: walks (+X), ratings (+X), verification (+X), reports (-X)
- **Effort:** 3 hours

#### 11. Profile photo upload
- **Problem:** Not working since v1.0
- **Fix:** Implement photo upload with Supabase Storage or S3
- **Effort:** 6 hours

### 🟢 Low Priority

#### 12. Walking route suggestions
- Integrate Google Maps/OSM directions for suggested routes from meeting point
- **Effort:** 8 hours

#### 13. Scheduled one-to-one walks
- Add "schedule for later" option on walk requests
- **Effort:** 6 hours

#### 14. Apple Health / Google Fit
- Sync walk duration to health apps
- **Effort:** 6 hours

#### 15. Offline mode
- Cache nearby walkers for offline viewing
- **Effort:** 16 hours

---

## NOT in v1.2 (Explicitly Excluded)

- ❌ Payments / premium / subscription
- ❌ Ads
- ❌ AI features (chat moderation AI, smart matching AI)
- ❌ Video/voice calls (complex, safety implications)
- ❌ Background location tracking
- ❌ Dating features
- ❌ Social feed / timeline
