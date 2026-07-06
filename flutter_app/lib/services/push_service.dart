// WalkTogether — Push Notification Service (stub for build verification)
// Full FCM implementation will be added once build is verified.

class PushNotificationService {
  String? get token => null;
  Future<void> initLocalNotifications() async {}
  Future<bool> requestPermission() async => false;
  Future<bool> register() async => false;
  Future<void> unregister() async {}
  void setupForegroundHandler() {}
}
