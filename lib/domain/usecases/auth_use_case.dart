import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/domain/models/auth/request_OTP_model.dart';
import 'package:nabd_client_app/domain/models/auth/response_OTP_model.dart';

import '../../../core/error/failures.dart';
import '../../data/api/auth/auth_api.dart';

class AuthUseCase {
  final AuthApi authApi ;

  AuthUseCase({required this.authApi});


  Future<Either<Failure, ResponseOtpModel>> requestOTP(RequestOtpModel requestOtpModel) {
    return authApi.requestOTP(requestOtpModel);
  }
}