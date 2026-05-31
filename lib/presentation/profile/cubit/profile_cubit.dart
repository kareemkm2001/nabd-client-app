import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';
import 'package:nabd_client_app/domain/usecases/profile_use_case.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase profileUseCase;

  ProfileCubit({required this.profileUseCase}) : super(ProfileInitial());

  ProfileModel? profileModel;

  void getProfile() async {
    emit(GetProfileLoading());

    final result = await profileUseCase.getProfile();
    result.fold(
      (l) {
        emit(GetProfileError(errorMsg: l.message));
      },
      (r) {
        emit(GetProfilesSuc(profile: r));
      },
    );
  }
}
