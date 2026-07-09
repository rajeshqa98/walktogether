// WalkTogether — Splash Screen
import 'package:flutter/material.dart';
import '../core/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: WalkTogetherTheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.directions_walk,
                  color: WalkTogetherTheme.onPrimary, size: 36),
            ),
            const SizedBox(height: 16),
            const Text('WalkTogether',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('100% free • safety-first • community-first',
                style: TextStyle(
                    fontSize: 11, color: WalkTogetherTheme.textMuted)),
            const SizedBox(height: 24),
            const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
      ),
    );
  }
}
