// WalkTogether — Group Chat Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';

class GroupChatScreen extends ConsumerStatefulWidget {
  const GroupChatScreen({super.key, required this.groupWalkId});
  final String groupWalkId;
  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  Future<void> _send() async {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) return;
    _messageController.clear();
    setState(() {
      _messages.add({'message': msg, 'senderName': 'You', 'mine': true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group chat')),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline,
                            size: 48, color: WalkTogetherTheme.textMuted),
                        const SizedBox(height: 8),
                        const Text('No messages yet',
                            style:
                                TextStyle(color: WalkTogetherTheme.textMuted)),
                        const SizedBox(height: 4),
                        const Text('Be the first to say hello!',
                            style: TextStyle(
                                fontSize: 11,
                                color: WalkTogetherTheme.textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (ctx, i) {
                      final msg = _messages[i];
                      final mine = msg['mine'] == true;
                      return Align(
                        alignment:
                            mine ? Alignment.centerRight : Alignment.centerLeft,
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
                            borderRadius: BorderRadius.circular(12),
                            border: mine
                                ? null
                                : Border.all(color: WalkTogetherTheme.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!mine)
                                Text(msg['senderName'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: WalkTogetherTheme.primary)),
                              Text(msg['message'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: mine
                                          ? WalkTogetherTheme.onPrimary
                                          : WalkTogetherTheme.textPrimary)),
                            ],
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
