import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';

abstract class ProfileApi {

  Future<Either<Failure , ProfileModel>> getProfile() ;
}