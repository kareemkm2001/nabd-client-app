import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/core/network/api_constants.dart';
import 'package:nabd_client_app/core/network/api_service.dart';
import 'package:nabd_client_app/core/services/token_service.dart';
import 'package:nabd_client_app/domain/models/auth/register_request_model.dart';
import 'package:nabd_client_app/domain/models/auth/request_OTP_model.dart';
import 'package:nabd_client_app/domain/models/auth/response_OTP_model.dart';
import 'package:nabd_client_app/domain/models/auth/verify_Otp_request_model.dart';
import 'package:nabd_client_app/domain/models/auth/verify_Otp_response_model.dart';

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
      
      print("شكل الطلب ${requestOtpModel.toJson()}");

      final model = ResponseOtpModel.fromJson(response.data);
      print("شكل النتيجة ${model.toJson()}");
      print(" النتيجة ${response.statusCode}");

      return Right(model);
    } on DioException catch (e){
      print("مممممممممممممممم ${e.error}");
      return Left(ErrorHandler.handle(e));

    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyOtpResponseModel>> login(VerifyOtpRequestModel verifyOtpRequestModel) async {
    try {

      final response = await api.post(
          ApiConstants.loginOTPVerify,
          data: verifyOtpRequestModel.toJson()
      );
      
      print("شكل الطلب ${verifyOtpRequestModel.toJson()}");

      final model = VerifyOtpResponseModel.fromJson(response.data);
      await TokenService.saveToken(model.data?.accessToken ?? "");
      print("النتيجة $model");

      return Right(model);
    } on DioException catch (e){
      print("مممممممممممممممم ${e.error}");
      return Left(ErrorHandler.handle(e));

    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResponseOtpModel>> register(RegisterRequestModel registerRequestModel) async {
    try {

      final response = await api.post(
          ApiConstants.register,
          data: registerRequestModel.toJson()
      );

      print("شكل الطلب ${registerRequestModel.toJson()}");

      final model = ResponseOtpModel.fromJson(response.data);
      print("شكل النتيجة ${model.toJson()}");
      print(" النتيجة ${response.statusCode}");

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