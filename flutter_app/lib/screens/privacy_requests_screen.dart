// WalkTogether — Privacy Requests Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class PrivacyRequestsScreen extends ConsumerStatefulWidget {
  const PrivacyRequestsScreen({super.key});
  @override
  ConsumerState<PrivacyRequestsScreen> createState() =>
      _PrivacyRequestsScreenState();
}

class _PrivacyRequestsScreenState extends ConsumerState<PrivacyRequestsScreen> {
  List<dynamic> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final reqs = await ref.read(apiClientProvider).listMyPrivacyRequests();
      setState(() {
        _requests = reqs;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy requests')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Quick actions'),
          Card(
              child: Column(children: [
            ListTile(
              leading:
                  const Icon(Icons.download, color: WalkTogetherTheme.primary),
              title: const Text('Download my data'),
              subtitle: const Text('Export your data as JSON (instant).'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preparing export…')));
                try {
                  final data = await ref.read(apiClientProvider).exportMyData();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Export ready: ${data.length} fields.')));
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export failed.')));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: WalkTogetherTheme.danger),
              title: const Text('Delete my account'),
              subtitle: const Text('Start 14-day grace period.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete my account'),
                    content: const Text(
                        'Start 14-day grace period? You can cancel any time.'),
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
                    .startDeletion(reason: 'User initiated');
                if (!mounted) return;
                if (ok) {
                  await ref.read(authStateProvider.notifier).refreshUser();
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Failed.')));
                }
              },
            ),
          ])),
          const SizedBox(height: 16),
          _section('Submit a privacy request'),
          Card(
              child: Column(children: [
            ListTile(
              leading: const Icon(Icons.edit, size: 20),
              title: const Text('Data correction'),
              subtitle: const Text('Update profile data',
                  style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right, size: 16),
              onTap: () => _submit(context, 'data_correction'),
            ),
            ListTile(
              leading: const Icon(Icons.location_off, size: 20),
              title: const Text('Location data cleanup'),
              subtitle: const Text('Remove location data',
                  style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right, size: 16),
              onTap: () => _submit(context, 'location_data_cleanup'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off, size: 20),
              title: const Text('Push token removal'),
              subtitle: const Text('Remove push tokens',
                  style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right, size: 16),
              onTap: () => _submit(context, 'push_token_removal'),
            ),
          ])),
          const SizedBox(height: 16),
          _section('Your privacy requests'),
          if (_loading)
            const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()))
          else if (_requests.isEmpty)
            const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No privacy requests yet.',
                    style: TextStyle(color: WalkTogetherTheme.textMuted),
                    textAlign: TextAlign.center))
          else
            Card(
                child: Column(
              children: _requests
                  .map((r) => ListTile(
                        title: Text(r['requestType'] ?? 'unknown',
                            style: const TextStyle(fontSize: 14)),
                        subtitle: Text('Status: ${r['status'] ?? 'unknown'}',
                            style: const TextStyle(fontSize: 11)),
                      ))
                  .toList(),
            )),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context, String type) async {
    try {
      await ref.read(apiClientProvider).createPrivacyRequest(requestType: type);
      _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Request submitted.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed.')));
    }
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
