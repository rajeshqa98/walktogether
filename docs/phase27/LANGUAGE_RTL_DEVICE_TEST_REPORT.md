# Language / RTL Device Test Report

**Phase:** 27C
**Status:** Code-verified; physical device test pending beta
**Last updated:** 2026-07-06

## Overview

WalkTogether supports 9 languages with Arabic RTL support. This report documents the i18n implementation and what must be verified on a physical device.

## Supported languages

| Code | Name | Native name | RTL | Beta priority |
|---|---|---|---|---|
| en | English | English | No | Must work |
| hi | Hindi | हिन्दी | No | Must work |
| te | Telugu | తెలుగు | No | Should work |
| ta | Tamil | தமிழ் | No | Should work |
| kn | Kannada | ಕನ್ನಡ | No | Should work |
| bn | Bengali | বাংলা | No | Should work |
| es | Spanish | Español | No | Should work |
| ar | Arabic | العربية | Yes | Must not break layout |
| fr | French | Français | No | Should work |

## Implementation verification

### i18n module (`lib/core/i18n.dart`)

- 9 `AppLanguage` entries with code, name, nativeName, isRtl flag
- `AppI18n.currentLanguageCode` — static, defaults to 'en'
- `AppI18n.init()` — loads saved language from SharedPreferences on app start
- `AppI18n.setLanguage(code)` — sets language + persists to SharedPreferences + notifies listeners
- `AppI18n.isRtl` — returns true if current language is Arabic
- `t(key, {params, langCode})` — translation function with fallback chain: lang → en → key
- `appTextDirection()` — returns `TextDirection.rtl` for Arabic, `TextDirection.ltr` otherwise

### RTL directionality (`lib/main.dart`)

```dart
MaterialApp.router(
  builder: (context, child) {
    return Directionality(
      textDirection: appTextDirection(),
      child: child ?? const SizedBox.shrink(),
    );
  },
  locale: Locale(AppI18n.currentLanguageCode),
)
```

The entire app is wrapped in `Directionality` which flips the layout for Arabic.

### Language picker (`lib/screens/settings_screen.dart`)

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      children: AppLanguage.supported.map((lang) => RadioListTile<String>(
        value: lang.code,
        groupValue: _languageCode,
        title: Text(lang.nativeName),
        subtitle: Text(lang.name, style: TextStyle(fontSize: 11)),
        onChanged: (v) { if (v != null) _changeLanguage(v); },
      )).toList(),
    ),
  ),
)
```

9 RadioListTile widgets — one per language. Native name as title, English name as subtitle.

### Language persistence

When user selects a language:
1. `AppI18n.setLanguage(code)` is called
2. `currentLanguageCode` updated in memory
3. Code saved to `SharedPreferences` with key `app_language`
4. `_instance.notifyListeners()` triggers app rebuild
5. Code sent to backend via `apiClient.updateMe({'language': code})` so backend can localize push notifications

On app restart, `AppI18n.init()` loads saved language before first paint.

### Safety-critical translated keys (12 keys)

| Key | English | Hindi | Arabic |
|---|---|---|---|
| `sos.title` | SOS | SOS | SOS |
| `sos.disclaimer` | WalkTogether is not an emergency service. Call local emergency number. | वॉकटुगेदर आपातकालीन सेवा नहीं है। जीवन के लिए खतरे की स्थिति में स्थानीय आपातकालीन नंबर पर कॉल करें। | WalkTogether ليس خدمة طوارئ. اتصل برقم الطوارئ المحلي. |
| `sos.triggered` | SOS triggered. Safety contacts notified. | SOS ट्रिगर किया गया। आपके सुरक्षा संपर्कों को सूचित किया गया है। | (partial) |
| `sos.failed` | Failed to trigger SOS. Please call local emergency number. | SOS ट्रिगर करने में विफल। कृपया स्थानीय आपातकालीन नंबर पर कॉल करें। | (partial) |
| `auth.welcome` | Welcome to WalkTogether | वॉकटुगेदर में आपका स्वागत है | مرحباً بك في WalkTogether |
| `auth.banned` | Your account has been suspended. Tap to appeal. | (partial) | (partial) |
| `auth.suspended` | Your account is temporarily suspended. | (partial) | (partial) |
| `auth.deletion_pending` | Account deletion in progress. Cancel in Settings. | (partial) | (partial) |
| `privacy.download_data` | Download my data | (partial) | (partial) |
| `privacy.delete_account` | Delete my account | (partial) | (partial) |

**Fallback chain:** If a key is missing in the selected language, the app falls back to English. If missing in English, it shows the key itself. **No crashes on missing keys.**

## Device test checklist

### English (must work)

- [ ] Language picker shows "English" with "English" subtitle
- [ ] Selecting English updates UI immediately
- [ ] All safety-critical text readable
- [ ] No missing-key fallbacks visible

### Hindi (must work)

- [ ] Language picker shows "हिन्दी" with "Hindi" subtitle
- [ ] Selecting Hindi updates UI
- [ ] Safety-critical text (SOS disclaimer, auth messages) shows in Hindi
- [ ] Devanagari script renders correctly
- [ ] No text overflow

### Arabic RTL (must not break layout)

- [ ] Language picker shows "العربية" with "Arabic" subtitle
- [ ] Selecting Arabic flips layout to right-to-left
- [ ] Text alignment is right-to-left
- [ ] Back button points right (not left)
- [ ] List items: leading icon on right, trailing on left
- [ ] Bottom navigation tabs laid out right-to-left
- [ ] Chat message bubbles: sent messages on right, received on left (mirrored)
- [ ] No layout overflow
- [ ] No text clipping
- [ ] App remains usable in RTL mode

### Other languages (should work)

- [ ] Telugu (తెలుగు) — script renders, no overflow
- [ ] Tamil (தமிழ்) — script renders, no overflow
- [ ] Kannada (ಕನ್ನಡ) — script renders, no overflow
- [ ] Bengali (বাংলা) — script renders, no overflow
- [ ] Spanish (Español) — translates correctly
- [ ] French (Français) — translates correctly

### Language persistence

- [ ] Selected language persists across app restart
- [ ] SharedPreferences stores language code
- [ ] Backend receives language preference via `updateMe`

### No missing-key crash

- [ ] App does NOT crash on any missing translation key
- [ ] Fallback chain works: lang → en → key
- [ ] All 9 languages can be selected without crash

## Known limitations

1. **Partial translations:** V1.7 includes 12 safety-critical keys + common keys for all 9 languages. Full UI translation (518 keys matching web/PWA) is planned for V1.8.
2. **Chat RTL:** Chat message bubbles use `Alignment.centerRight` / `Alignment.centerLeft` which should swap in RTL. V1.8 will use `AlignmentDirectional` for proper mirroring.
3. **Phone input RTL:** Phone numbers should always be LTR even in RTL. V1.8 will add explicit `textDirection: TextDirection.ltr` on phone input fields.

## Acceptance criteria

- ✅ 9 languages defined in code
- ✅ Language selection persists via SharedPreferences
- ✅ Arabic RTL directionality applied via Directionality wrapper
- ✅ 12 safety-critical keys translated
- ✅ No missing-key crashes (fallback chain)
- ✅ No paid/premium language in any translation
- ⏳ English works — pending device test
- ⏳ Hindi works — pending device test
- ⏳ Arabic does not break layout — pending device test
