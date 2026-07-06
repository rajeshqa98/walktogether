// WalkTogether — Settings Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../core/config.dart';
import '../core/i18n.dart';
import '../providers/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _hideMe = false;
  String _languageCode = 'en';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final user = ref.read(authStateProvider).user;
    setState(() {
      _hideMe = user?['hideMe'] == true;
      _languageCode = user?['language'] as String? ?? 'en';
    });
  }

  Future<void> _toggleHideMe(bool value) async {
    setState(() => _hideMe = value);
    try {
      await ref.read(apiClientProvider).updateMe({'hideMe': value});
      await ref.read(authStateProvider.notifier).refreshUser();
    } catch (_) {
      setState(() => _hideMe = !value);
    }
  }

  Future<void> _changeLanguage(String code) async {
    setState(() => _languageCode = code);
    await AppI18n.setLanguage(code);
    try {
      await ref.read(apiClientProvider).updateMe({'language': code});
      await ref.read(authStateProvider.notifier).refreshUser();
    } catch (_) {}
  }

  Future<void> _downloadData() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Preparing export…')));
    try {
      final data = await ref.read(apiClientProvider).exportMyData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export ready: ${data.length} fields.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Export failed.')));
    }
  }

  Future<void> _startDeletion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete my account'),
        content: const Text(
          'This starts a 14-day grace period. You will be hidden from nearby results. '
          'After 14 days, your personal data will be anonymized. Cancel any time.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: WalkTogetherTheme.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Start deletion'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await ref
        .read(deletionStatusProvider.notifier)
        .startDeletion(reason: 'User initiated from settings');
    if (!mounted) return;
    if (ok) {
      await ref.read(authStateProvider.notifier).refreshUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to start deletion.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Trust & verification'),
          Card(
              child: ListTile(
            leading: Icon(Icons.verified,
                color: user?['verificationStatus'] == 'verified'
                    ? WalkTogetherTheme.verifiedBlue
                    : WalkTogetherTheme.safetyAmber),
            title: Text(user?['verificationStatus'] == 'verified'
                ? 'Verified'
                : 'Not verified yet'),
          )),
          const SizedBox(height: 16),
          _section('Language'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: AppLanguage.supported
                    .map((lang) => RadioListTile<String>(
                          value: lang.code,
                          groupValue: _languageCode,
                          title: Text(lang.nativeName),
                          subtitle: Text(lang.name,
                              style: const TextStyle(fontSize: 11)),
                          onChanged: (v) {
                            if (v != null) _changeLanguage(v);
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _section('Privacy & visibility'),
          Card(
              child: SwitchListTile(
            title: const Text('Hide me from nearby',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text('Stop appearing in other walkers\' lists',
                style: TextStyle(fontSize: 11)),
            value: _hideMe,
            onChanged: _toggleHideMe,
          )),
          const SizedBox(height: 16),
          _section('Your data & rights'),
          Card(
              child: Column(children: [
            ListTile(
              leading: const Icon(Icons.download, size: 18),
              title: const Text('Download my data',
                  style: TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.chevron_right, size: 16),
              onTap: _downloadData,
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, size: 18),
              title: const Text('Privacy requests',
                  style: TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.chevron_right, size: 16),
              onTap: () => context.push('/privacy-requests'),
            ),
            ListTile(
              leading: const Icon(Icons.gavel, size: 18),
              title: const Text('My appeals', style: TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.chevron_right, size: 16),
              onTap: () => context.push('/appeals'),
            ),
          ])),
          const SizedBox(height: 16),
          _section('Account'),
          Card(
              child: Column(children: [
            ListTile(
              leading: const Icon(Icons.logout, size: 18),
              title: const Text('Log out', style: TextStyle(fontSize: 14)),
              onTap: () async {
                await ref.read(authStateProvider.notifier).logout();
                if (mounted) context.go('/login');
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.delete, size: 18, color: WalkTogetherTheme.danger),
              title: Text('Delete my account',
                  style:
                      TextStyle(fontSize: 14, color: WalkTogetherTheme.danger)),
              subtitle: const Text('Start 14-day grace period',
                  style: TextStyle(fontSize: 11)),
              onTap: _startDeletion,
            ),
          ])),
          const SizedBox(height: 24),
          Text(
              'WalkTogether v${AppConfig.version} (${AppConfig.buildNumber})\n100% free • safety-first • community-first',
              style: const TextStyle(
                  fontSize: 10, color: WalkTogetherTheme.textMuted),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(title.toUpperCase(),
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: WalkTogetherTheme.textSecondary,
                letterSpacing: 1)),
      );
}
