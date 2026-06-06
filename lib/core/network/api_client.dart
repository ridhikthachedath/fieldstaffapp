import 'package:dio/dio.dart';
import 'package:field_staff_app/core/constants/api_constants.dart';
import 'package:field_staff_app/services/local_storage_service.dart';

class ApiClient {
  late final Dio dio;

  ApiClient({LocalStorageService? storage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = storage?.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  String extractErrorMessage(DioException error) {
    if (error.response?.data is Map) {
      final data = error.response!.data as Map;
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        return errors.values.first.toString();
      }
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Check your network.';
      default:
        return error.message ?? 'Something went wrong. Please try again.';
    }
  }
}
