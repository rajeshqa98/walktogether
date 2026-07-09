# WalkTogether — Village & Town Support Plan

**WalkTogether works everywhere — cities, towns, and villages.**

---

## 1. Design Principles

1. **No metro-city assumption** — The app should work equally well in a village of 500 people and a city of 5 million.
2. **Free-text location entry** — Users can type their village/town/locality name. No forced selection from a preset city list.
3. **Approximate location works** — GPS coordinates are used for matching; the name is for display. Even if coordinates are approximate, the user can still participate.
4. **Low-density is normal** — In villages, finding 1-2 walkers is success. The app shouldn't feel broken with few results.
5. **Community-led growth** — In small communities, one host can transform the area. Empower them.

---

## 2. Location Entry Support

### GPS Location
- Works anywhere with GPS signal
- Coordinates sent to server for distance calculation
- Only approximate labels shown to other users

### Manual Location (Custom Entry)
- User types their location name (village, town, locality)
- Free-text field with search across 44 preset cities
- If location not found in preset list → "Use '[text]' as my location" option
- Server stores the text as city/neighborhood
- For matching: if no coordinates available, user won't appear in nearby searches but CAN create/join group walks and clubs

### Location Fields Stored
| Field | Required | Example |
|-------|----------|---------|
| City/Town/Village | Yes | "Kothapally" |
| Neighborhood/Locality | Optional | "Near bus stand" |
| State/Region | Optional | "Telangana" |
| Country | Optional | "India" |
| Latitude | If GPS | 17.4435 |
| Longitude | If GPS | 78.3772 |
| Location source | Auto | "gps" or "manual" |
| Timezone | Auto | "Asia/Kolkata" |

---

## 3. Village-Specific UX Considerations

### Empty State
"You may be one of the first WalkTogether users in this area. Be the first walker in your village. Invite friends, create a group walk, or start a walking club."

### Group Walk Creation
- Works from any location (city, town, village)
- Meeting point can be any public place (park, temple, school ground, bus stop, market)
- User types meeting point name (free text, not just preset locations)

### Walking Club Creation
- Works from any location
- Club type includes options relevant to villages: "Morning walkers", "Senior walkers", "Women walkers"
- Club is visible to users in nearby areas

### Invite Friends
- Share via WhatsApp (most common in rural India and many developing regions)
- Share via SMS (works on basic phones)
- Share link works even if recipient doesn't have the app yet

---

## 4. Language Considerations (v1.2)

### Current State
- App is in English
- Simple, globally understandable English
- Hindi moderation added in v1.1

### v1.2 Plan
- Add language preference field (already in WaitlistEntry)
- Prioritize translations based on user demographics:
  - Hindi (India — largest user base)
  - Telugu, Tamil, Kannada (South India)
  - Spanish (US, Latin America)
  - Arabic (Middle East)
  - Bahasa Indonesia
- App auto-detects language from phone locale
- Users can switch language in Settings

---

## 5. Village Community Building Strategy

### Step 1: First Walker
- User signs up from a village
- Sees empty state with "Be the first" message
- Invited to create a group walk or invite friends

### Step 2: First Group Walk
- First walker creates a group walk at a local public place (temple ground, school, park)
- Invites friends via WhatsApp
- 2-3 friends join → first walk happens

### Step 3: Walking Club
- After 2-3 successful group walks, first walker creates a walking club
- Club becomes the ongoing community hub
- New users in the area find the club and join

### Step 4: Self-Sustaining
- Club has 5+ active members
- Group walks happen weekly
- New users find walkers via nearby search
- Community is self-sustaining

---

## 6. Admin Support for Village Communities

| Signal | Action |
|--------|--------|
| First signup from a new village | Welcome message + community growth tips |
| 3+ users in a village but no group walks | Admin creates a group walk in that village |
| User in village invites 3+ friends | Celebrate + trust score boost |
| Village has 5+ users | Identify potential host, send host invitation |
| Village walking club created | Feature in admin dashboard as "emerging community" |
