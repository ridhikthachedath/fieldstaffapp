import 'package:field_staff_app/utils/date_formatter.dart';

class LeaveModel {
  final int? id;
  final String leaveMode;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;
  final String? displayDate;

  const LeaveModel({
    this.id,
    required this.leaveMode,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.displayDate,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    final mode = json['leave_mode']?.toString() ?? '';
    final start = json['start_date']?.toString() ?? '';
    return LeaveModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      leaveMode: mode,
      leaveType: json['leave_type']?.toString() ?? '',
      startDate: start,
      endDate: json['end_date']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      status: _parseStatus(json['status']),
      displayDate: _formatDisplayDate(start),
    );
  }

  static String _parseStatus(dynamic value) {
    if (value == null) return 'pending';
    if (value is String) return value.toLowerCase();
    if (value is num) {
      switch (value.toInt()) {
        case 1:
          return 'approved';
        case 2:
          return 'rejected';
        default:
          return 'pending';
      }
    }
    return value.toString().toLowerCase();
  }

  static String? _formatDisplayDate(String raw) {
    if (raw.isEmpty) return null;
    try {
      final date = DateTime.parse(raw);
      return DateFormatter.displayLong.format(date);
    } catch (_) {
      return raw;
    }
  }

  String get applicationLabel {
    if (leaveMode.toLowerCase().contains('half')) {
      return 'Half Day Application';
    }
    return 'Full Day Application';
  }
}
