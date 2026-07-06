// WalkTogether — Notifications Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});
  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ref.read(apiClientProvider).listNotifications();
      setState(() {
        _notifications = res['notifications'] as List? ?? [];
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none,
                          size: 48, color: WalkTogetherTheme.textMuted),
                      const SizedBox(height: 8),
                      const Text('No notifications',
                          style: TextStyle(color: WalkTogetherTheme.textMuted)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _notifications.length,
                  itemBuilder: (ctx, i) {
                    final n = _notifications[i] as Map<String, dynamic>;
                    final isUnread = n['readAt'] == null;
                    return Card(
                      color: isUnread
                          ? WalkTogetherTheme.primary.withOpacity(0.05)
                          : null,
                      child: ListTile(
                        leading: Icon(Icons.circle,
                            size: 8,
                            color: isUnread
                                ? WalkTogetherTheme.primary
                                : WalkTogetherTheme.textMuted),
                        title: Text(n['title'] ?? '',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        subtitle: Text(n['body'] ?? '',
                            style: const TextStyle(fontSize: 11)),
                      ),
                    );
                  },
                ),
    );
  }
}
