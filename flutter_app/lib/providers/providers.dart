// WalkTogether — Providers (Riverpod)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import '../services/realtime_service.dart';
import '../services/push_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final realtimeProvider = Provider<RealtimeService>((ref) => RealtimeService());
final pushProvider =
    Provider<PushNotificationService>((ref) => PushNotificationService());

enum AccountGate { ok, suspended, banned, deletionPending }

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final Map<String, dynamic>? user;
  final String? error;
  final AccountGate gate;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.gate = AccountGate.ok,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    String? error,
    AccountGate? gate,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      gate: gate ?? this.gate,
    );
  }

  factory AuthState.fromUser(Map<String, dynamic>? user) {
    if (user == null) return AuthState(isAuthenticated: false);
    final status = user['status'] as String? ?? 'active';
    final statusReason = user['statusReason'] as String? ?? '';
    AccountGate gate = AccountGate.ok;
    if (status == 'banned') {
      gate = AccountGate.banned;
    } else if (status == 'suspended') {
      gate = AccountGate.suspended;
    } else if (statusReason.contains('deletion')) {
      gate = AccountGate.deletionPending;
    }
    return AuthState(isAuthenticated: true, user: user, gate: gate);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _api;
  AuthNotifier(this._api) : super(AuthState());

  Future<void> checkSession() async {
    state = AuthState(isLoading: true);
    try {
      final hasSession = await _api.hasSession();
      if (hasSession) {
        final user = await _api.getMe();
        state = AuthState.fromUser(user);
      } else {
        state = AuthState(isAuthenticated: false);
      }
    } catch (_) {
      state = AuthState(isAuthenticated: false);
    }
  }

  Future<void> refreshUser() async {
    try {
      final user = await _api.getMe();
      state = AuthState.fromUser(user);
    } catch (_) {
      state = AuthState(isAuthenticated: false);
    }
  }

  Future<bool> requestOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _api.requestOtp(phone);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _api.verifyOtp(phone, code);
      final success = await _api.signInWithPhoneOtp(phone, code);
      if (success) {
        final user = await _api.getMe();
        state = AuthState.fromUser(user);
        return true;
      }
      state = state.copyWith(isLoading: false, error: 'Login failed');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await PushNotificationService().unregister();
    } catch (_) {}
    try {
      RealtimeService().disconnect();
    } catch (_) {}
    await _api.logout();
    state = AuthState(isAuthenticated: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiClientProvider));
});

final nearbyWalkersProvider =
    StateNotifierProvider<NearbyWalkersNotifier, NearbyWalkersState>((ref) {
  return NearbyWalkersNotifier(ref.read(apiClientProvider));
});

class NearbyWalkersState {
  final bool isLoading;
  final List<dynamic> walkers;
  final String? error;
  NearbyWalkersState(
      {this.isLoading = false, this.walkers = const [], this.error});
}

class NearbyWalkersNotifier extends StateNotifier<NearbyWalkersState> {
  final ApiClient _api;
  NearbyWalkersNotifier(this._api) : super(NearbyWalkersState());

  Future<void> load() async {
    state = NearbyWalkersState(isLoading: true);
    try {
      final walkers = await _api.listNearbyWalkers();
      state = NearbyWalkersState(walkers: walkers);
    } catch (e) {
      state = NearbyWalkersState(error: e.toString());
    }
  }
}

final deletionStatusProvider =
    StateNotifierProvider<DeletionStatusNotifier, DeletionStatusState>((ref) {
  return DeletionStatusNotifier(ref.read(apiClientProvider));
});

class DeletionStatusState {
  final bool isLoading;
  final Map<String, dynamic>? deletionRequest;
  final String? error;
  DeletionStatusState(
      {this.isLoading = false, this.deletionRequest, this.error});
}

class DeletionStatusNotifier extends StateNotifier<DeletionStatusState> {
  final ApiClient _api;
  DeletionStatusNotifier(this._api) : super(DeletionStatusState());

  Future<void> load() async {
    state = DeletionStatusState(isLoading: true);
    try {
      final res = await _api.getDeletionStatus();
      state = DeletionStatusState(
          deletionRequest: res['deletionRequest'] as Map<String, dynamic>?);
    } catch (e) {
      state = DeletionStatusState(error: e.toString());
    }
  }

  Future<bool> startDeletion({String? reason}) async {
    try {
      await _api.startAccountDeletion(reason: reason);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cancelDeletion() async {
    try {
      await _api.cancelAccountDeletion();
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}
