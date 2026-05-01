import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../data/api/auth/auth_api.dart';

class AuthUseCase {
  final AuthApi authApi ;

  AuthUseCase({required this.authApi});


  Future<Either<Failure, String>> requestOTP(String phone) {
    return authApi.requestOTP(phone);
  }
}