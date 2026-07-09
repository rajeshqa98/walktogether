// WalkTogether — Account Status Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../core/i18n.dart';
import '../core/config.dart';
import '../providers/providers.dart';

class AccountStatusScreen extends ConsumerStatefulWidget {
  const AccountStatusScreen({super.key});
  @override
  ConsumerState<AccountStatusScreen> createState() =>
      _AccountStatusScreenState();
}

class _AccountStatusScreenState extends ConsumerState<AccountStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deletionStatusProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final gate = auth.gate;
    final user = auth.user;
    final deletionState = ref.watch(deletionStatusProvider);

    String title;
    String message;
    IconData icon;
    Color iconColor;

    if (gate == AccountGate.banned) {
      title = t('auth.banned');
      message = 'Your account has been banned. You can submit an appeal.';
      icon = Icons.block;
      iconColor = WalkTogetherTheme.danger;
    } else if (gate == AccountGate.suspended) {
      title = t('auth.suspended');
      message =
          'Your account is temporarily suspended. You can submit an appeal.';
      icon = Icons.pause_circle;
      iconColor = WalkTogetherTheme.safetyAmber;
    } else if (gate == AccountGate.deletionPending ||
        deletionState.deletionRequest != null) {
      title = t('auth.deletion_pending');
      message =
          'Account deletion is in progress. You can cancel any time before the grace period ends.';
      icon = Icons.delete_forever;
      iconColor = WalkTogetherTheme.danger;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/home');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('Account status'),
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(icon, size: 80, color: iconColor),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              if (user?['statusReason'] != null &&
                  (user!['statusReason'] as String).isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: WalkTogetherTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: WalkTogetherTheme.border),
                  ),
                  child: Text('Reason: ${user['statusReason']}',
                      style: const TextStyle(
                          fontSize: 12, color: WalkTogetherTheme.textSecondary),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 16),
              ],
              if (gate == AccountGate.banned ||
                  gate == AccountGate.suspended) ...[
                ElevatedButton.icon(
                  onPressed: () => context.push('/appeals'),
                  icon: const Icon(Icons.gavel),
                  label: const Text('Submit an appeal'),
                ),
                const SizedBox(height: 12),
              ],
              if (gate == AccountGate.deletionPending ||
                  deletionState.deletionRequest != null) ...[
                ElevatedButton.icon(
                  onPressed: () async {
                    final ok = await ref
                        .read(deletionStatusProvider.notifier)
                        .cancelDeletion();
                    if (mounted) {
                      if (ok) {
                        await ref
                            .read(authStateProvider.notifier)
                            .refreshUser();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to cancel deletion.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.undo),
                  label: const Text('Cancel deletion'),
                ),
                const SizedBox(height: 12),
              ],
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).logout();
                  if (mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email: ${AppConfig.supportEmail}')),
                ),
                child: Text('Contact support: ${AppConfig.supportEmail}',
                    style: const TextStyle(fontSize: 11)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
