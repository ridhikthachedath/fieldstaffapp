import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<bool> ensurePermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    if (status.isPermanentlyDenied) {
      return false;
    }
    return status.isGranted;
  }

  Future<Position> getCurrentPosition() async {
    final hasPermission = await ensurePermission();
    if (!hasPermission) {
      throw Exception('Location permission is required to mark attendance.');
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Please enable location services on your device.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
