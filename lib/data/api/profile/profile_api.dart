import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/core/error/failures.dart';

abstract class ProfileApi {

  Future<Either<Failure , String>> getProfile() ;
}