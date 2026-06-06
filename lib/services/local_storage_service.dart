import 'package:field_staff_app/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  String? getToken() => _prefs.getString(AppConstants.prefToken);
  bool get isLoggedIn => _prefs.getBool(AppConstants.prefLoggedIn) ?? false;
  int? get userId => _prefs.getInt(AppConstants.prefUserId);
  String? get userName => _prefs.getString(AppConstants.prefUserName);
  String? get userRole => _prefs.getString(AppConstants.prefUserRole);
  String? get userLocation => _prefs.getString(AppConstants.prefUserLocation);
  int? get employeeId => _prefs.getInt(AppConstants.prefEmployeeId);
  String? get userEmail => _prefs.getString(AppConstants.prefUserEmail);
  String? get userMobile => _prefs.getString(AppConstants.prefUserMobile);

  bool get markedInToday => _prefs.getBool(AppConstants.prefMarkedIn) ?? false;
  bool get markedOutToday => _prefs.getBool(AppConstants.prefMarkedOut) ?? false;

  double? get markInLat => _prefs.getDouble(AppConstants.prefMarkInLat);
  double? get markInLng => _prefs.getDouble(AppConstants.prefMarkInLng);
  double? get markOutLat => _prefs.getDouble(AppConstants.prefMarkOutLat);
  double? get markOutLng => _prefs.getDouble(AppConstants.prefMarkOutLng);

  bool get canViewRoute => true;

  Future<void> saveLoginSession({
    required String token,
    required int userId,
    required String name,
    String? role,
    String? location,
    int? employeeId,
    String? email,
    String? mobile,
  }) async {
    await _prefs.setString(AppConstants.prefToken, token);
    await _prefs.setBool(AppConstants.prefLoggedIn, true);
    await _prefs.setInt(AppConstants.prefUserId, userId);
    await _prefs.setString(AppConstants.prefUserName, name);
    if (role != null) await _prefs.setString(AppConstants.prefUserRole, role);
    if (location != null) {
      await _prefs.setString(AppConstants.prefUserLocation, location);
    }
    if (employeeId != null) {
      await _prefs.setInt(AppConstants.prefEmployeeId, employeeId);
    }
    if (email != null) {
      await _prefs.setString(AppConstants.prefUserEmail, email);
    }
    if (mobile != null) {
      await _prefs.setString(AppConstants.prefUserMobile, mobile);
    }
  }

  Future<void> saveMarkIn(double lat, double lng) async {
    await _prefs.setBool(AppConstants.prefMarkedIn, true);
    await _prefs.setDouble(AppConstants.prefMarkInLat, lat);
    await _prefs.setDouble(AppConstants.prefMarkInLng, lng);
  }

  Future<void> saveMarkOut(double lat, double lng) async {
    await _prefs.setBool(AppConstants.prefMarkedOut, true);
    await _prefs.setDouble(AppConstants.prefMarkOutLat, lat);
    await _prefs.setDouble(AppConstants.prefMarkOutLng, lng);
  }

  Future<void> resetDailyAttendance() async {
    await _prefs.setBool(AppConstants.prefMarkedIn, false);
    await _prefs.setBool(AppConstants.prefMarkedOut, false);
    await _prefs.remove(AppConstants.prefMarkInLat);
    await _prefs.remove(AppConstants.prefMarkInLng);
    await _prefs.remove(AppConstants.prefMarkOutLat);
    await _prefs.remove(AppConstants.prefMarkOutLng);
  }

  Future<void> clearSession() async {
    await _prefs.clear();
  }
}
