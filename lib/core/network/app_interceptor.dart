import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // add token
    options.headers["Authorization"] = "Bearer TOKEN";
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