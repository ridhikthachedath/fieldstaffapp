import 'package:dio/dio.dart';
import 'package:field_staff_app/core/constants/api_constants.dart';
import 'package:field_staff_app/core/network/api_client.dart';
import 'package:field_staff_app/models/leave_model.dart';

class LeaveRepository {
  final ApiClient _apiClient;

  LeaveRepository(this._apiClient);

  Future<void> applyLeave({
    required String leaveMode,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
    required int userId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.applyLeave,
        data: {
          'leave_mode': leaveMode,
          'leave_type': leaveType,
          'start_date': startDate,
          'end_date': endDate,
          'reason': reason,
          'user_id': userId,
        },
      );
      _ensureSuccess(response.data);
    } on DioException catch (e) {
      throw _apiClient.extractErrorMessage(e);
    }
  }

  Future<List<LeaveModel>> fetchLeaves({
    required int employeeId,
    required String leaveType,
    required String month,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.leaves,
        data: {
          'employee_id': employeeId,
          'leave_type': leaveType,
          'month': month,
        },
      );

      final data = response.data;
      _ensureSuccess(data);

      final items = _extractLeaveList(data);
      return items
          .map((e) => LeaveModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw _apiClient.extractErrorMessage(e);
    }
  }

  void _ensureSuccess(dynamic data) {
    if (data is! Map) return;
    final map = Map<String, dynamic>.from(data);
    if (map['status'] == false) {
      final message = map['message'];
      if (message is Map) {
        final errors = message.values.expand((e) => e is List ? e : [e]).join(', ');
        throw errors;
      }
      throw message?.toString() ?? 'Request failed';
    }
  }

  List<dynamic> _extractLeaveList(dynamic data) {
    if (data is List) return data;
    if (data is! Map) return [];

    final map = Map<String, dynamic>.from(data);
    final candidates = [
      map['sales_executive_leaves'],
      map['data'],
      map['leaves'],
      map['items'],
      map['leave_list'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) return candidate;
      if (candidate is Map) {
        final nested = Map<String, dynamic>.from(candidate);
        for (final key in ['sales_executive_leaves', 'leaves', 'data', 'items']) {
          if (nested[key] is List) return nested[key] as List;
        }
      }
    }
    return [];
  }
}
