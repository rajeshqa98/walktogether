// WalkTogether — Login Screen (OTP)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../core/config.dart';
import '../core/i18n.dart';
import '../providers/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  int _step = 0;
  bool _isLoading = false;
  String? _error;
  String? _devCode;
  int _cooldown = 0;
  Timer? _cooldownTimer;
  String _normalizedPhone = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown(int seconds) {
    _cooldown = seconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _cooldown--;
        if (_cooldown <= 0) t.cancel();
      });
    });
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _error = 'Please enter your phone number');
      return;
    }
    _normalizedPhone = phone.startsWith('+') ? phone : '+$phone';

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      final res = await api.requestOtp(_normalizedPhone);
      setState(() {
        _isLoading = false;
        _step = 1;
        _devCode = res['devCode'];
        _startCooldown((res['resendCooldownMs'] as int? ?? 30000) ~/ 1000);
      });
    } catch (e) {
      String msg = 'Failed to send OTP';
      if (e.toString().contains('cooldown') ||
          e.toString().contains('rate_limited')) {
        msg = 'Too many OTP requests. Please wait.';
      }
      setState(() {
        _isLoading = false;
        _error = msg;
      });
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.length < 4) {
      setState(() => _error = 'Enter the OTP code');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final auth = ref.read(authStateProvider.notifier);
      final success = await auth.verifyOtp(_normalizedPhone, code);
      if (!success) {
        final authState = ref.read(authStateProvider);
        setState(() {
          _isLoading = false;
          _error = authState.error ?? 'Invalid OTP';
        });
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
        _error = 'Verification failed. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                    color: WalkTogetherTheme.primary,
                    borderRadius: BorderRadius.circular(24)),
                child: const Icon(Icons.directions_walk,
                    color: WalkTogetherTheme.onPrimary, size: 36),
              ),
              const SizedBox(height: 16),
              Text(t('auth.welcome'),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Find safe, verified walking partners nearby.',
                  style: TextStyle(
                      fontSize: 12, color: WalkTogetherTheme.textSecondary),
                  textAlign: TextAlign.center),
              const Spacer(),
              if (_step == 0) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone), hintText: '+919876543210'),
                ),
                if (_error != null)
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_error!,
                          style: const TextStyle(
                              color: WalkTogetherTheme.danger, fontSize: 12))),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(t('auth.send_otp')),
                ),
              ] else ...[
                GestureDetector(
                  onTap: () => setState(() {
                    _step = 0;
                    _error = null;
                    _otpController.clear();
                  }),
                  child: Text('← Change number',
                      style: TextStyle(
                          fontSize: 12,
                          color: WalkTogetherTheme.textSecondary)),
                ),
                const SizedBox(height: 12),
                Text('Enter OTP sent to $_normalizedPhone',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: const TextStyle(fontSize: 32, letterSpacing: 8),
                  decoration: const InputDecoration(
                      counterText: '', hintText: '••••••'),
                ),
                if (_devCode != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: WalkTogetherTheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Dev OTP: $_devCode',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WalkTogetherTheme.primary)),
                  ),
                if (_error != null)
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_error!,
                          style: const TextStyle(
                              color: WalkTogetherTheme.danger, fontSize: 12))),
                const SizedBox(height: 12),
                if (_cooldown > 0)
                  Text('Resend in ${_cooldown}s',
                      style: TextStyle(
                          fontSize: 11, color: WalkTogetherTheme.textSecondary))
                else
                  GestureDetector(
                    onTap: _sendOtp,
                    child: Text('Resend OTP',
                        style: TextStyle(
                            fontSize: 11,
                            color: WalkTogetherTheme.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(t('auth.verify_otp')),
                ),
              ],
              const Spacer(),
              if (AppConfig.demoLoginEnabled && !AppConfig.isReleaseBuild) ...[
                const Divider(),
                OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          final auth = ref.read(authStateProvider.notifier);
                          await auth.verifyOtp('+919999900000', 'demo-bypass');
                          if (!mounted) return;
                          setState(() => _isLoading = false);
                        },
                  icon: const Icon(Icons.flash_on, size: 16),
                  label: const Text('Continue as demo user'),
                ),
                const Text('Dev mode only.',
                    style: TextStyle(
                        fontSize: 10, color: WalkTogetherTheme.textMuted),
                    textAlign: TextAlign.center),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
