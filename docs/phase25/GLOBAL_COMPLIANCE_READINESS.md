# Global Compliance Readiness

**Phase:** 25
**Status:** Operational (lawyer review pending)
**Last updated:** 2026-07-06
**Owner:** Privacy Lead + Legal Counsel

## Overview

WalkTogether is built to be globally compliant with major privacy and data protection frameworks. This document assesses our operational readiness for India's DPDP Act, the EU's GDPR, California's CCPA/CPRA, children's privacy, and other relevant frameworks. It also documents our policies on emergency disclaimers, location data minimisation, moderation transparency, appeal processes, and the free product promise.

**Important disclaimer:** This is an operational readiness assessment, not a legal certification. Each framework requires lawyer review before we can claim formal compliance. The assessments below describe what we have implemented; the lawyer's job is to verify that the implementation meets the legal requirements.

## India DPDP Act 2023

**Readiness:** Operational

The Digital Personal Data Protection Act 2023 is India's comprehensive privacy law. It applies to WalkTogether because we process personal data of Indian residents.

### What we've implemented

| DPDP requirement | How we comply |
|---|---|
| Right to access (data principal can request their data) | `GET /api/me/export` returns all user data as JSON |
| Right to erasure (data principal can request deletion) | Account deletion with 14-day grace period + anonymization within 30 days |
| Right to correction (data principal can correct inaccurate data) | Privacy request workflow with `data_correction` type |
| Right to grievance redressal | Appeal workflow + privacy request workflow |
| Notice and consent (data principal must be informed of processing) | Terms of Service + Privacy Policy + in-app consent at signup |
| Data breach notification (must notify affected users + Data Protection Board) | Incident response playbook for `data_leak_suspicion` |
| Audit logs preserved | AuditLog table preserved indefinitely |
| Data minimization | Location data minimization (see below) + retention rules |

### Gaps (require legal review)

* Formal consent log per data category (currently bundled into signup consent).
* Explicit Data Fiduciary registration (if required based on user volume).
* Hindi + regional language translations of privacy policy.

### Lawyer review required

Yes — to verify that our consent flow meets DPDP's specific requirements and to confirm our Data Fiduciary obligations.

## GDPR (European Union)

**Readiness:** Operational

The General Data Protection Regulation applies to WalkTogether because we process personal data of EU residents.

### What we've implemented

| GDPR article | How we comply |
|---|---|
| Article 15 — Right of access | Data export endpoint |
| Article 16 — Right to rectification | Privacy request workflow |
| Article 17 — Right to erasure | Account deletion with grace period |
| Article 20 — Right to data portability | JSON data export |
| Article 21 — Right to object | Privacy request workflow |
| Article 25 — Privacy by design | Location minimization + retention rules |
| Article 30 — Records of processing | AuditLog + AdminAccessLog tables |
| Article 33 — Breach notification (72 hours) | Incident response playbook for `data_leak_suspicion` |

### Lawful basis

We process personal data under the following lawful bases:

* **Consent** — User consents at signup to data processing for the purpose of providing the walking companion service.
* **Legitimate interest** — We process safety event data (SOS, reports) under legitimate interest for protecting user safety and preventing abuse.
* **Legal obligation** — We retain audit logs and certain safety records to comply with legal obligations (e.g. responding to law enforcement requests).

### Gaps (require legal review)

* Data Protection Officer (DPO) appointment pending (required if core activities involve large-scale processing).
* Records of Processing Activities (ROPA) not formalized.
* EU representative not appointed (required if processing is "large-scale" or "regular").
* Standard Contractual Clauses (SCCs) not yet reviewed for any cross-border data transfers.

### Lawyer review required

Yes — to appoint DPO, formalize ROPA, and review cross-border transfer mechanisms.

## CCPA / CPRA (California)

**Readiness:** Operational

The California Consumer Privacy Act (CCPA) as amended by the California Privacy Rights Act (CPRA) applies to WalkTogether because we may process personal data of California residents.

### What we've implemented

| CCPA/CPRA right | How we comply |
|---|---|
| Right to know (what data is collected) | Privacy Policy + data export |
| Right to delete | Account deletion workflow |
| Right to correct | Privacy request workflow |
| Right to opt-out of sale | N/A — WalkTogether does not sell user data |
| Right to non-discrimination | Free product — all features free for everyone |

### "Do Not Sell My Personal Information"

Not applicable. WalkTogether does not sell user data, share it with third parties for cross-context behavioral advertising, or use it for any commercial purpose beyond providing the free walking companion service. We commit to never selling user data — this is part of our free product promise.

### Gaps (require legal review)

* Privacy policy update to explicitly reference CPRA.
* Authorized agent process not formalized (a designated agent can submit requests on behalf of a consumer).
* "Do Not Sell" link not needed, but a "Your Privacy Rights" page should be added for clarity.

### Lawyer review required

Yes — to verify our privacy policy meets CCPA/CPRA disclosure requirements.

## Children / Minors Policy

**Readiness:** Operational

WalkTogether is designed for adults (18+). We do not knowingly collect personal data from minors.

### What we've implemented

* Signup requires 18+ confirmation (self-attestation).
* Age range collected at signup (18-24, 25-34, 35-44, 45-54, 55+) — no exact date of birth.
* No targeted advertising to minors (no ads at all).
* No geolocation tracking of minors (no minors allowed).
* COPPA-compliant: we do not knowingly collect data from children under 13 (or under 16 in some jurisdictions).

