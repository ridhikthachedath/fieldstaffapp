import 'package:dio/dio.dart';
import 'package:field_staff_app/core/constants/api_constants.dart';
import 'package:field_staff_app/core/network/api_client.dart';
import 'package:field_staff_app/models/route_model.dart';

class RouteRepository {
  final ApiClient _apiClient;

  RouteRepository(this._apiClient);

  Future<List<RouteModel>> fetchRouteList() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.routeList);
      final items = _extractRouteList(response.data);

      return items
          .map((e) => RouteModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw _apiClient.extractErrorMessage(e);
    }
  }

  List<dynamic> _extractRouteList(dynamic data) {
    if (data is List) return data;
    if (data is! Map) return [];

    final map = Map<String, dynamic>.from(data);
    final candidates = [
      map['route_list'],
      map['data'],
      map['routes'],
      map['items'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) return candidate;
      if (candidate is Map) {
        final nested = Map<String, dynamic>.from(candidate);
        for (final key in ['route_list', 'routes', 'data', 'items']) {
          if (nested[key] is List) return nested[key] as List;
        }
      }
    }
    return [];
  }
}
