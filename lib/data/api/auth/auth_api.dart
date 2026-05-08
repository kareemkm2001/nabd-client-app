import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/domain/models/auth/register_request_model.dart';
import 'package:nabd_client_app/domain/models/auth/request_OTP_model.dart';
import 'package:nabd_client_app/domain/models/auth/response_OTP_model.dart';
import 'package:nabd_client_app/domain/models/auth/verify_Otp_request_model.dart';
import 'package:nabd_client_app/domain/models/auth/verify_Otp_response_model.dart';

import '../../../core/error/failures.dart';

abstract class AuthApi{

  Future<Either<Failure ,ResponseOtpModel>> requestOTP(RequestOtpModel requestOtpModel) ;

  Future<Either<Failure ,VerifyOtpResponseModel>> login(VerifyOtpRequestModel verifyOtpRequestModel);

  Future<Either<Failure , ResponseOtpModel>> register(RegisterRequestModel registerRequestModel);

}