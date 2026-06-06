import 'package:dio/dio.dart';
import 'package:field_staff_app/core/constants/api_constants.dart';
import 'package:field_staff_app/core/network/api_client.dart';
import 'package:field_staff_app/models/user_model.dart';
import 'package:field_staff_app/services/local_storage_service.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final LocalStorageService _storage;

  AuthRepository(this._apiClient, this._storage);

  Future<UserModel> login({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {
          'mobile_number': mobileNumber,
          'password': password,
        },
      );
      final data = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final user = UserModel.fromJson(data);
      final token = user.token ?? data['token']?.toString() ?? '';

      await _storage.saveLoginSession(
        token: token,
        userId: user.id,
        name: user.name,
        role: user.role,
        location: user.location,
        employeeId: user.employeeId ?? user.id,
        email: user.email,
        mobile: user.mobileNumber ?? mobileNumber,
      );

      return user.copyWith(token: token.isNotEmpty ? token : user.token);
    } on DioException catch (e) {
      throw _apiClient.extractErrorMessage(e);
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String address,
    required String dob,
    required String mobileNumber,
    required String doj,
    required String location,
  }) async {
    try {
      await _apiClient.dio.post(
        ApiConstants.register,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'address': address,
          'dob': dob,
          'mobile_number': mobileNumber,
          'doj': doj,
          'location': location,
        },
      );
    } on DioException catch (e) {
      throw _apiClient.extractErrorMessage(e);
    }
  }

  Future<void> logout() => _storage.clearSession();

  bool get isLoggedIn => _storage.isLoggedIn;
}
