import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';

class AppointmentsState {}

class AppointmentInitial  extends AppointmentsState {}

class GetAppointmentSuc extends AppointmentsState {
  final List<AppointmentModel> appointments ;

  GetAppointmentSuc({required this.appointments});
}

class GetAppointmentLoading extends AppointmentsState {}

class GetAppointmentError extends AppointmentsState {
  final String errorMsg ;

  GetAppointmentError({required this.errorMsg});
}
