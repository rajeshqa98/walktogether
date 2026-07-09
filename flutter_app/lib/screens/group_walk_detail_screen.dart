// WalkTogether — Group Walk Detail (join/leave + chat)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class GroupWalkDetailScreen extends ConsumerStatefulWidget {
  const GroupWalkDetailScreen({super.key, required this.groupWalkId});
  final String groupWalkId;
  @override
  ConsumerState<GroupWalkDetailScreen> createState() =>
      _GroupWalkDetailScreenState();
}

class _GroupWalkDetailScreenState extends ConsumerState<GroupWalkDetailScreen> {
  Map<String, dynamic>? _walk;
  bool _loading = true;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res =
          await ref.read(apiClientProvider).getGroupWalk(widget.groupWalkId);
      setState(() {
        _walk = res['walk'] ?? res;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _toggleJoin() async {
    setState(() => _actionLoading = true);
    try {
      if (_walk?['hasJoined'] == true) {
        await ref.read(apiClientProvider).leaveGroupWalk(widget.groupWalkId);
      } else {
        await ref.read(apiClientProvider).joinGroupWalk(widget.groupWalkId);
      }
      _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed.')));
      }
    }
    setState(() => _actionLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group walk')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _walk == null
              ? const Center(child: Text('Not found'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(_walk!['title'] ?? 'Group walk',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                        '📍 ${_walk!['meetingPointName'] ?? 'TBD'} • ${_walk!['neighborhood'] ?? _walk!['city'] ?? ''}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: WalkTogetherTheme.textSecondary)),
                    const SizedBox(height: 8),
                    Text(
                        '👥 ${_walk!['currentParticipants'] ?? 0}/${_walk!['maxParticipants'] ?? 10} joined',
                        style: const TextStyle(fontSize: 12)),
                    if (_walk!['description'] != null) ...[
                      const SizedBox(height: 16),
                      Text(_walk!['description'],
                          style: const TextStyle(fontSize: 14)),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _actionLoading ? null : _toggleJoin,
                      child: _actionLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(_walk!['hasJoined'] == true
                              ? 'Leave walk'
                              : 'Join walk'),
                    ),
                    if (_walk!['hasJoined'] == true) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.push('/group-chat/${widget.groupWalkId}'),
                        icon: const Icon(Icons.chat),
                        label: const Text('Group chat'),
                      ),
                    ],
                  ],
                ),
    );
  }
}
