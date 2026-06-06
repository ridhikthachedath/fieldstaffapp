/// Google Maps API key configuration.
///
/// To enable Google Maps:
/// 1. Create a key at https://console.cloud.google.com/google/maps-apis
/// 2. Android: add to `android/app/src/main/AndroidManifest.xml`:
///    `<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_KEY"/>`
/// 3. iOS: add to `ios/Runner/AppDelegate.swift` or `Info.plist`:
///    `GMSServices.provideAPIKey("YOUR_KEY")`
/// 4. Set the key below or pass via `--dart-define=GOOGLE_MAPS_API_KEY=your_key`
class MapsConfig {
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static bool get hasGoogleMapsKey => googleMapsApiKey.isNotEmpty;

  static const String googleMapsSetupInstructions =
      'Google Maps API key is not configured. '
      'The app uses OpenStreetMap via flutter_map as fallback. '
      'Add GOOGLE_MAPS_API_KEY via --dart-define or update MapsConfig.';
}
