# Location Privacy Device Test Report

**Phase:** 27C
**Status:** Code-verified; physical device test pending beta
**Last updated:** 2026-07-06

## Overview

WalkTogether's location privacy is a core safety commitment. This report documents the location privacy implementation and what must be verified on a physical device.

## Location privacy principles

1. **Foreground only** — WalkTogether never requests background location permission
2. **Approximate precision** — uses `LocationAccuracy.medium` (~50-100m), not `high` (~5m)
3. **No exact coordinates in UI** — nearby walkers see "500m away", not lat/lng
4. **No exact coordinates in exports** — data export excludes lat/lng of other users
5. **Manual fallback** — users can enter village/town/city manually without GPS
6. **User control** — "Hide me from nearby" toggle in Settings

## Implementation verification

### Location permission flow (`location_service.dart`)

```dart
static Future<bool> requestPermission() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied) return false;
  if (permission == LocationPermission.deniedForever) return false;

  // whileInUse only — never LocationPermission.always
  return permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;
}
```

**Key points:**
- Requests `whileInUse` only (foreground)
- Never requests `always` (background)
- Handles `denied` and `deniedForever` states
- Returns `false` if service disabled or permission denied

### GPS accuracy

```dart
return await Geolocator.getCurrentPosition(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.medium,  // ~50-100m, not high (~5m)
    timeLimit: Duration(seconds: 10),
  ),
);
```

**Why medium?** High accuracy gives ~5m precision which reveals exact home/work location. Medium gives ~50-100m which is sufficient for "is this walker within 500m?" matching without revealing exact coordinates.

### Manual location fallback (`location_permission_screen.dart`)

When GPS is unavailable or denied, users can enter:
- Village (optional)
- Town (optional)
- City (required)
- District (optional)
- State / Region (optional)

This is saved via `apiClient.updateMe({village, town, city, district, stateRegion})`.

### Reverse geocoding (coarse only)

```dart
static Future<Map<String, String?>> reverseGeocodeApproximate(
  double lat, double lng,
) async {
  final placemarks = await placemarkFromCoordinates(lat, lng);
  return {
    'city': p.locality,
    'district': p.subAdministrativeArea,
    'stateRegion': p.administrativeArea,
    'country': p.country,
    'countryCode': p.isoCountryCode,
  };
}
```

Returns coarse location only — never returns lat/lng to the UI.

### Nearby walkers API

The backend (`GET /api/walkers`) returns:
```json
[
  {
    "id": "clxxx...",
    "name": "Alice",
    "distance": 500,  // meters — NOT lat/lng
    "trustScore": 75,
    "verificationStatus": "verified"
  }
]
```

The `distance` field is computed server-side from the user's LivePresence. The response never includes exact lat/lng of other users.

### Walker detail screen

Displays: name, distance ("500m away"), trust score, verification badge, bio.

**Never displays:** lat/lng, exact address, map pin of other users.

### Settings — "Hide me from nearby"

```dart
SwitchListTile(
  title: Text('Hide me from nearby'),
  value: _hideMe,
  onChanged: _toggleHideMe,
)
```

Calls `apiClient.updateMe({'hideMe': value})`. When `hideMe` is true, the user does not appear in other users' nearby lists.

### Data export location privacy

The backend (`GET /api/me/export`) excludes:
- Other users' phone numbers
- Other users' email addresses
- Other users' exact coordinates
- Admin-only safety intelligence

The user's own phone number is partially redacted: `+919876543210` → `+91*****4321`.

## AndroidManifest permissions

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**NOT requested:**
- `ACCESS_BACKGROUND_LOCATION` — WalkTogether does not track users in the background

## iOS Info.plist

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>WalkTogether uses your location only to find nearby walking partners within your chosen radius. Your exact location is never shared with other users — only approximate distance is shown. We never track you in the background.</string>
```

**NOT included:** `NSLocationAlwaysAndWhenInUseUsageDescription` (no background location)

## Device test checklist

### GPS permission

- [ ] App requests location permission on first "Use my GPS location" tap
- [ ] Permission dialog asks for "While using the app" only (not "Always")
- [ ] Granting permission allows location detection
- [ ] No background location permission requested

### Denied permission

- [ ] Denying permission shows manual entry fallback
- [ ] Manual entry form works (village/town/city/district/state)
- [ ] City field is required
- [ ] Saving manual location navigates to home

### Permanently denied

- [ ] "Permanently denied" state shows "open settings" option
- [ ] Tapping "open settings" opens Android app settings
- [ ] User can grant permission from settings + return to app

### Manual village/town

- [ ] Village field accepts free text
- [ ] Town field accepts free text
- [ ] City field is required
- [ ] District field accepts free text
- [ ] State field accepts free text
- [ ] Saved location persists across app restarts

### Approximate location labels

- [ ] Nearby walkers show "Xm away" (coarse distance)
- [ ] Walker detail shows "Xm away" (coarse distance)
- [ ] No exact lat/lng visible in any UI
- [ ] No map pin showing exact location of other users

### No exact location leakage

- [ ] Data export does not contain other users' lat/lng
- [ ] Chat messages do not leak location
- [ ] Group walk meeting points show name + neighborhood (not exact coordinates until allowed)
- [ ] Notifications do not contain coordinates
- [ ] Logs do not contain exact coordinates (verified by security review)

### "Hide me from nearby"

- [ ] Toggle in Settings works
- [ ] When enabled, user does not appear in other users' nearby lists
- [ ] When disabled, user reappears in nearby lists
- [ ] Toggle state persists across app restarts

## Acceptance criteria

- ✅ Foreground location only (code-verified)
- ✅ No background location permission (manifest-verified)
- ✅ Denied permission → manual entry fallback (code-verified)
- ✅ Permanently denied → open settings (code-verified)
- ✅ Manual village/town/city/district/state fields (code-verified)
- ✅ Approximate location labels (code-verified)
- ✅ No exact coordinates in UI (code-verified)
- ✅ No exact coordinates in data export (backend-verified)
- ✅ "Hide me from nearby" toggle (code-verified)
- ⏳ Physical device verification — pending beta tester
