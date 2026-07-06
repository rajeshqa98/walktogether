// WalkTogether — Club Detail (join/leave)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class ClubDetailScreen extends ConsumerStatefulWidget {
  const ClubDetailScreen({super.key, required this.clubId});
  final String clubId;
  @override
  ConsumerState<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends ConsumerState<ClubDetailScreen> {
  Map<String, dynamic>? _club;
  bool _loading = true;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ref.read(apiClientProvider).getClub(widget.clubId);
      setState(() {
        _club = res['club'] ?? res;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _toggleJoin() async {
    setState(() => _actionLoading = true);
    try {
      if (_club?['hasJoined'] == true) {
        await ref.read(apiClientProvider).leaveClub(widget.clubId);
      } else {
        await ref.read(apiClientProvider).joinClub(widget.clubId);
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
      appBar: AppBar(title: const Text('Walking club')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _club == null
              ? const Center(child: Text('Not found'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(_club!['name'] ?? 'Club',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                        '${_club!['clubType']?.toString().replaceAll('_', ' ') ?? ''} • ${_club!['city'] ?? ''}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: WalkTogetherTheme.textSecondary)),
                    const SizedBox(height: 8),
                    Text('👥 ${_club!['memberCount'] ?? 0} members',
                        style: const TextStyle(fontSize: 12)),
                    if (_club!['description'] != null) ...[
                      const SizedBox(height: 16),
                      Text(_club!['description'],
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
                          : Text(_club!['hasJoined'] == true
                              ? 'Leave club'
                              : 'Join club'),
                    ),
                  ],
                ),
    );
  }
}
