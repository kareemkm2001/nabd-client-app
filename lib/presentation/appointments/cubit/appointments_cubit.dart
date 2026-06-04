import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_data_model.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';
import 'package:nabd_client_app/domain/usecases/appointment_use_case.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';

class AppointmentsCubit  extends Cubit<AppointmentsState>{
  final AppointmentUseCase appointmentUseCase ;

  AppointmentsCubit({required this.appointmentUseCase}):super(AppointmentInitial());


  List<AppointmentModel> appointments = [] ;
  AppointmentDataModel? appointmentDataModel ;

  void getAppointments() async {
    emit(GetAppointmentLoading());

    final result = await appointmentUseCase.getAppointments();
    result.fold(
            (l){
          emit(GetAppointmentError(errorMsg: l.message));
        },
            (r){
              appointments = r ;
          emit(GetAppointmentSuc(appointments: r));
        }
    );
  }

  void getAppointmentById({required int id}) async {
    emit(GetAppointmentByIdLoading());

    final result = await appointmentUseCase.getAppointmentById(id: id);
    result.fold(
            (l){
          emit(GetAppointmentByIdError(errorMsg: l.message));
        },
            (r){
              appointmentDataModel = r ;
              print("تفاصيل المعاد ${appointmentDataModel}");
          emit(GetAppointmentByIdSuc(appointment: r));
        }
    );
  }

}