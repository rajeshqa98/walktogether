// WalkTogether — Location Service (stub for build verification)
// Full implementation with geolocator will be added once build is verified.

class LocationService {
  static Future<bool> isLocationServiceEnabled() async => false;
  static Future<bool> requestPermission() async => false;
  static Future<bool> isPermanentlyDenied() async => false;
  static Future<void> openAppSettingsPage() async {}
  static Future<Map<String, String?>> reverseGeocodeApproximate(
    double lat,
    double lng,
  ) async =>
      {};
}
