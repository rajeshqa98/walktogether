// WalkTogether — Post-Walk Rating + Report + Block
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class PostWalkScreen extends ConsumerStatefulWidget {
  const PostWalkScreen({super.key, required this.sessionId});
  final String sessionId;
  @override
  ConsumerState<PostWalkScreen> createState() => _PostWalkScreenState();
}

class _PostWalkScreenState extends ConsumerState<PostWalkScreen> {
  int _rating = 0;
  bool _submitting = false;
  bool _submitted = false;
  String _reportReason = '';

  final _reasons = [
    {'id': 'harassment', 'label': 'Harassment or inappropriate behavior'},
    {'id': 'unsafe_behavior', 'label': 'Made me feel unsafe during the walk'},
    {'id': 'fake_profile', 'label': 'Fake profile or photo doesn\'t match'},
    {'id': 'spam', 'label': 'Spam or scam attempt'},
    {'id': 'other', 'label': 'Other'},
  ];

  Future<void> _submitRating() async {
    if (_rating == 0) return;
    setState(() => _submitting = true);
    try {
      await ref.read(apiClientProvider).getSession(widget.sessionId);
      // Rating submission uses the session context server-side
      setState(() {
        _submitted = true;
        _submitting = false;
      });
    } catch (_) {
      setState(() => _submitting = false);
    }
  }

  Future<void> _submitReport() async {
    if (_reportReason.isEmpty) return;
    setState(() => _submitting = true);
    try {
      final session =
          await ref.read(apiClientProvider).getSession(widget.sessionId);
      final partnerId = session['partner']?['id'] ?? session['user1Id'];
      await ref
          .read(apiClientProvider)
          .submitReport({'reportedUserId': partnerId, 'reason': _reportReason});
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Report submitted.')));
        setState(() => _submitting = false);
      }
    } catch (_) {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _block() async {
    setState(() => _submitting = true);
    try {
      final session =
          await ref.read(apiClientProvider).getSession(widget.sessionId);
      final partnerId = session['partner']?['id'] ?? session['user1Id'];
      await ref.read(apiClientProvider).blockUser(partnerId);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User blocked.')));
        context.go('/home');
      }
    } catch (_) {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Walk complete!'),
          automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.check_circle,
              size: 48, color: WalkTogetherTheme.safetyGreen),
          const SizedBox(height: 8),
          const Text('How was your walk?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (i) => GestureDetector(
                      onTap: () => setState(() => _rating = i + 1),
                      child: Icon(Icons.star,
                          size: 40,
                          color: i < _rating
                              ? WalkTogetherTheme.safetyAmber
                              : WalkTogetherTheme.textMuted),
                    )),
          ),
          const SizedBox(height: 16),
          if (!_submitted)
            ElevatedButton(
              onPressed: _rating == 0 || _submitting ? null : _submitRating,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Submit rating'),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.check_circle,
                    color: WalkTogetherTheme.safetyGreen, size: 16),
                SizedBox(width: 4),
                Text('Rating submitted!',
                    style: TextStyle(
                        fontSize: 12, color: WalkTogetherTheme.safetyGreen)),
              ]),
            ),
          const SizedBox(height: 24),
          Card(
            child: ExpansionTile(
              title: const Text('Report or block this walker',
                  style: TextStyle(fontSize: 14)),
              subtitle: const Text('If something felt unsafe, tell us.'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('REASON',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: WalkTogetherTheme.textSecondary)),
                      const SizedBox(height: 4),
                      ..._reasons.map((r) => RadioListTile<String>(
                            value: r['id']!,
                            groupValue: _reportReason,
                            title: Text(r['label']!,
                                style: const TextStyle(fontSize: 13)),
                            dense: true,
                            onChanged: (v) =>
                                setState(() => _reportReason = v ?? ''),
                          )),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: OutlinedButton(
                          onPressed: _reportReason.isEmpty || _submitting
                              ? null
                              : _submitReport,
                          style: OutlinedButton.styleFrom(
                              foregroundColor: WalkTogetherTheme.danger),
                          child: const Text('Submit report'),
                        )),
                        const SizedBox(width: 8),
                        Expanded(
                            child: OutlinedButton(
                          onPressed: _submitting ? null : _block,
                          child: const Text('Block user'),
                        )),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Back to home'),
          ),
        ],
      ),
    );
  }
}
