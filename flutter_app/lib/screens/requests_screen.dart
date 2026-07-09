// WalkTogether — Requests Inbox (incoming + outgoing walk requests)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});
  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  List<dynamic> _incoming = [];
  List<dynamic> _outgoing = [];
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
      final res = await ref.read(apiClientProvider).listRequests();
      setState(() {
        _incoming = res['incoming'] as List? ?? [];
        _outgoing = res['outgoing'] as List? ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _respond(String id, String status) async {
    try {
      await ref.read(apiClientProvider).respondToRequest(id, status);
      _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Walk requests'),
          bottom: const TabBar(
              tabs: [Tab(text: 'Incoming'), Tab(text: 'Outgoing')]),
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
                  : TabBarView(
                      children: [
                        _buildList(_incoming, isIncoming: true),
                        _buildList(_outgoing, isIncoming: false),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> requests, {required bool isIncoming}) {
    if (requests.isEmpty) {
      return ListView(children: [
        const SizedBox(height: 80),
        Icon(Icons.inbox, size: 64, color: WalkTogetherTheme.textMuted),
        const SizedBox(height: 16),
        Text(isIncoming ? 'No incoming requests' : 'No outgoing requests',
            style: TextStyle(color: WalkTogetherTheme.textSecondary),
            textAlign: TextAlign.center),
      ]);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (ctx, i) {
        final r = requests[i] as Map<String, dynamic>;
        final status = r['status'] as String? ?? 'pending';
        final otherUser = r['sender'] ?? r['receiver'] ?? {};
        return Card(
          child: ListTile(
            leading: CircleAvatar(
                child: Text((otherUser['name'] ?? '?')[0].toUpperCase())),
            title: Text(otherUser['name'] ?? 'Unknown',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text('Status: ${status.replaceAll('_', ' ')}',
                style: const TextStyle(fontSize: 11)),
            trailing: isIncoming && status == 'pending'
                ? Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        icon: const Icon(Icons.check,
                            color: WalkTogetherTheme.safetyGreen),
                        onPressed: () => _respond(r['id'], 'accepted')),
                    IconButton(
                        icon: const Icon(Icons.close,
                            color: WalkTogetherTheme.danger),
                        onPressed: () => _respond(r['id'], 'declined')),
                  ])
                : status == 'accepted'
                    ? IconButton(
                        icon: const Icon(Icons.chat),
                        onPressed: () => context.push('/chat/${r['id']}'))
                    : null,
          ),
        );
      },
    );
  }
}
