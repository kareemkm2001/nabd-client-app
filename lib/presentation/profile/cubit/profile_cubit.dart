import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';
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

  Future<void> loadSettings() async {
    biometricEnabled = await BiometricPrefs.isEnabled();

    final permission = await Permission.notification.status;
    notificationsEnabled = permission.isGranted;

    emit(ProfileSettingsLoaded());
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
      },
    );
  }
}
