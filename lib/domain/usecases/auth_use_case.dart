import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/domain/models/auth/request_OTP_model.dart';
import 'package:nabd_client_app/domain/models/auth/response_OTP_model.dart';

import '../../../core/error/failures.dart';
import '../../data/api/auth/auth_api.dart';
import '../models/auth/register_request_model.dart';
import '../models/auth/verify_Otp_request_model.dart';
import '../models/auth/verify_Otp_response_model.dart';

class AuthUseCase {
  final AuthApi authApi ;

  AuthUseCase({required this.authApi});


  Future<Either<Failure, ResponseOtpModel>> requestOTP(RequestOtpModel requestOtpModel) async {
    return await authApi.requestOTP(requestOtpModel);
  }

  Future<Either<Failure ,VerifyOtpResponseModel>> login(VerifyOtpRequestModel verifyOtpRequestModel) async {
    return await authApi.login(verifyOtpRequestModel);
  }

  Future<Either<Failure, ResponseOtpModel>> register(RegisterRequestModel registerRequestModel) async {
    return await authApi.register(registerRequestModel);
  }
}