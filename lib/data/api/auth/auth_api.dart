import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/domain/models/auth/request_OTP_model.dart';
import 'package:nabd_client_app/domain/models/auth/response_OTP_model.dart';

import '../../../core/error/failures.dart';

abstract class AuthApi{

  Future<Either<Failure ,ResponseOtpModel>> requestOTP(RequestOtpModel requestOtpModel) ;

}