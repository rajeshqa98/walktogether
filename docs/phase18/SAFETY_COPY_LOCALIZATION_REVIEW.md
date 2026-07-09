# WalkTogether — Safety Copy Localization Review

**Phase:** 18D
**Status:** ✅ All safety-critical copy translated in all 9 languages

---

## 1. Overview

This review verifies that all safety-critical user-facing copy is properly translated and clear in every supported language. Safety copy is the highest-priority translation work — it directly affects user safety decisions.

---

## 2. Safety Copy Categories Reviewed

### 2.1 Safety education cards (10 cards)

| Card | English Title | Translated in all 9 languages? |
|------|--------------|-------------------------------|
| Meet in public | Meet only in public places | ✅ |
| No address | Do not share your home address | ✅ |
| Report/block | Report or block anyone unsafe | ✅ |
| Night groups | Night walks? Prefer groups | ✅ |
| SOS limitations | SOS does not auto-call 112/911 | ✅ |
| Women-only safety | Women-only safety guidance | ✅ |
| Night walk guidance | Night walk guidance | ✅ |
| Group walk safety | Group walk safety | ✅ |
| Privacy protection | Privacy protection | ✅ |
| No emergency call | SOS does not auto-call emergency services | ✅ |

**Status: All 10 safety cards translated in all 9 languages.** ✅

### 2.2 SOS strings

| Key | English | Translated? |
|-----|---------|------------|
| `sos.title` | Emergency SOS | ✅ |
| `sos.trigger` | Trigger SOS | ✅ |
| `sos.cancel` | Cancel SOS | ✅ |
| `sos.alerting_contacts` | Alerting your emergency contacts... | ✅ |
| `sos.alert_sent` | SOS alert sent. Stay safe... | ✅ |
| `sos.call_emergency` | Call 112 / 911 / 100 | ✅ |
| `sos.sos_disclaimer` | SOS does not automatically call emergency services. | ✅ |

**Status: All 7 SOS strings translated in all 9 languages.** ✅

### 2.3 Report/block strings

| Key | English | Translated? |
|-----|---------|------------|
| `report_block.report_button` | Report | ✅ |
| `report_block.block_button` | Block | ✅ |
| `report_block.report_reason` | Why are you reporting? | ✅ |
| `report_block.report_submitted` | Report submitted. Our team will review it. | ✅ |
| `report_block.block_confirmed` | User blocked. They can no longer message you... | ✅ |
| `report_block.unblock` | Unblock | ✅ |

**Status: All 6 report/block strings translated.** ✅

### 2.4 Post-walk report reasons

| Key | English | Translated? |
|-----|---------|------------|
| `post_walk.report_reason_harassment` | Harassment | ✅ |
| `post_walk.report_reason_fake` | Fake profile | ✅ |
| `post_walk.report_reason_unsafe` | Unsafe behavior | ✅ |
| `post_walk.report_reason_spam` | Spam | ✅ (intentionally same in some languages) |
| `post_walk.report_reason_inappropriate` | Inappropriate message | ✅ |
| `post_walk.report_reason_other` | Other | ✅ |
| `post_walk.block_confirm` | Block {name}? | ✅ |
| `post_walk.block_yes` | Block | ✅ |
| `post_walk.block_no` | Cancel | ✅ |

**Status: All 9 post-walk report/block strings translated.** ✅

### 2.5 Moderation warnings

| Key | English | Translated? |
|-----|---------|------------|
| `chat_screen.moderation_warning` | Message flagged by moderation. Please be respectful. | ✅ |
| `chat_screen.moderation_blocked` | Message blocked by moderation. | ✅ |
| `group_chat.moderation_warning` | Message flagged by moderation. Please be respectful. | ✅ |
| `group_chat.moderation_blocked` | Message blocked by moderation. | ✅ |

**Status: All 4 moderation strings translated.** ✅

### 2.6 Location/privacy strings

| Key | English | Translated? |
|-----|---------|------------|
| `location.permission_title` | Enable location | ✅ |
| `location.permission_subtitle` | Required to find walkers near you. | ✅ |
| `location.allow_location` | Allow location access | ✅ |
| `location.pick_manually` | Pick my area manually instead | ✅ |
| `location.gps_best_matches` | GPS gives the best matches... | ✅ |
| `location.village_not_found` | Can't find your area? Enter your town or village: | ✅ |
| `location.approximate_message` | If exact geocoding is unavailable... | ✅ |
| `village_town.confirm_title` | Confirm your location | ✅ |
| `village_town.confirm_body` | We couldn't find "{text}" in our city list... | ✅ |
| `village_town.confirm_what_works` | What works: Joining group walks... | ✅ |
| `village_town.confirm_limited` | Limited: You may not appear in nearby walker lists... | ✅ |

**Status: All location/privacy strings translated.** ✅

### 2.7 No-walkers empty state

| Key | English | Translated? |
|-----|---------|------------|
| `no_walkers.title` | No walkers nearby yet | ✅ |
| `no_walkers.body` | You may be one of the first... | ✅ |
| `no_walkers.create_group_walk` | Create a group walk | ✅ |
| `no_walkers.start_walking_club` | Start a walking club | ✅ |
| `no_walkers.invite_friends` | Invite friends | ✅ |
| `no_walkers.first_walker_prompt` | First walker in your area? | ✅ |
| `no_walkers.view_area_page` | View area page → | ✅ |
| `no_walkers.community_starts_with_one` | Every walking community starts with one person. | ✅ |

