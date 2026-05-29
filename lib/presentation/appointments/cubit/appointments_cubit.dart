import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';
import 'package:nabd_client_app/domain/usecases/appointment_use_case.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';

class AppointmentsCubit  extends Cubit<AppointmentsState>{
  final AppointmentUseCase appointmentUseCase ;

  AppointmentsCubit({required this.appointmentUseCase}):super(AppointmentInitial());


  List<AppointmentModel> appointments = [] ;

  void getAppointments() async {
    emit(GetAppointmentLoading());

    final result = await appointmentUseCase.getAppointments();
    result.fold(
            (l){
          emit(GetAppointmentError(errorMsg: l.message));
        },
            (r){
          emit(GetAppointmentSuc(appointments: r));
        }
    );
  }

}