// WalkTogether — App configuration
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://10.0.2.2:3003',
  );
  static const String socketPath = '/';
  static const String version = '1.7.0';
  static const int buildNumber = 27;
  static const int otpExpiryMinutes = 5;
  static const int otpResendCooldownSeconds = 30;
  static const int otpMaxLength = 6;
  static const int otpMaxAttempts = 5;
  static const bool demoLoginEnabled = bool.fromEnvironment(
    'DEMO_LOGIN',
    defaultValue: true,
  );
  static const bool isReleaseBuild = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );
  static const String privacyPolicyUrl =
      'https://walktogether.app/privacy-policy';
  static const String termsOfServiceUrl =
      'https://walktogether.app/terms-of-service';
  static const String supportEmail = 'support@walktogether.app';
  static const bool isFreeProduct = true;
}
