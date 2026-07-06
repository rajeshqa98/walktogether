// WalkTogether — Theme
import 'package:flutter/material.dart';

class WalkTogetherTheme {
  static const Color primary = Color(0xFFEA580C);
  static const Color primaryLight = Color(0xFFF97316);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF0D9488);
  static const Color safetyGreen = Color(0xFF059669);
  static const Color safetyAmber = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE7E5E4);
  static const Color textPrimary = Color(0xFF1C1917);
  static const Color textSecondary = Color(0xFF78716C);
  static const Color textMuted = Color(0xFFA8A29E);
  static const Color verifiedBlue = Color(0xFF0D9488);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: accent,
          surface: surface,
          error: danger,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          foregroundColor: textPrimary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: onPrimary,
            minimumSize: const Size.fromHeight(48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );
}

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.size = 12});
  final double size;
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.verified,
        size: size, color: WalkTogetherTheme.verifiedBlue);
  }
}
