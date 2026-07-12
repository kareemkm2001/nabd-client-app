import 'package:nabd_client_app/domain/models/profile/sub_user_model.dart';

import '../../../domain/models/profile/notifications_model.dart';
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

class UpdateProfileLoading extends ProfileState {}
class UpdateProfileError extends ProfileState {
  final String errorMsg ;
  UpdateProfileError({required this.errorMsg}) ;
}
class UpdateProfileSuc extends ProfileState {}

class GetSubUsersLoading extends ProfileState {}
class GetSubUsersError extends ProfileState {
  final String errorMsg ;
  GetSubUsersError({required this.errorMsg});

}
class GetSubUsersSuc extends ProfileState {
  final List<SubUserModel> subUsers ;
  GetSubUsersSuc({required this.subUsers});
}


class GetNotificationsLoading extends ProfileState {}
class GetNotificationsError extends ProfileState {
  final String errorMsg ;
  GetNotificationsError({required this.errorMsg});

}
class GetNotificationsSuc extends ProfileState {
  final List<NotificationsModel> notifications ;
  GetNotificationsSuc({required this.notifications});
}