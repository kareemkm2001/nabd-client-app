import '../../../domain/models/profile/profile_model.dart';

class ProfileState {}

class ProfileInitial extends ProfileState {}


class GetProfilesSuc extends ProfileState {
  final ProfileModel profile ;

  GetProfilesSuc({required this.profile});
}

class GetProfileLoading extends ProfileState {}

class GetProfileError extends ProfileState {
  final String errorMsg ;

  GetProfileError({required this.errorMsg});
}

class ProfileSettingsLoaded extends ProfileState {}