### Gaps (require legal review)

* Age verification beyond self-attestation not implemented.
* If a minor is discovered to have signed up (e.g. via report), we delete their account immediately and anonymize their data.

### Lawyer review required

Yes — to verify that self-attestation is sufficient and to formalize the process for handling discovered minors.

## Emergency Disclaimer

**Readiness:** Operational

WalkTogether is a companion app, not a substitute for emergency services. We make this clear to users.

### What we've implemented

* Per-country emergency number configured in `CountryActivation.emergencyNumber` (e.g. "112" for India, "911" for US, "999" for UK).
* SOS flow shows local emergency number prominently — users are directed to call it for actual emergencies.
* Terms of Service includes emergency disclaimer.
* Safety education content in app explains when to use SOS vs. call emergency services.

### Disclaimer text (summary)

"WalkTogether is a walking companion app, not an emergency service. If you are in immediate danger, call your local emergency number (e.g. 112 in India, 911 in the US). The SOS button alerts the WalkTogether safety team and your emergency contacts, but should not replace a call to emergency services."

### Lawyer review required

Yes — to verify the disclaimer language is legally sufficient in each operating jurisdiction.

## Location Data Minimization

**Readiness:** Operational

WalkTogether minimizes location data by design. This is one of our most important privacy commitments — location data is highly sensitive and can be used for stalking, harassment, or physical harm.

### What we've implemented

| Principle | Implementation |
|---|---|
| No continuous tracking | LivePresence updated only when user has app open + has explicitly shared location |
| No exact coordinates in normal APIs | Nearby walker API returns coarse distance, not lat/lng |
| No exact coordinates in admin exports | Admin exports exclude lat/lng fields |
| Live presence expires | LivePresence.expiresAt set to 1 hour; retention rule deletes expired rows daily |
| Historical location anonymized | WalkSession.routeSummary anonymized 7 days after walk ends |
| Logs never contain coordinates | redactPayload() redacts lat/lng keys |
| Location cleanup on request | Privacy request type `location_data_cleanup` |

### Lawyer review required

No — this is a technical implementation, not a legal determination.

## Moderation Transparency

**Readiness:** Operational

WalkTogether publishes community guidelines and is transparent about moderation decisions.

### What we've implemented

* Community guidelines published in the in-app Governance Center.
* Every moderation action logged in `AuditLog`.
* Appeal workflow available for every moderation action.
* False-positive dashboard (Phase 24) tracks moderation quality.
* Native speaker review queue (Phase 24) for moderation in 9 languages.
* No auto-ban without admin review.

### Lawyer review required

No — this is a product policy, not a legal determination.

## Appeal Process

**Readiness:** Operational

Every moderation action can be appealed. The appeal process is documented in the in-app Governance Center.

### What we've implemented

* `Appeal` model with full timeline (`AppealTimeline`).
* SLA tracking: critical 24h, suspension 48h, ban 72h, host 72h, general 5d.
* Aging buckets and overdue badges.
* Decision templates for consistency.
* Appeal history preserved indefinitely.

### Lawyer review required

No — this is a product policy.

## Free Product Promise

**Readiness:** Operational

WalkTogether is 100% free for everyone. This is a core product commitment and is verified by an automated compliance scan.

### What we've implemented

* Automated free-product-compliance scan runs in CI.
* No payment gateway integrations.
* No subscription models.
* No premium feature flags.
* No ad SDK integrations.
* Free product promise documented in the in-app Governance Center.

### The promise

"WalkTogether is and will always be free for everyone. No payments, no subscriptions, no premium features, no ads. Safety is not a paid feature — it's a right. We will never charge for safety."

### Lawyer review required

No — this is a product commitment, not a legal determination. However, if we ever change this policy (which we won't), we would need to update Terms of Service and notify users.

## Summary

| Framework | Readiness | Lawyer review |
|---|---|---|
| India DPDP Act 2023 | Operational | Required |
| GDPR | Operational | Required |
| CCPA / CPRA | Operational | Required |
| Children / Minors Policy | Operational | Required |
| Emergency Disclaimer | Operational | Required |
| Location Data Minimization | Operational | Not required |
| Moderation Transparency | Operational | Not required |
| Appeal Process | Operational | Not required |
| Free Product Promise | Operational | Not required |

## Next steps

1. **Engage privacy counsel** — review DPDP, GDPR, and CCPA/CPRA implementations.
2. **Appoint DPO** (if required based on user volume and processing scope).
3. **Formalize ROPA** — Records of Processing Activities.
4. **Translate privacy policy** into Hindi and other major user languages.
5. **Annual compliance review** — re-assess every 12 months.
6. **Quarterly penetration test** — verify technical controls.

## Acceptance criteria

* `/admin/compliance` page loads with all 9 framework assessments.
* Each assessment shows readiness, summary, gaps, controls implemented, and lawyer review flag.
* Overall disclaimer is prominent: "This is an operational readiness assessment, not a legal certification."
* Free product promise is documented and verified by automated scan.
* Location data minimization principles are implemented and enforced.
* Moderation transparency is implemented (Governance Center, appeal workflow).
* No payments, subscriptions, premium features, or ads exist in the codebase.
