// WalkTogether — i18n module (9 languages, Arabic RTL)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final bool isRtl;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    this.isRtl = false,
  });

  static const List<AppLanguage> supported = [
    AppLanguage(code: 'en', name: 'English', nativeName: 'English'),
    AppLanguage(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    AppLanguage(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    AppLanguage(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    AppLanguage(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    AppLanguage(code: 'bn', name: 'Bengali', nativeName: 'বাংলা'),
    AppLanguage(code: 'es', name: 'Spanish', nativeName: 'Español'),
    AppLanguage(code: 'ar', name: 'Arabic', nativeName: 'العربية', isRtl: true),
    AppLanguage(code: 'fr', name: 'French', nativeName: 'Français'),
  ];

  static AppLanguage? fromCode(String code) {
    for (final lang in supported) {
      if (lang.code == code) return lang;
    }
    return null;
  }

  static const AppLanguage fallback = AppLanguage(
    code: 'en',
    name: 'English',
    nativeName: 'English',
  );
}

final Map<String, Map<String, String>> _translations = {
  'en': {
    'sos.title': 'SOS',
    'sos.disclaimer':
        'WalkTogether is not an emergency service. Call local emergency number.',
    'sos.triggered': 'SOS triggered. Safety contacts notified.',
    'sos.failed': 'Failed to trigger SOS. Call local emergency number.',
    'report.title': 'Report user',
    'block.title': 'Block user',
    'appeal.title': 'Appeal',
    'auth.welcome': 'Welcome to WalkTogether',
    'auth.send_otp': 'Send OTP',
    'auth.verify_otp': 'Verify & continue',
    'auth.banned': 'Your account has been suspended. Tap to appeal.',
    'auth.suspended': 'Your account is temporarily suspended.',
    'auth.deletion_pending':
        'Account deletion in progress. Cancel in Settings.',
    'privacy.download_data': 'Download my data',
    'privacy.delete_account': 'Delete my account',
    'common.loading': 'Loading…',
    'common.error': 'Something went wrong.',
    'common.no_internet': 'No internet connection.',
  },
  'hi': {
    'sos.title': 'SOS',
    'auth.welcome': 'वॉकटुगेदर में आपका स्वागत है',
    'auth.send_otp': 'OTP भेजें',
    'common.loading': 'लोड हो रहा है…',
  },
  'te': {
    'sos.title': 'SOS',
    'auth.welcome': 'వాక్‌టుగెదర్‌కి స్వాగతం',
    'common.loading': 'లోడ్ అవుతోంది…',
  },
  'ta': {
    'sos.title': 'SOS',
    'auth.welcome': 'வாக்டுகெதருக்கு வரவேற்கிறோம்',
    'common.loading': 'ஏற்றுகிறது…',
  },
  'kn': {
    'sos.title': 'SOS',
    'auth.welcome': 'ವಾಕ್‌ಟುಗೆದರ್‌ಗೆ ಸ್ವಾಗತ',
    'common.loading': 'ಲೋಡ್ ಆಗುತ್ತಿದೆ…',
  },
  'bn': {
    'sos.title': 'SOS',
    'auth.welcome': 'ওয়াকটুগেদার-এ স্বাগতম',
    'common.loading': 'লোড হচ্ছে…',
  },
  'es': {
    'sos.title': 'SOS',
    'auth.welcome': 'Bienvenido a WalkTogether',
    'common.loading': 'Cargando…',
  },
  'ar': {
    'sos.title': 'SOS',
    'sos.disclaimer': 'WalkTogether ليس خدمة طوارئ. اتصل برقم الطوارئ المحلي.',
    'auth.welcome': 'مرحباً بك في WalkTogether',
    'common.loading': 'جار التحميل…',
  },
  'fr': {
    'sos.title': 'SOS',
    'auth.welcome': 'Bienvenue sur WalkTogether',
    'common.loading': 'Chargement…',
  },
};

String t(String key, {Map<String, String>? params, String? langCode}) {
  final code = langCode ?? AppI18n.currentLanguageCode;
  final dict = _translations[code] ?? _translations['en']!;
  final enDict = _translations['en']!;
  var value = dict[key] ?? enDict[key] ?? key;
  if (params != null) {
    for (final entry in params.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
  }
  return value;
}

class AppI18n extends ChangeNotifier {
  AppI18n._();
  static final AppI18n _instance = AppI18n._();
  factory AppI18n() => _instance;

  static String currentLanguageCode = 'en';
  static const String _storageKey = 'app_language';

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved != null && AppLanguage.fromCode(saved) != null) {
        currentLanguageCode = saved;
      }
    } catch (_) {}
  }

  static Future<void> setLanguage(String code) async {
    if (AppLanguage.fromCode(code) == null) return;
    currentLanguageCode = code;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, code);
    } catch (_) {}
    _instance.notifyListeners();
  }

  static bool get isRtl {
    final lang = AppLanguage.fromCode(currentLanguageCode);
    return lang?.isRtl ?? false;
  }

  static AppLanguage get currentLanguage {
    return AppLanguage.fromCode(currentLanguageCode) ?? AppLanguage.fallback;
  }
}

TextDirection appTextDirection() {
  return AppI18n.isRtl ? TextDirection.rtl : TextDirection.ltr;
}
