class AttendanceStatusModel {
  final String status;
  final String? message;
  final String? shiftStart;
  final bool isMarkedIn;
  final bool isMarkedOut;
  final String? markInTime;
  final String? markOutTime;
  final String? date;

  const AttendanceStatusModel({
    required this.status,
    this.message,
    this.shiftStart,
    this.isMarkedIn = false,
    this.isMarkedOut = false,
    this.markInTime,
    this.markOutTime,
    this.date,
  });

  factory AttendanceStatusModel.fromJson(Map<String, dynamic> json) {
    final attendance = json['attendance'] is Map
        ? Map<String, dynamic>.from(json['attendance'] as Map)
        : json['data'] is Map
            ? Map<String, dynamic>.from(json['data'] as Map)
            : Map<String, dynamic>.from(json);

    final status = attendance['attendance_status']?.toString() ??
        attendance['status']?.toString() ??
        'not_marked_in';

    return AttendanceStatusModel(
      status: status,
      message: json['message']?.toString(),
      shiftStart: attendance['shift_start_time']?.toString() ??
          attendance['shift_start']?.toString() ??
          '9:30',
      isMarkedIn: _isMarkedIn(status, attendance),
      isMarkedOut: _isMarkedOut(status, attendance),
      markInTime: attendance['mark_in_time']?.toString() ??
          attendance['mark_in']?.toString() ??
          attendance['check_in']?.toString(),
      markOutTime: attendance['mark_out_time']?.toString() ??
          attendance['mark_out']?.toString() ??
          attendance['check_out']?.toString(),
      date: attendance['date']?.toString(),
    );
  }

  static bool _isMarkedIn(String status, Map<String, dynamic> data) {
    if (data['is_marked_in'] == true) return true;
    final s = _normalizeStatus(status);
    if (_isNotMarkedInStatus(s)) return false;
    if (_isMarkedOut(status, data)) return true;
    return s == 'marked in' ||
        s == 'mark in' ||
        s == 'checked in' ||
        s == 'check in' ||
        s == '1';
  }

  static bool _isMarkedOut(String status, Map<String, dynamic> data) {
    if (data['is_marked_out'] == true) return true;
    final s = _normalizeStatus(status);
    return s == 'marked out' ||
        s == 'mark out' ||
        s == 'checked out' ||
        s == 'check out' ||
        s == '2';
  }

  static String _normalizeStatus(String status) {
    return status
        .toLowerCase()
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static bool _isNotMarkedInStatus(String status) {
    return status == 'not marked in' ||
        status == 'not mark in' ||
        status == 'not checked in' ||
        status == 'not check in' ||
        status == '0';
  }

  bool get canMarkIn => !isMarkedIn;
  bool get canMarkOut => isMarkedIn && !isMarkedOut;
}
