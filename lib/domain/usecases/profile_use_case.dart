import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/data/api/auth/auth_api.dart';
import 'package:nabd_client_app/data/api/profile/profile_api.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';

import '../../core/error/failures.dart';

class ProfileUseCase {

  final ProfileApi profileApi ;

  ProfileUseCase({required this.profileApi});

  Future<Either<Failure, ProfileModel>> getProfile() async {
    return await profileApi.getProfile();
  }
}