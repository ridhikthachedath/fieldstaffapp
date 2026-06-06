import 'package:field_staff_app/models/activity_model.dart';
import 'package:field_staff_app/models/attendance_status_model.dart';
import 'package:field_staff_app/models/route_model.dart';
import 'package:field_staff_app/repositories/attendance_repository.dart';
import 'package:field_staff_app/repositories/route_repository.dart';
import 'package:field_staff_app/services/local_storage_service.dart';
import 'package:field_staff_app/services/location_service.dart';
import 'package:field_staff_app/viewmodels/base_viewmodel.dart';

class DashboardViewModel extends BaseViewModel {
  final AttendanceRepository _attendanceRepository;
  final RouteRepository _routeRepository;
  final LocationService _locationService;
  final LocalStorageService _storage;

  AttendanceStatusModel? _status;
  List<ActivityModel> _recentActivities = [];
  String? _successMessage;

  DashboardViewModel(
    this._attendanceRepository,
    this._routeRepository,
    this._locationService,
    this._storage,
  );

  AttendanceStatusModel? get status => _status;
  List<ActivityModel> get recentActivities => _recentActivities;
  String? get successMessage => _successMessage;

  String get userName => _storage.userName ?? 'User';
  String get userRole => _storage.userRole ?? 'Sales Executive';
  String get userLocation => _storage.userLocation ?? 'Ernakulam';
  bool get canViewRoute => _storage.canViewRoute;

  bool get isMarkedIn => _status?.isMarkedIn ?? _storage.markedInToday;
  bool get isMarkedOut => _status?.isMarkedOut ?? _storage.markedOutToday;

  String get shiftStart => _status?.shiftStart ?? '9:30';

  String get attendanceCardTitle {
    if (isMarkedOut) return 'Your Day Completed';
    if (isMarkedIn) return 'Your work started';
    return 'Start Your Day!';
  }

  String get attendanceCardSubtitle {
    if (isMarkedOut) {
      return 'Started at ${_timeOrFallback(_status?.markInTime)} '
          'Ended at ${_timeOrFallback(_status?.markOutTime)}';
    }
    if (isMarkedIn) {
      return 'Checked In at ${_timeOrFallback(_status?.markInTime)}';
    }
    return 'Your shift start at $shiftStart';
  }

  String get markButtonLabel =>
      isMarkedIn && !isMarkedOut ? 'Mark Out' : 'Mark In';

  Future<void> loadDashboard() async {
    setLoading();
    try {
      _status = await _attendanceRepository.getStatus();
      final routes = await _routeRepository.fetchRouteList();
      _recentActivities = _buildRecentActivities(routes, _status);
      setSuccess();
    } catch (e) {
      _status = AttendanceStatusModel(
        status: isMarkedIn ? 'marked_in' : 'not_marked_in',
        shiftStart: '9:30',
        isMarkedIn: isMarkedIn,
        isMarkedOut: isMarkedOut,
        markInTime: null,
        markOutTime: null,
      );
      _recentActivities = _buildRecentActivities([], _status);
      setError(e.toString());
    }
  }

  List<ActivityModel> _buildRecentActivities(
    List<RouteModel> routes,
    AttendanceStatusModel? status,
  ) {
    final activities = routes.take(4).map(ActivityModel.fromRoute).toList();

    if (status != null && status.isMarkedIn && !status.isMarkedOut) {
      final todayActivity = ActivityModel.fromStatus(status);
      final todayKey = _normalizeDate(todayActivity.date);
      activities.removeWhere((a) => _normalizeDate(a.date) == todayKey);
      activities.insert(0, todayActivity);
    }

    return activities.take(4).toList();
  }

  String _normalizeDate(String value) {
    return value.toLowerCase().replaceAll(',', '').trim();
  }

  String _timeOrFallback(String? value) {
    if (value == null || value.trim().isEmpty) return '--';
    return value;
  }

  Future<bool> markAttendance() async {
    setLoading();
    try {
      final position = await _locationService.getCurrentPosition();
      final statusLabel = (isMarkedIn && !isMarkedOut) ? 'mark_out' : 'mark_in';

      _successMessage = await _attendanceRepository.markAttendance(
        attendanceStatus: statusLabel,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await loadDashboard();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  void clearSuccessMessage() {
    _successMessage = null;
  }
}