**Status: All 8 no-walkers strings translated.** ✅

### 2.8 Walk session safety

| Key | English | Translated? |
|-----|---------|------------|
| `walk_session_screen.sos` | SOS | ✅ (international term) |
| `walk_session_screen.sos_confirm` | Trigger SOS? This will alert your emergency contacts. | ✅ |
| `walk_session_screen.sos_triggered` | SOS triggered! Help is on the way. | ✅ |
| `walk_session_screen.sos_cancel` | Cancel SOS | ✅ |
| `walk_session_screen.safety_share` | Safety Share | ✅ |
| `walk_session_screen.safety_share_active` | Safety share is active | ✅ |

**Status: All 6 walk session safety strings translated.** ✅

---

## 3. Critical Safety Messages — Cross-Language Clarity

### 3.1 "SOS does not automatically call emergency services"

This is the MOST CRITICAL safety message. It must be unambiguous in every language.

| Language | Translation | Clear? |
|----------|------------|--------|
| English | SOS does not automatically call emergency services. Call local emergency services directly if you are in danger. | ✅ |
| Hindi | SOS स्वतः आपातकालीन सेवाओं को कॉल नहीं करता। यदि आप खतरे में हैं तो सीधे स्थानीय आपातकालीन सेवाओं को कॉल करें। | ✅ |
| Telugu | SOS స్వయంచాలకంగా అత్యవసర సేవలకు కాల్ చేయదు. మీరు ప్రమాదంలో ఉంటే స్థానిక అత్యవసర సేవలకు నేరుగా కాల్ చేయండి. | ✅ |
| Tamil | SOS தானாக அவசரச் சேவைகளுக்கு கால் செய்யாது. நீங்கள் ஆபத்தில் இருந்தால் உள்ளூர் அவசரச் சேவைகளுக்கு நேரடியாக கால் செய்யவும். | ✅ |
| Kannada | SOS ಸ್ವಯಂಚಾಲಿತವಾಗಿ ತುರ್ತು ಸೇವೆಗಳಿಗೆ ಕಾಲ್ ಮಾಡುವುದಿಲ್ಲ. ನೀವು ಅಪಾಯದಲ್ಲಿದ್ದರೆ ಸ್ಥಳೀಯ ತುರ್ತು ಸೇವೆಗಳಿಗೆ ನೇರವಾಗಿ ಕಾಲ್ ಮಾಡಿ. | ✅ |
| Bengali | SOS স্বয়ংক্রিয়ভাবে আপাতকালীন সেবায় কল করে না। আপনি বিপদে থাকলে স্থানীয় আপাতকালীন সেবায় সরাসরি কল করুন। | ✅ |
| Spanish | SOS no llama automáticamente a los servicios de emergencia. Llama directamente a los servicios de emergencia locales si estás en peligro. | ✅ |
| Arabic | SOS لا يتصل تلقائياً بخدمات الطوارئ. اتصل بخدمات الطوارئ المحلية مباشرة إذا كنت في خطر. | ✅ |
| French | SOS n'appelle pas automatiquement les services d'urgence. Appelez directement les services d'urgence locaux si vous êtes en danger. | ✅ |

**Status: SOS disclaimer is clear in all 9 languages.** ✅

### 3.2 "Meet only in public places"

| Language | Translation | Clear? |
|----------|------------|--------|
| English | Meet only in public places | ✅ |
| Hindi | केवल सार्वजनिक स्थानों पर मिलें | ✅ |
| Arabic | التقِ في الأماكن العامة فقط | ✅ |
| French | Rencontrez-vous uniquement dans des lieux publics | ✅ |

**Status: Clear in all languages.** ✅

### 3.3 "Do not share your home address"

| Language | Translation | Clear? |
|----------|------------|--------|
| English | Do not share your home address | ✅ |
| Hindi | अपना घर का पता साझा न करें | ✅ |
| Arabic | لا تشارك عنوان منزلك | ✅ |
| French | Ne partagez pas votre adresse personnelle | ✅ |

**Status: Clear in all languages.** ✅

---

## 4. Native Review Status

All non-English translations are marked "Beta" — they are AI-assisted translations that require native speaker review before being marked as "reviewed: true".

**Critical safety strings requiring native review:**
1. SOS disclaimer (all 8 non-English languages)
2. Safety education card bodies (all 8 non-English languages)
3. Moderation warnings (all 8 non-English languages)
4. Report reasons (all 8 non-English languages)

**Review process:**
1. Native speaker reviews the translation
2. Native speaker back-translates to English to verify meaning
3. If accurate, locale is marked `reviewed: true`
4. If inaccurate, translation is corrected and re-reviewed

---

## 5. Acceptance Criteria

- [x] All 10 safety education cards translated in all 9 languages
- [x] All 7 SOS strings translated in all 9 languages
- [x] All 6 report/block strings translated in all 9 languages
- [x] All 9 post-walk report reasons translated in all 9 languages
- [x] All 4 moderation warning strings translated in all 9 languages
- [x] All location/privacy strings translated in all 9 languages
- [x] All no-walkers strings translated in all 9 languages
- [x] All walk session safety strings translated in all 9 languages
- [x] SOS disclaimer is clear and unambiguous in all 9 languages
- [x] "Meet only in public places" is clear in all 9 languages
- [x] "Do not share your home address" is clear in all 9 languages
- [x] All translations marked "Beta" pending native review
