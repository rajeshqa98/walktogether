// WalkTogether — API Client (Dio)
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  final _storage = const FlutterSecureStorage();

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final sessionCookie = await _storage.read(key: 'session_cookie');
        if (sessionCookie != null) {
          options.headers['Cookie'] = 'next-auth.session-token=$sessionCookie';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _storage.delete(key: 'session_cookie');
          await _storage.delete(key: 'socket_token');
        }
        handler.next(error);
      },
    ));
  }

  Future<Map<String, dynamic>> requestOtp(String phone) async {
    final res = await dio.post('/api/auth/otp/request', data: {'phone': phone});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String code) async {
    final res = await dio
        .post('/api/auth/otp/verify', data: {'phone': phone, 'code': code});
    return res.data as Map<String, dynamic>;
  }

  Future<bool> signInWithPhoneOtp(String phone, String otp) async {
    final csrfRes = await dio.get('/api/auth/csrf');
    final csrfToken = csrfRes.data['csrfToken'] as String;
    final res = await dio.post(
      '/api/auth/callback/phone-otp',
      data: {
        'phone': phone,
        'otp': otp,
        'csrfToken': csrfToken,
        'json': 'true'
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) => status != null && status < 400,
      ),
    );
    final setCookie = res.headers['set-cookie'];
    if (setCookie != null) {
      for (final cookie in setCookie) {
        if (cookie.contains('next-auth.session-token')) {
          final token = cookie.split(';')[0].split('=').last;
          await _storage.write(key: 'session_cookie', value: token);
          await _storage.write(key: 'socket_token', value: token);
          return true;
        }
      }
    }
    return false;
  }

  Future<void> logout() async {
    try {
      await dio.post('/api/auth/logout');
    } catch (_) {}
    await _storage.delete(key: 'session_cookie');
    await _storage.delete(key: 'socket_token');
  }

  Future<bool> hasSession() async {
    final cookie = await _storage.read(key: 'session_cookie');
    return cookie != null;
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await dio.get('/api/me');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMe(Map<String, dynamic> data) async {
    final res = await dio.patch('/api/me', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> listNearbyWalkers({int radius = 500}) async {
    final res = await dio.get('/api/walkers?radius=$radius');
    return res.data as List;
  }

  Future<Map<String, dynamic>> listRequests() async {
    final res = await dio.get('/api/requests');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendRequest(Map<String, dynamic> data) async {
    final res = await dio.post('/api/requests', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> respondToRequest(
      String id, String status) async {
    final res = await dio.patch('/api/requests/$id', data: {'status': status});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> startSession(String requestId) async {
    final res = await dio.post('/api/sessions', data: {'requestId': requestId});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSession(String id) async {
    final res = await dio.get('/api/sessions/$id');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> endSession(String id) async {
    final res = await dio.patch('/api/sessions/$id', data: {'status': 'ended'});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> triggerSos(String sessionId) async {
    final res = await dio.post('/api/sessions/$sessionId/sos');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> setSafetyShare(
      String sessionId, bool enabled) async {
    final res = await dio
        .post('/api/sessions/$sessionId/safety', data: {'enabled': enabled});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitReport(Map<String, dynamic> data) async {
    final res = await dio.post('/api/reports', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> blockUser(String blockedId) async {
    final res = await dio.post('/api/blocks', data: {'blockedId': blockedId});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listNotifications() async {
    final res = await dio.get('/api/notifications');
    return res.data as Map<String, dynamic>;
  }

  Future<void> savePushSubscription(Map<String, dynamic> data) async {
    await dio.post('/api/me/push-subscription', data: data);
  }

  Future<void> removePushSubscription(String endpoint) async {
    await dio.delete(
        '/api/me/push-subscription?endpoint=${Uri.encodeComponent(endpoint)}');
  }

  Future<Map<String, dynamic>> listGroupWalks() async {
    final res = await dio.get('/api/group-walks');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getGroupWalk(String id) async {
    final res = await dio.get('/api/group-walks/$id');
    return res.data as Map<String, dynamic>;
  }

  Future<void> joinGroupWalk(String id) async {
    await dio.post('/api/group-walks/$id/join');
  }

  Future<void> leaveGroupWalk(String id) async {
    await dio.post('/api/group-walks/$id/leave');
  }

  Future<Map<String, dynamic>> listClubs() async {
    final res = await dio.get('/api/clubs');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getClub(String id) async {
    final res = await dio.get('/api/clubs/$id');
    return res.data as Map<String, dynamic>;
  }

  Future<void> joinClub(String id) async {
    await dio.post('/api/clubs/$id/join');
  }

  Future<void> leaveClub(String id) async {
    await dio.post('/api/clubs/$id/leave');
  }

  Future<Map<String, dynamic>> submitFeedback({
    required String category,
    required int rating,
    required String message,
  }) async {
    final res = await dio.post('/api/feedback', data: {
      'category': category,
      'rating': rating,
      'message': message,
    });
    return res.data as Map<String, dynamic>;
  }

  // Phase 25 — Privacy + Deletion + Export
  Future<List<dynamic>> listMyPrivacyRequests() async {
    final res = await dio.get('/api/privacy-requests');
    return res.data['requests'] as List;
  }

  Future<Map<String, dynamic>> createPrivacyRequest({
    required String requestType,
    String? details,
  }) async {
    final res = await dio.post('/api/privacy-requests', data: {
      'requestType': requestType,
      if (details != null) 'details': details,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDeletionStatus() async {
    final res = await dio.get('/api/me/deletion');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> startAccountDeletion({String? reason}) async {
    final res = await dio.post('/api/me/deletion', data: {'reason': reason});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> cancelAccountDeletion() async {
    final res = await dio.delete('/api/me/deletion');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> exportMyData() async {
    final res = await dio.get('/api/me/export');
    return res.data as Map<String, dynamic>;
  }

  // Phase 21 — Appeals
  Future<List<dynamic>> listMyAppeals() async {
    final res = await dio.get('/api/appeals');
    return res.data['appeals'] as List;
  }

  Future<Map<String, dynamic>> createAppeal({
    required String actionType,
    required String reason,
    required String explanation,
  }) async {
    final res = await dio.post('/api/appeals', data: {
      'actionType': actionType,
      'reason': reason,
      'explanation': explanation,
    });
    return res.data as Map<String, dynamic>;
  }

  // Phase 16 — Area + Host
  Future<Map<String, dynamic>> getArea() async {
    final res = await dio.get('/api/area');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> onboardHost(Map<String, dynamic> data) async {
    final res = await dio.post('/api/host/onboard', data: data);
    return res.data as Map<String, dynamic>;
  }
}
