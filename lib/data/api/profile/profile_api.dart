import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';
import 'package:nabd_client_app/domain/models/profile/update_profile_request.dart';

abstract class ProfileApi {

  Future<Either<Failure , ProfileModel>> getProfile() ;

  Future<Either<Failure,int>> updateProfileRequest(UpdateProfileRequest updateProfileRequest) ;
}