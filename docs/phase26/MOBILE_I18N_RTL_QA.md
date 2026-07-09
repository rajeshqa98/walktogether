# Mobile i18n + RTL QA

**Phase:** 26
**Status:** 9 languages implemented; RTL applied for Arabic
**Last updated:** 2026-07-06
**Owner:** Product Lead + i18n Lead

## Overview

WalkTogether supports 9 languages: English, Hindi, Telugu, Tamil, Kannada, Bengali, Spanish, Arabic (RTL), and French. The Flutter i18n module is at `flutter_app/lib/core/i18n.dart`. The language preference persists across app restarts via `SharedPreferences`.

## Supported languages

| Code | Name | Native name | RTL | Completeness |
|---|---|---|---|---|
| en | English | English | No | 100% (fallback) |
| hi | Hindi | हिन्दी | No | Partial (safety-critical keys) |
| te | Telugu | తెలుగు | No | Partial (safety-critical keys) |
| ta | Tamil | தமிழ் | No | Partial (safety-critical keys) |
| kn | Kannada | ಕನ್ನಡ | No | Partial (safety-critical keys) |
| bn | Bengali | বাংলা | No | Partial (safety-critical keys) |
| es | Spanish | Español | No | Partial (safety-critical keys) |
| ar | Arabic | العربية | Yes | Partial (safety-critical keys) |
| fr | French | Français | No | Partial (safety-critical keys) |

**Completeness note:** V1.7 includes safety-critical + frequently-used keys for all 9 languages. Full UI translation (matching the 518-key web/PWA catalog) is planned for V1.8. The fallback chain (`lang → en → key`) ensures no crashes on missing keys.

## Translation keys (V1.7)

The following 12 safety-critical keys are translated in at least English + partially in all 9 languages:

| Key | English |
|---|---|
| `sos.title` | SOS |
| `sos.disclaimer` | WalkTogether is not an emergency service. Call local emergency number for life-threatening situations. |
| `sos.triggered` | SOS triggered. Your safety contacts have been notified. |
| `sos.failed` | Failed to trigger SOS. Please call local emergency number. |
| `report.title` | Report user |
| `block.title` | Block user |
| `appeal.title` | Appeal |
| `auth.banned` | Your account has been suspended. Tap to appeal. |
| `auth.suspended` | Your account is temporarily suspended. |
| `auth.deletion_pending` | Account deletion in progress. Cancel in Settings. |
| `privacy.download_data` | Download my data |
| `privacy.delete_account` | Delete my account |

Plus 8 common keys (`common.retry`, `common.cancel`, `common.confirm`, `common.loading`, `common.error`, `common.no_internet`, `common.offline`, `auth.welcome`).

## Language selection

### Settings screen

The Settings screen (`settings_screen.dart`) has a "Language" section with a `RadioListTile` for each supported language. The user's native name is shown as the title, and the English name as the subtitle.

### Persistence

When the user selects a language:

1. `AppI18n.setLanguage(code)` is called
2. `currentLanguageCode` is updated in memory
3. The code is saved to `SharedPreferences` with key `app_language`
4. `_instance.notifyListeners()` triggers a rebuild of the entire app
5. The language code is also sent to the backend via `updateMe({'language': code})` so the backend can localize push notifications + emails

On app restart, `AppI18n.init()` loads the saved language from `SharedPreferences` before the first paint.

## RTL support (Arabic)

### Directionality

`main.dart` wraps the entire `MaterialApp.router` in a `Directionality` widget:

```dart
builder: (context, child) {
  return Directionality(
    textDirection: appTextDirection(),
    child: child ?? const SizedBox.shrink(),
  );
},
```

`appTextDirection()` returns `TextDirection.rtl` when the current language is Arabic, `TextDirection.ltr` otherwise.

### What RTL affects

- **Text alignment:** all `Text` widgets render right-to-left
- **Icon layout:** leading/trailing icons swap positions in `ListTile`
- **Padding/margin:** directional padding (`EdgeInsetsDirectional`) respects RTL
- **Navigation:** back button points right instead of left
- **Bottom nav:** tabs are laid out right-to-left

