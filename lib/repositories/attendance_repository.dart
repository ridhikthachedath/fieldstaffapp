import 'package:dio/dio.dart';
import 'package:field_staff_app/core/constants/api_constants.dart';
import 'package:field_staff_app/core/network/api_client.dart';
import 'package:field_staff_app/models/attendance_status_model.dart';
import 'package:field_staff_app/services/local_storage_service.dart';

class AttendanceRepository {
  final ApiClient _apiClient;
  final LocalStorageService _storage;

  AttendanceRepository(this._apiClient, this._storage);

  Future<AttendanceStatusModel> getStatus() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.attendanceStatus);
      final data = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final status = AttendanceStatusModel.fromJson(data);
      await _syncLocalAttendance(status);
      return status;
    } on DioException catch (e) {
      throw _apiClient.extractErrorMessage(e);
    }
  }

  Future<String> markAttendance({
    required String attendanceStatus,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final apiStatus = _toApiStatus(attendanceStatus);
      final response = await _apiClient.dio.post(
        ApiConstants.attendanceMark,
        data: {
          'attendance_status': apiStatus,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      final data = response.data;
      if (data is Map && data['status'] == false) {
        final message = data['message'];
        throw message?.toString() ?? 'Failed to mark attendance';
      }

      if (apiStatus == 1) {
        await _storage.saveMarkIn(latitude, longitude);
      } else {
        await _storage.saveMarkOut(latitude, longitude);
      }

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return apiStatus == 1
          ? 'Marked in successfully'
          : 'Marked out successfully';
    } on DioException catch (e) {
      throw _apiClient.extractErrorMessage(e);
    }
  }

  int _toApiStatus(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('out') || normalized == '2') return 2;
    return 1;
  }

  Future<void> _syncLocalAttendance(AttendanceStatusModel status) async {
    if (status.isMarkedOut) {
      return;
    }
    if (status.isMarkedIn && !_storage.markedInToday) {
      await _storage.saveMarkIn(
        _storage.markInLat ?? 0,
        _storage.markInLng ?? 0,
      );
    }
    if (!status.isMarkedIn && _storage.markedInToday) {
      await _storage.resetDailyAttendance();
    }
  }
}
