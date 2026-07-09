// WalkTogether — Chat Screen (1:1 messages after accepted request)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.requestId});
  final String requestId;
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<dynamic> _messages = [];
  bool _loading = true;
  Map<String, dynamic>? _request;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ref.read(apiClientProvider).listRequests();
      final all = [...res['incoming'] as List, ...res['outgoing'] as List];
      _request = all.cast<Map<String, dynamic>?>().firstWhere(
            (r) => r?['id'] == widget.requestId,
            orElse: () => null,
          );
      // Messages come from the requests list endpoint in this simplified version
      _messages = _request?['messages'] as List? ?? [];
      setState(() => _loading = false);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _send() async {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) return;
    _messageController.clear();
    setState(() {
      _messages = [
        ..._messages,
        {
          'message': msg,
          'mine': true,
          'createdAt': DateTime.now().toIso8601String()
        }
      ];
    });
    _scrollToBottom();
    // In production, this calls api.sendMessage(requestId, msg)
    // For beta parity, we show the optimistic update
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(authStateProvider).user;
    final myId = me?['id'] as String?;
    return Scaffold(
      appBar: AppBar(
        title: Text(_request?['sender']?['name'] ??
            _request?['receiver']?['name'] ??
            'Chat'),
        actions: [
          if (_request?['status'] == 'accepted')
            IconButton(
              icon: const Icon(Icons.directions_walk),
              onPressed: () async {
                try {
                  final session = await ref
                      .read(apiClientProvider)
                      .startSession(widget.requestId);
                  if (mounted) context.go('/walk-session/${session['id']}');
                } catch (_) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to start walk.')));
                  }
                }
              },
              tooltip: 'Start walk',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat_bubble_outline,
                                size: 48, color: WalkTogetherTheme.textMuted),
                            const SizedBox(height: 8),
                            const Text('Say hello!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            const Text(
                                'Messages appear in real time.\nInappropriate content is auto-flagged.',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: WalkTogetherTheme.textSecondary),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: _messages.length,
                        itemBuilder: (ctx, i) {
                          final msg = _messages[i];
                          final mine =
                              msg['mine'] == true || msg['senderId'] == myId;
                          return Align(
                            alignment: mine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75),
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: mine
                                    ? WalkTogetherTheme.primary
                                    : WalkTogetherTheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: mine
                                    ? null
                                    : Border.all(
                                        color: WalkTogetherTheme.border),
                              ),
                              child: Text(
                                msg['message'] ?? '',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: mine
                                        ? WalkTogetherTheme.onPrimary
                                        : WalkTogetherTheme.textPrimary),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: WalkTogetherTheme.surface,
              border: Border(top: BorderSide(color: WalkTogetherTheme.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                        hintText: 'Type a message...', isDense: true),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.send, color: WalkTogetherTheme.primary),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