### Known RTL limitations (V1.7)

1. **Chat message bubbles** — the chat screen uses `Align(alignment: Alignment.centerLeft)` for sent messages and `Alignment.centerRight` for received. In RTL, these should swap. Planned fix: V1.8 will use `AlignmentDirectional.centerStart` / `AlignmentDirectional.centerEnd`.

2. **Bottom navigation bar** — Material's `BottomNavigationBar` handles RTL automatically, but custom icons may need adjustment. Manual QA needed.

3. **OTP input field** — the 6-digit OTP input uses `textAlign: TextAlign.center` which works in both LTR and RTL. No change needed.

4. **Phone number input** — phone numbers are always LTR even in RTL contexts. The `TextField` for phone input should use `textDirection: TextDirection.ltr` explicitly. Planned fix: V1.8.

## QA checklist

### Per-language manual QA

For each of the 9 languages, verify:

- [ ] Language name displays correctly in Settings (native name)
- [ ] Selecting the language updates the UI immediately
- [ ] Language persists after app restart
- [ ] SOS disclaimer text is readable
- [ ] Auth error messages are readable
- [ ] Privacy screen labels are readable
- [ ] No text overflow (some languages have longer words)
- [ ] No missing-key crashes (fallback to English works)

### Arabic-specific RTL QA

- [ ] Text alignment is right-to-left
- [ ] Back button points right
- [ ] List items: leading icon is on the right
- [ ] Chat message bubbles are mirrored (planned V1.8)
- [ ] Phone number input is LTR (planned V1.8)
- [ ] OTP input is centered (works in both directions)
- [ ] Bottom nav tabs are right-to-left
- [ ] No layout overflow in RTL

### Safety-critical copy QA

For each language, verify the safety-critical keys are translated and culturally appropriate:

- [ ] `sos.title` — "SOS" is universally understood; keep as "SOS" in all languages
- [ ] `sos.disclaimer` — must clearly state that WalkTogether is NOT an emergency service
- [ ] `sos.triggered` — must confirm that safety contacts were notified
- [ ] `sos.failed` — must direct user to call local emergency number
- [ ] `report.title` — "Report user" equivalent
- [ ] `block.title` — "Block user" equivalent
- [ ] `appeal.title` — "Appeal" equivalent
- [ ] `auth.banned` — must mention appeal option
- [ ] `auth.suspended` — must indicate temporary status
- [ ] `auth.deletion_pending` — must mention cancellation option
- [ ] `privacy.download_data` — "Download my data" equivalent
- [ ] `privacy.delete_account` — "Delete my account" equivalent

### Invite copy QA

Invite link copy is generated server-side and sent via the backend. The mobile app displays invite text in push notifications + share sheet. Verify:

- [ ] Invite text is localized when the recipient's language is set
- [ ] Invite URL (`https://walktogether.app/i/CODE`) is not translated (always Latin characters)
- [ ] Invite copy does not contain paid/premium language

## No paid/premium language

The automated free-product compliance scan (check #6 in `static_verify.sh` + check #10 in `security_review.sh`) confirms no premium/subscription/paywall/in-app purchase/credit card/billing language exists in the i18n module.

This is verified per-language: the scan checks all `.dart` files including `i18n.dart`, and no translation key contains forbidden terms.

## Acceptance criteria

- [x] 9 languages defined in `lib/core/i18n.dart`
- [x] Language selection persists via SharedPreferences
- [x] Arabic RTL directionality applied via `Directionality` wrapper
- [x] 12 safety-critical keys translated in English + partially in all 9 languages
- [x] No missing-key crashes (fallback chain: lang → en → key)
- [x] No paid/premium language in any translation
- [ ] Full UI translation (518 keys) — planned for V1.8
- [ ] Chat message bubble RTL mirroring — planned for V1.8
- [ ] Phone number input LTR in RTL mode — planned for V1.8
