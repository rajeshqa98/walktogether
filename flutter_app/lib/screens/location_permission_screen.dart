// WalkTogether — Location Permission Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});
  @override
  ConsumerState<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends ConsumerState<LocationPermissionScreen> {
  final _villageController = TextEditingController();
  final _townController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  bool _manualMode = false;

  @override
  void dispose() {
    _villageController.dispose();
    _townController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _saveLocation() async {
    final city = _cityController.text.trim();
    if (city.isEmpty && _villageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter at least a city or village.')),
      );
      return;
    }
    try {
      await ref.read(apiClientProvider).updateMe({
        'village': _villageController.text.trim(),
        'town': _townController.text.trim(),
        'city': city,
        'district': _districtController.text.trim(),
        'stateRegion': _stateController.text.trim(),
      });
      await ref.read(authStateProvider.notifier).refreshUser();
      if (mounted) context.go('/home');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save location. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Set your location'),
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.location_on,
                  size: 48, color: WalkTogetherTheme.primary),
              const SizedBox(height: 16),
              const Text('Where do you want to walk?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'WalkTogether uses your location only to find nearby walkers. Your exact location is never shared with other users — only approximate distance.',
                style: TextStyle(
                    fontSize: 12, color: WalkTogetherTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              if (!_manualMode) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'GPS location requires device permissions. Using manual entry.')),
                    );
                    setState(() => _manualMode = true);
                  },
                  icon: const Icon(Icons.my_location),
                  label: const Text('Use my GPS location'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _manualMode = true),
                  child: const Text('Enter location manually instead'),
                ),
              ] else ...[
                TextField(
                  controller: _villageController,
                  decoration: const InputDecoration(
                      labelText: 'Village (optional)',
                      prefixIcon: Icon(Icons.home)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _townController,
                  decoration: const InputDecoration(
                      labelText: 'Town (optional)',
                      prefixIcon: Icon(Icons.location_city)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                      labelText: 'City *',
                      prefixIcon: Icon(Icons.location_city)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _districtController,
                  decoration:
                      const InputDecoration(labelText: 'District (optional)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                      labelText: 'State / Region (optional)'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveLocation,
                  child: const Text('Save and continue'),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Your privacy: We never share your exact coordinates. Only walkers within your radius see approximate distance.',
                style:
                    TextStyle(fontSize: 10, color: WalkTogetherTheme.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
