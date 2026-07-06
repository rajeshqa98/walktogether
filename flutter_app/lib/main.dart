// WalkTogether — Main App Entry Point
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/i18n.dart';
import 'providers/providers.dart';
import 'providers/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppI18n.init();
  runApp(const ProviderScope(child: WalkTogetherApp()));
}

class WalkTogetherApp extends ConsumerStatefulWidget {
  const WalkTogetherApp({super.key});
  @override
  ConsumerState<WalkTogetherApp> createState() => _WalkTogetherAppState();
}

class _WalkTogetherAppState extends ConsumerState<WalkTogetherApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authStateProvider.notifier).checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return AnimatedBuilder(
      animation: AppI18n(),
      builder: (context, _) {
        return MaterialApp.router(
          title: 'WalkTogether',
          debugShowCheckedModeBanner: false,
          theme: WalkTogetherTheme.lightTheme,
          routerConfig: router,
          builder: (context, child) {
            return Directionality(
              textDirection: appTextDirection(),
              child: child ?? const SizedBox.shrink(),
            );
          },
          locale: Locale(AppI18n.currentLanguageCode),
        );
      },
    );
  }
}
