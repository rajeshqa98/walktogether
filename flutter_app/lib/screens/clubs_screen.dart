// WalkTogether — Clubs List
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class ClubsScreen extends ConsumerStatefulWidget {
  const ClubsScreen({super.key});
  @override
  ConsumerState<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends ConsumerState<ClubsScreen> {
  List<dynamic> _clubs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ref.read(apiClientProvider).listClubs();
      setState(() {
        _clubs = res['clubs'] as List? ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Walking clubs')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Text(_error!,
                        style:
                            const TextStyle(color: WalkTogetherTheme.danger)))
                : _clubs.isEmpty
                    ? ListView(children: [
                        const SizedBox(height: 80),
                        Icon(Icons.groups,
                            size: 64, color: WalkTogetherTheme.textMuted),
                        const SizedBox(height: 16),
                        const Text('No clubs yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: WalkTogetherTheme.textSecondary)),
                      ])
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _clubs.length,
                        itemBuilder: (ctx, i) {
                          final c = _clubs[i] as Map<String, dynamic>;
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                  child: Text(
                                      (c['name'] ?? '?')[0].toUpperCase())),
                              title: Text(c['name'] ?? 'Club',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${c['city'] ?? ''} • ${c['memberCount'] ?? 0} members',
                                  style: const TextStyle(fontSize: 11)),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.push('/club/${c['id']}'),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
