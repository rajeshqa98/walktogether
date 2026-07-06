// WalkTogether — Group Walks List
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});
  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  List<dynamic> _walks = [];
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
      final res = await ref.read(apiClientProvider).listGroupWalks();
      setState(() {
        _walks = res['walks'] as List? ?? [];
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
      appBar: AppBar(
        title: const Text('Group walks'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push('/groups')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Text(_error!,
                        style:
                            const TextStyle(color: WalkTogetherTheme.danger)))
                : _walks.isEmpty
                    ? ListView(children: [
                        const SizedBox(height: 80),
                        Icon(Icons.groups,
                            size: 64, color: WalkTogetherTheme.textMuted),
                        const SizedBox(height: 16),
                        const Text('No group walks yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: WalkTogetherTheme.textSecondary)),
                        const SizedBox(height: 8),
                        const Text('Be the first to organize a group walk!',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: WalkTogetherTheme.textMuted)),
                      ])
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _walks.length,
                        itemBuilder: (ctx, i) {
                          final w = _walks[i] as Map<String, dynamic>;
                          return Card(
                            child: ListTile(
                              title: Text(w['title'] ?? 'Group walk',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${w['meetingPointName'] ?? 'TBD'} • ${w['currentParticipants'] ?? 0}/${w['maxParticipants'] ?? 10}',
                                  style: const TextStyle(fontSize: 11)),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.push('/group/${w['id']}'),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
