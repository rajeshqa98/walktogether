# WalkTogether — Global Rollout Plan

## 30-Day Controlled Global Rollout

### Week 1: Foundation
- Global waitlist live (any country can join)
- Activate 6 countries: India, US, UK, Singapore, UAE, Australia
- Activate 11 cities (see readiness report)
- Invite trusted users by city (from waitlist)
- Group creation limited to verified hosts only
- Daily safety review by admin team
- Monitor: signup rate, OTP delivery, crash rate, safety events

### Week 2: Expansion
- Activate additional cities based on waitlist demand (Chennai, Kolkata, Toronto)
- Invite verified hosts in new cities
- Start women-only group walks where demand exists (≥5 interested women)
- Collect country/city-wise feedback
- Review safety metrics by country/city
- Adjust: pause any city with safety concerns (safetyStatus = "red")

### Week 3: Community
- Expand city invites based on safety + activity metrics
- Add apartment/community group walks
- Add corporate wellness group walks
- Run weekend park/community walks in active cities
- Partner with local walking communities
- Review: retention by city, group walk adoption rate

### Week 4: Review & Decide
- Review global metrics (signups, walks, retention, safety)
- Decide which countries/cities remain active
- Keep low-demand locations as waitlist-only
- Prepare v1.1 fixes (onboarding tooltips, trust score info, safety tips)
- Plan next wave of city activations
- Document lessons learned

### Post-Launch (Week 5+)
- Open signup (remove invite-only) for stable cities
- Continue weekly city activations based on demand
- Expand admin team for timezone coverage
- Launch iOS app (when macOS build available)
- Add language support based on user demographics

## Go/No-Go Criteria Per City
A city is activated only if:
- [ ] Waitlist has ≥10 entries for that city
- [ ] At least 3 verified hosts available (or can be invited)
- [ ] Admin can monitor during that timezone's peak hours
- [ ] Emergency number is configured for the country
- [ ] Privacy policy + terms accessible

A city is paused if:
- [ ] Safety status = "red" (serious incident)
- [ ] Report rate > 10% of active users
- [ ] No active walkers for 7+ days
- [ ] Admin cannot monitor during peak hours

---

# WalkTogether — Country/City Activation Plan

## Activation Workflow

### Step 1: Waitlist Review
Admin reviews waitlist entries grouped by country/city in the pilot dashboard.

### Step 2: Country Activation
1. Admin creates CountryActivation record with:
   - countryCode (ISO 3166-1 alpha-2)
   - countryName
   - emergencyNumber (e.g., "112" for India, "911" for US, "999" for UK)
   - status: "active"
2. Admin verifies privacy policy covers the country's data protection laws

### Step 3: City Activation
1. Admin creates CityActivation record under the country:
   - cityName
   - stateRegion (optional)
   - status: "active"
2. Admin invites waitlist users from that city (creates PilotInvite records)

### Step 4: User Invitation
1. Admin selects waitlist entries by city
2. Admin clicks "Invite" → creates PilotInvite for each phone number
3. Users receive SMS with app download link
4. Users sign up with their phone number (pilot mode checks invite)

### Step 5: Monitoring
1. Admin monitors new city for 7 days
2. Checks: signups, walks, reports, SOS, feedback
3. If safety concerns: set city safetyStatus to "yellow" or "red"
4. If "red": pause city (status = "paused"), cancel active group walks

## Country/City Management API
- `GET /api/admin/activation/countries` — list all countries
- `POST /api/admin/activation/countries` — create/activate country
- `PATCH /api/admin/activation/countries/[id]` — update country status
- `GET /api/admin/activation/cities` — list cities
- `POST /api/admin/activation/cities` — create/activate city
- `PATCH /api/admin/activation/cities/[id]` — update city status
- `GET /api/admin/activation/dashboard` — global launch analytics

## Emergency Numbers by Country

| Country | Code | Emergency # |
|---------|------|-------------|
| India | IN | 112 |
| United States | US | 911 |
| United Kingdom | GB | 999 / 112 |
| Singapore | SG | 999 |
| UAE | AE | 999 |
| Australia | AU | 000 |
| Canada | CA | 911 |
| Germany | DE | 112 |
| Netherlands | NL | 112 |
| Japan | JP | 110 / 119 |
| Brazil | BR | 192 / 193 |
| South Africa | ZA | 10111 |

The app shows the local emergency number during SOS confirmation. If unknown: "Contact your local emergency service immediately."
