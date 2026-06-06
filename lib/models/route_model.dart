class RoutePoint {
  final double latitude;
  final double longitude;
  final String? timestamp;

  const RoutePoint({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      latitude: _toDouble(json['latitude'] ?? json['lat']),
      longitude: _toDouble(json['longitude'] ?? json['lng'] ?? json['lon']),
      timestamp: json['timestamp']?.toString() ?? json['time']?.toString(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }
}

class RouteModel {
  final int? id;
  final String date;
  final String? markInTime;
  final String? markOutTime;
  final double? markInLat;
  final double? markInLng;
  final double? markOutLat;
  final double? markOutLng;
  final List<RoutePoint> history;
  final String? distance;

  const RouteModel({
    this.id,
    required this.date,
    this.markInTime,
    this.markOutTime,
    this.markInLat,
    this.markInLng,
    this.markOutLat,
    this.markOutLng,
    this.history = const [],
    this.distance,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    List<RoutePoint> history = [];
    if (json['location_history'] is List) {
      history = (json['location_history'] as List)
          .map((e) => RoutePoint.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else if (json['route_points'] is List) {
      history = (json['route_points'] as List)
          .map((e) => RoutePoint.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    final markInLoc = json['mark_in_location'] is Map
        ? Map<String, dynamic>.from(json['mark_in_location'] as Map)
        : null;
    final markOutLoc = json['mark_out_location'] is Map
        ? Map<String, dynamic>.from(json['mark_out_location'] as Map)
        : null;

    return RouteModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      date: json['date']?.toString() ?? json['attendance_date']?.toString() ?? '',
      markInTime: json['mark_in_time']?.toString() ??
          json['mark_in']?.toString() ??
          json['check_in']?.toString(),
      markOutTime: json['mark_out_time']?.toString() ??
          json['mark_out']?.toString() ??
          json['check_out']?.toString(),
      markInLat: _nullableDouble(
        json['mark_in_latitude'] ??
            json['check_in_lat'] ??
            markInLoc?['latitude'],
      ),
      markInLng: _nullableDouble(
        json['mark_in_longitude'] ??
            json['check_in_lng'] ??
            markInLoc?['longitude'],
      ),
      markOutLat: _nullableDouble(
        json['mark_out_latitude'] ??
            json['check_out_lat'] ??
            markOutLoc?['latitude'],
      ),
      markOutLng: _nullableDouble(
        json['mark_out_longitude'] ??
            json['check_out_lng'] ??
            markOutLoc?['longitude'],
      ),
      history: history,
      distance: json['distance']?.toString() ?? json['total_distance']?.toString(),
    );
  }

  static double? _nullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  String get subtitle {
    final inTime = markInTime ?? '--';
    final outTime = markOutTime ?? '--';
    return 'Marked in at $inTime  |  Marked out at $outTime';
  }

  bool get hasMapData =>
      markInLat != null &&
      markInLng != null &&
      markOutLat != null &&
      markOutLng != null;
}
