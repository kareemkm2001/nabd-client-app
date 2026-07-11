import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/data/api/profile/profile_api.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';

import '../../core/error/failures.dart';
import '../models/profile/sub_user_model.dart';
import '../models/profile/update_profile_request.dart';

class ProfileUseCase {

  final ProfileApi profileApi ;

  ProfileUseCase({required this.profileApi});

  Future<Either<Failure, ProfileModel>> getProfile() async {
    return await profileApi.getProfile();
  }

  Future<Either<Failure, int>> updateProfileRequest(UpdateProfileRequest updateProfileRequest) async {
    return await profileApi.updateProfileRequest(updateProfileRequest);
  }

  Future<Either<Failure, List<SubUserModel>>> getSubUsers() async {
    return await profileApi.getSubUsers();
  }
}