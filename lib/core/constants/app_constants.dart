class AppConstants {
  static const String prefToken = 'auth_token';
  static const String prefLoggedIn = 'is_logged_in';
  static const String prefUserId = 'user_id';
  static const String prefUserName = 'user_name';
  static const String prefUserRole = 'user_role';
  static const String prefUserLocation = 'user_location';
  static const String prefEmployeeId = 'employee_id';
  static const String prefUserEmail = 'user_email';
  static const String prefUserMobile = 'user_mobile';
  static const String prefMarkedIn = 'marked_in_today';
  static const String prefMarkedOut = 'marked_out_today';
  static const String prefMarkInLat = 'mark_in_lat';
  static const String prefMarkInLng = 'mark_in_lng';
  static const String prefMarkOutLat = 'mark_out_lat';
  static const String prefMarkOutLng = 'mark_out_lng';

  static const List<String> leaveTypes = [
    'Casual',
    'Sick',
    'Earned',
    'Unpaid',
  ];

  static const List<String> leaveFilterTabs = [
    'all',
    'pending',
    'approved',
    'rejected',
  ];
}
