import 'package:field_staff_app/models/attendance_status_model.dart';
import 'package:field_staff_app/models/route_model.dart';
import 'package:field_staff_app/utils/date_formatter.dart';

class ActivityModel {
  final String date;
  final String markInTime;
  final String markOutTime;
  final RouteModel? originalRoute;

  const ActivityModel({
    required this.date,
    required this.markInTime,
    required this.markOutTime,
    this.originalRoute,
  });

  factory ActivityModel.fromRoute(RouteModel route) {
    return ActivityModel(
      date: route.date,
      markInTime: route.markInTime ?? '--',
      markOutTime: route.markOutTime ?? '--',
      originalRoute: route,
    );
  }

  factory ActivityModel.fromStatus(AttendanceStatusModel status) {
    final route = RouteModel(
      date: status.date ?? DateFormatter.formatDisplay(DateTime.now()),
      markInTime: status.markInTime,
      markOutTime: status.markOutTime,
    );
    return ActivityModel(
      date: route.date,
      markInTime: status.markInTime ?? '--',
      markOutTime: status.markOutTime ?? '--',
      originalRoute: route,
    );
  }

  String get subtitle => 'Marked in at $markInTime  |  Marked out at $markOutTime';
}
