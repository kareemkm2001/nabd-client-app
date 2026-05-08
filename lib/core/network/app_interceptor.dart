import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nabd_client_app/core/services/token_service.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    // add token
    final token = await TokenService.getToken();
    if(token != null){
      options.headers["Authorization"] = "Bearer $token" ;
    }

    if (kDebugMode) {
      print("REQUEST: ${options.path}");
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print("RESPONSE: ${response.data}");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print("ERROR: ${e.message}");
    }
    super.onError(e, handler);
  }
}