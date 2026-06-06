class UserModel {
  final int id;
  final String name;
  final String? role;
  final String? location;
  final String? mobileNumber;
  final String? email;
  final int? employeeId;
  final String? token;

  const UserModel({
    required this.id,
    required this.name,
    this.role,
    this.location,
    this.mobileNumber,
    this.email,
    this.employeeId,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : json;
    final userId = _parseInt(user['user_id'] ?? user['id'] ?? json['user_id']) ?? 0;
    return UserModel(
      id: userId,
      name: _parseName(user),
      role: user['role']?.toString() ?? user['designation']?.toString(),
      location: user['location']?.toString(),
      mobileNumber: user['mobile_number']?.toString(),
      email: user['email']?.toString(),
      employeeId: _parseInt(user['employee_id'] ?? user['user_id'] ?? user['id']),
      token: json['token']?.toString() ??
          json['access_token']?.toString() ??
          (json['data'] is Map
              ? (json['data'] as Map)['token']?.toString()
              : null),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static String _parseName(Map<String, dynamic> user) {
    final first = user['first_name']?.toString() ?? '';
    final last = user['last_name']?.toString() ?? '';
    final full = '$first $last'.trim();
    if (full.isNotEmpty) return full;
    return user['name']?.toString() ?? 'User';
  }

  UserModel copyWith({String? token}) {
    return UserModel(
      id: id,
      name: name,
      role: role,
      location: location,
      mobileNumber: mobileNumber,
      email: email,
      employeeId: employeeId,
      token: token ?? this.token,
    );
  }
}
