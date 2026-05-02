import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/network/app_interceptor.dart';
import 'api_constants.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
        //"Authorization"
      },
    ),
  )..interceptors.add(AppInterceptor());

  static Dio get instance => _dio;
}