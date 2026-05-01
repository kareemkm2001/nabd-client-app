import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/error/server_failure.dart';

import 'failures.dart';

class ErrorHandler {
  static Failure handle(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkFailure("Connection Timeout");

      case DioExceptionType.receiveTimeout:
        return const NetworkFailure("Receive Timeout");

      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return const UnauthorizedFailure("Unauthorized");
        }
        return ServerFailure(
          e.response?.data["message"] ?? "Server Error",
        );

      default:
        return const ServerFailure("Unexpected Error");
    }
  }
}