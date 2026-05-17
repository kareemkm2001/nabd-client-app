import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';
import 'package:nabd_client_app/core/network/app_interceptor.dart';
import 'package:nabd_client_app/core/services/token_service.dart';
import 'api_constants.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
        "Accept-Language": "ar"  /*بسبب en مش بيبعت رسايل*//*AppLocalization.currentLanguageCode*/,
      },
    ),
  )..interceptors.add(AppInterceptor());

  static Dio get instance => _dio;
}