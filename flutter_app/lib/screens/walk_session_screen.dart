// WalkTogether — Active Walk Session Screen (SOS + safety share + end walk)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../core/i18n.dart';
import '../providers/providers.dart';

class WalkSessionScreen extends ConsumerStatefulWidget {
  const WalkSessionScreen({super.key, required this.sessionId});
  final String sessionId;
  @override
  ConsumerState<WalkSessionScreen> createState() => _WalkSessionScreenState();
}

class _WalkSessionScreenState extends ConsumerState<WalkSessionScreen> {
  bool _loading = true;
  bool _safetyShareOn = false;
  bool _sosTriggered = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await ref.read(apiClientProvider).getSession(widget.sessionId);
      setState(() => _loading = false);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _triggerSos() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Icon(Icons.warning, color: WalkTogetherTheme.danger),
          const SizedBox(width: 8),
          const Text('Trigger SOS?')
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('sos.disclaimer'), style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            const Text(
                'SOS will alert your safety contacts and the WalkTogether safety team. It does NOT call emergency services.',
                style:
                    TextStyle(fontSize: 12, color: WalkTogetherTheme.danger)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: WalkTogetherTheme.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Trigger SOS'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(apiClientProvider).triggerSos(widget.sessionId);
      setState(() => _sosTriggered = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(t('sos.triggered')),
              backgroundColor: WalkTogetherTheme.danger),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t('sos.failed'))));
      }
    }
  }

  Future<void> _toggleSafetyShare() async {
    try {
      await ref
          .read(apiClientProvider)
          .setSafetyShare(widget.sessionId, !_safetyShareOn);
      setState(() => _safetyShareOn = !_safetyShareOn);
    } catch (_) {}
  }

  Future<void> _endWalk() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End walk?'),
        content: const Text(
            'This will end your active walk session. You can rate your experience afterwards.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('End walk')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(apiClientProvider).endSession(widget.sessionId);
      if (mounted) context.go('/post-walk/${widget.sessionId}');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to end walk.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active walk'),
        automaticallyImplyLeading: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Icon(Icons.directions_walk,
                      size: 80, color: WalkTogetherTheme.safetyGreen),
                  const SizedBox(height: 16),
                  const Text('Walk in progress',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      'Stay safe. Meet in public places. Trust your instincts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: WalkTogetherTheme.textSecondary)),
                  const Spacer(),
                  // Safety share toggle
                  Card(
                    child: SwitchListTile(
                      title: const Text('Safety share',
                          style: TextStyle(fontSize: 14)),
                      subtitle: const Text(
                          'Share live status with your safety contact',
                          style: TextStyle(fontSize: 11)),
                      value: _safetyShareOn,
                      onChanged: (_) => _toggleSafetyShare(),
                      secondary: Icon(Icons.share_location,
                          color: WalkTogetherTheme.safetyGreen),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // SOS button
                  if (_sosTriggered)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: WalkTogetherTheme.danger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: WalkTogetherTheme.danger),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.warning,
                              color: WalkTogetherTheme.danger, size: 32),
                          const SizedBox(height: 8),
                          Text('SOS triggered',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: WalkTogetherTheme.danger)),
                          const SizedBox(height: 4),
                          const Text('Safety team has been notified.',
                              style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _triggerSos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WalkTogetherTheme.danger,
                        minimumSize: const Size.fromHeight(56),
                      ),
                      icon: const Icon(Icons.sos, size: 28),
                      label: const Text('SOS',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  const SizedBox(height: 8),
                  Text(t('sos.disclaimer'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, color: WalkTogetherTheme.textMuted)),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: _endWalk,
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48)),
                    child: const Text('End walk'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
