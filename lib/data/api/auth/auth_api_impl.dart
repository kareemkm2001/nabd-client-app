import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/core/network/api_constants.dart';
import 'package:nabd_client_app/core/network/api_service.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/server_failure.dart';
import 'auth_api.dart';

class AuthApiImpl implements AuthApi {

  ApiService api ;

  AuthApiImpl({required this.api});

  @override
  Future<Either<Failure, String>> requestOTP(String numberPhone) async {

    try {
      final response = await api.post(
        ApiConstants.requestOTP,
        data: {
          "mobile": numberPhone
        }
      );

      return Right(response.data["message"]);
    } on DioException catch (e){
      return Left(ErrorHandler.handle(e));

    }catch (e){
      return Left(ServerFailure(e.toString()));
    }

  }
  

}