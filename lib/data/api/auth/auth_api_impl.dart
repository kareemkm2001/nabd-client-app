import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/core/network/api_constants.dart';
import 'package:nabd_client_app/core/network/api_service.dart';
import 'package:nabd_client_app/domain/models/auth/request_OTP_model.dart';
import 'package:nabd_client_app/domain/models/auth/response_OTP_model.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/server_failure.dart';
import 'auth_api.dart';

class AuthApiImpl implements AuthApi {

  ApiService api ;

  AuthApiImpl({required this.api});

  @override
  Future<Either<Failure, ResponseOtpModel>> requestOTP(RequestOtpModel requestOtpModel) async {
    try {

      final response = await api.post(
        ApiConstants.requestOTP,
        data: requestOtpModel.toJson()
      );

      final model = ResponseOtpModel.fromJson(response.data);

      return Right(model);
    } on DioException catch (e){
      print("مممممممممممممممم ${e.error}");
      return Left(ErrorHandler.handle(e));

    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }
}