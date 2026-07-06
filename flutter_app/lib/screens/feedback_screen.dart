// WalkTogether — Feedback Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});
  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  String _category = 'general';
  int _rating = 5;
  final _messageController = TextEditingController();
  bool _submitting = false;

  Future<void> _submit() async {
    if (_messageController.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ref.read(apiClientProvider).submitFeedback(
            category: _category,
            rating: _rating,
            message: _messageController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Thank you! Your feedback helps us improve WalkTogether.')),
        );
        context.go('/home');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed. Try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Give feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('We want to hear from you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                'Report bugs, safety concerns, or suggest features. All feedback is anonymous unless you include your contact info.',
                style: TextStyle(
                    fontSize: 12, color: WalkTogetherTheme.textSecondary)),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'general', child: Text('General')),
                DropdownMenuItem(value: 'bug', child: Text('Bug report')),
                DropdownMenuItem(
                    value: 'safety_concern', child: Text('Safety concern')),
                DropdownMenuItem(
                    value: 'feature_request', child: Text('Feature request')),
              ],
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            const SizedBox(height: 16),
            const Text('Rating',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Row(
              children: List.generate(
                  5,
                  (i) => GestureDetector(
                        onTap: () => setState(() => _rating = i + 1),
                        child: Icon(Icons.star,
                            size: 32,
                            color: i < _rating
                                ? WalkTogetherTheme.safetyAmber
                                : WalkTogetherTheme.textMuted),
                      )),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your feedback',
                hintText: 'Tell us what\'s on your mind...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Submit feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
