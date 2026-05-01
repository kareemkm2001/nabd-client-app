import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';

abstract class AuthApi{

  Future<Either<Failure ,String>> requestOTP(String numberPhone) ;

}