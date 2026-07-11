import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/widgets/top_snackbar.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';
import 'package:nabd_client_app/domain/models/profile/update_profile_request.dart';
import 'package:nabd_client_app/domain/usecases/profile_use_case.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/biometric_service.dart';
import '../../../data/local/biometric_prefs.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase profileUseCase;

  ProfileCubit({required this.profileUseCase}) : super(ProfileInitial());

  ProfileModel? profileModel;

  bool biometricEnabled = false;
  bool notificationsEnabled = false;

  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final thirdNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fullNameEnController = TextEditingController();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  final mobileController = TextEditingController();
  final countryCodeController = TextEditingController();
  final proofController = TextEditingController();
  final telephoneController = TextEditingController();

  final birthdayController = TextEditingController();

  final addressController = TextEditingController();
  final notesController = TextEditingController();

  int gender = 1;
  int socialSituation = 1;
  int nationality = 1;
  int countryCode = 966 ;

  Future<void> loadSettings() async {
    biometricEnabled = await BiometricPrefs.isEnabled();

    final permission = await Permission.notification.status;
    notificationsEnabled = permission.isGranted;

    emit(ProfileSettingsLoaded());
  }

  void setIfNotNull(TextEditingController controller, String? value) {
    if (value != null) {
      controller.text = value;
    }
  }

  void resetState() {
    emit(ProfileInitial());
  }

  void fillController() {
    setIfNotNull(firstNameController, profileModel?.firstName);
    setIfNotNull(secondNameController, profileModel?.secondName);
    setIfNotNull(thirdNameController, profileModel?.thirdName);
    setIfNotNull(lastNameController, profileModel?.lastName);
    setIfNotNull(usernameController, profileModel?.username);
    setIfNotNull(emailController, profileModel?.email);
    setIfNotNull(fullNameEnController, profileModel?.fullNameEn);
    setIfNotNull(telephoneController, profileModel?.telephone);
    setIfNotNull(mobileController, profileModel?.mobile);
    setIfNotNull(proofController, profileModel?.proofNum);
    setIfNotNull(birthdayController, profileModel?.birthday);
    setIfNotNull(addressController, profileModel?.address);
    gender = int.tryParse(profileModel?.gender ?? '') ?? 1;
    socialSituation = int.tryParse(profileModel?.socialSituation ?? '') ?? 1;

    nationality = profileModel?.nationalityId ?? 1 ;

    countryCode = int.tryParse(profileModel?.contryCode ?? '') ?? 966;
  }

  Future<bool> toggleBiometric(bool value) async {
    if (value) {
      final success = await BiometricService.authenticate();

      if (!success) {
        return false;
      }

      await BiometricPrefs.setEnabled(true);
      biometricEnabled = true;
    } else {
      await BiometricPrefs.setEnabled(false);
      biometricEnabled = false;
    }

    emit(ProfileSettingsLoaded());
    return true;
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      final status = await Permission.notification.request();

      notificationsEnabled = status.isGranted;
    } else {
      await openAppSettings();
      notificationsEnabled = false;
    }

    emit(ProfileSettingsLoaded());
  }

  void getProfile() async {
    emit(GetProfileLoading());

    final result = await profileUseCase.getProfile();
    result.fold(
      (l) {
        emit(GetProfileError(errorMsg: l.message));
      },
      (r) {
        print("الملف الشخصي ${r.toJson()}");
        emit(GetProfilesSuc(profile: r));
        profileModel = r ;
      },
    );
  }

  void updateProfile(BuildContext context) async {
    emit(UpdateProfileLoading());

    final UpdateProfileRequest updateProfileRequest = UpdateProfileRequest(
      id: profileModel?.id,
      firstName: firstNameController.text,
      secondName: secondNameController.text,
      thirdName: thirdNameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
      fullNameEn: fullNameEnController.text,
      proofNum: proofController.text,
      email: emailController.text,
      mobile: int.tryParse(mobileController.text),
      telephone: int.tryParse(telephoneController.text),
      contryCode: countryCode ,
      birthday: birthdayController.text,
      gender: gender,
      socialSituation: socialSituation,
      notes: notesController.text,
      address: addressController.text,
      nationalityId: nationality
    );
    
    print("الريكوست ${updateProfileRequest.toJson()}");

    final result = await profileUseCase.updateProfileRequest(updateProfileRequest);
    
    result.fold(
        (l){
          print("المشكله ${l.message}") ;
          showAppSnackBarError(context: context, message: l.message);
        },
        (r){
          showAppSnackBarSuc(context: context, message: "تم تحديث بيانتك");
          print("حالة الطلب ${r}");
          getProfile();
          Navigator.pop(context);

        }
    );
  }

  void getSubUsers() async {
    emit(GetSubUsersLoading());

    final result = await profileUseCase.getSubUsers();
    
    result.fold(
        (l){
          emit(GetSubUsersError(errorMsg: l.message));
        },
        (r){
          emit(GetSubUsersSuc(subUsers: r));
        }
    );

  }
}
