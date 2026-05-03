import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/data/api/auth/auth_api.dart';
import 'package:nabd_client_app/data/api/profile/profile_api.dart';

import '../../core/error/failures.dart';

class ProfileUseCase {

  final ProfileApi profileApi ;

  ProfileUseCase({required this.profileApi});

  Future<Either<Failure, String>> getProfile() async {
    return await profileApi.getProfile();
  }
}