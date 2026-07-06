// WalkTogether — Appeals Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class AppealsScreen extends ConsumerStatefulWidget {
  const AppealsScreen({super.key});
  @override
  ConsumerState<AppealsScreen> createState() => _AppealsScreenState();
}

class _AppealsScreenState extends ConsumerState<AppealsScreen> {
  List<dynamic> _appeals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final appeals = await ref.read(apiClientProvider).listMyAppeals();
      setState(() {
        _appeals = appeals;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appeals'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showCreateDialog(context)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _appeals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.gavel,
                          size: 48, color: WalkTogetherTheme.textMuted),
                      const SizedBox(height: 8),
                      const Text('No appeals yet',
                          style: TextStyle(color: WalkTogetherTheme.textMuted)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _showCreateDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Submit an appeal'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _appeals.length,
                  itemBuilder: (context, i) {
                    final a = _appeals[i] as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        leading:
                            _statusIcon(a['status'] as String? ?? 'submitted'),
                        title: Text(a['actionType'] ?? 'unknown',
                            style: const TextStyle(fontSize: 14)),
                        subtitle: Text('Status: ${a['status'] ?? 'unknown'}',
                            style: const TextStyle(fontSize: 11)),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _statusIcon(String status) {
    if (status == 'approved')
      return const Icon(Icons.check_circle,
          color: WalkTogetherTheme.safetyGreen);
    if (status == 'rejected')
      return const Icon(Icons.cancel, color: WalkTogetherTheme.danger);
    return const Icon(Icons.pending, color: WalkTogetherTheme.textMuted);
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    String actionType = 'account_suspension';
    final reasonController = TextEditingController();
    final explanationController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Submit an appeal'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                DropdownButtonFormField<String>(
                  value: actionType,
                  decoration: const InputDecoration(
                      labelText: 'What are you appealing?'),
                  items: const [
                    DropdownMenuItem(
                        value: 'account_suspension',
                        child: Text('Account suspension')),
                    DropdownMenuItem(
                        value: 'account_ban', child: Text('Account ban')),
                    DropdownMenuItem(
                        value: 'trust_score_review',
                        child: Text('Trust score review')),
                    DropdownMenuItem(
                        value: 'message_moderation',
                        child: Text('Message moderation')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => actionType = v);
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  decoration:
                      const InputDecoration(labelText: 'Reason (brief)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: explanationController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Explanation'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Submit')),
          ],
        ),
      ),
    );

    if (result != true) return;
    try {
      await ref.read(apiClientProvider).createAppeal(
            actionType: actionType,
            reason: reasonController.text.trim(),
            explanation: explanationController.text.trim(),
          );
      _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Appeal submitted.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed.')));
    }
  }
}
