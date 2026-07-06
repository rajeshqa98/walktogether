// WalkTogether — Profile Setup Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  String _ageRange = '25-34';
  String _gender = 'female';
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ref.read(apiClientProvider).updateMe({
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'ageRange': _ageRange,
        'gender': _gender,
        'isNewUser': false,
      });
      await ref.read(authStateProvider.notifier).refreshUser();
      if (mounted) context.go('/home');
    } catch (_) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Set up your profile'),
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Tell us about yourself',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  'This information helps us find safe walking partners nearby.',
                  style: TextStyle(
                      fontSize: 12, color: WalkTogetherTheme.textSecondary)),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Name', prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _ageRange,
                decoration: const InputDecoration(labelText: 'Age range'),
                items: const [
                  DropdownMenuItem(value: '18-24', child: Text('18-24')),
                  DropdownMenuItem(value: '25-34', child: Text('25-34')),
                  DropdownMenuItem(value: '35-44', child: Text('35-44')),
                  DropdownMenuItem(value: '45-54', child: Text('45-54')),
                  DropdownMenuItem(value: '55+', child: Text('55+')),
                ],
                onChanged: (v) => setState(() => _ageRange = v ?? _ageRange),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(
                      value: 'nonbinary', child: Text('Non-binary')),
                ],
                onChanged: (v) => setState(() => _gender = v ?? _gender),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Bio (optional)',
                    hintText: 'Tell other walkers about yourself'),
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
                    : const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
