// WalkTogether — Walker Detail + Send Walk Request
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class WalkerDetailScreen extends ConsumerStatefulWidget {
  const WalkerDetailScreen({super.key, required this.walkerId});
  final String walkerId;
  @override
  ConsumerState<WalkerDetailScreen> createState() => _WalkerDetailScreenState();
}

class _WalkerDetailScreenState extends ConsumerState<WalkerDetailScreen> {
  Map<String, dynamic>? _walker;
  bool _loading = true;
  bool _sending = false;
  String? _error;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final walkers = await ref.read(apiClientProvider).listNearbyWalkers();
      final found = walkers.cast<Map<String, dynamic>?>().firstWhere(
            (w) => w?['id'] == widget.walkerId,
            orElse: () => null,
          );
      setState(() {
        _walker = found;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _sendRequest() async {
    if (_sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(apiClientProvider).sendRequest({
        'receiverId': widget.walkerId,
        'message': _messageController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Walk request sent! You\'ll be notified when they respond.')),
        );
        context.go('/home');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _sending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send request. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Walker profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(_error!,
                      style: const TextStyle(color: WalkTogetherTheme.danger)))
              : _walker == null
                  ? const Center(child: Text('Walker not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 48,
                              child: Text(
                                ((_walker!['name'] as String?) ?? '?')[0]
                                    .toUpperCase(),
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_walker!['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                if (_walker!['verificationStatus'] ==
                                    'verified') ...[
                                  const SizedBox(width: 4),
                                  const VerifiedBadge(size: 16),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              '${_walker!['distance'] ?? '?'}m away • Trust: ${_walker!['trustScore'] ?? 50}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: WalkTogetherTheme.textSecondary),
                            ),
                          ),
                          if (_walker!['bio'] != null) ...[
                            const SizedBox(height: 16),
                            Text(_walker!['bio'],
                                style: const TextStyle(fontSize: 14)),
                          ],
                          const SizedBox(height: 24),
                          const Text('Send a walk request',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _messageController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText:
                                  'Say hello! Suggest a time or meeting point...',
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Safety tip: Always meet in a public, well-lit place for the first walk.',
                            style: TextStyle(
                                fontSize: 10,
                                color: WalkTogetherTheme.safetyAmber),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _sending ? null : _sendRequest,
                            child: _sending
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                : const Text('Send walk request'),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
