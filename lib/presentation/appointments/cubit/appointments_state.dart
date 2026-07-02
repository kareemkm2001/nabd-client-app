import 'package:nabd_client_app/domain/models/appointment/appointment_data_model.dart';
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



class GetAppointmentByIdSuc extends AppointmentsState {
  final AppointmentDataModel appointment ;

  GetAppointmentByIdSuc({required this.appointment});
}

class AppointmentStepChanged extends AppointmentsState {}

class GetAppointmentByIdLoading extends AppointmentsState {}

class GetAppointmentByIdError extends AppointmentsState {
  final String errorMsg ;

  GetAppointmentByIdError({required this.errorMsg});
}

class GetClinicsError extends AppointmentsState {
  final String errorMsg ;
  GetClinicsError({required this.errorMsg});
}

class GetClinicsLoading extends AppointmentsState {}

class GetClinicsSuc extends AppointmentsState {}

class ClinicSelected extends AppointmentsState {}
class ServiceSelectedState extends AppointmentsState {}
class ServiceVisitTypeChanged extends AppointmentsState {}
class SlotsLoadedState extends AppointmentsState {}
class SlotSelectedState extends AppointmentsState {}
class PaymentMethodChangedState extends AppointmentsState {}
class AppointmentsDateSelected extends AppointmentsState {}
class PeriodSelectedState extends AppointmentsState {}
class PackageSelectedState extends AppointmentsState {}
class AppointmentsSlotSelectedState extends AppointmentsState {}

class GetClinicServicesByIdSuc extends AppointmentsState {}

class GetClinicServicesByIdError extends AppointmentsState {
  final String errorMsg ;
  GetClinicServicesByIdError({required this.errorMsg});
}

class GetClinicServicesByIdLoading extends AppointmentsState {}
class GetSlotsLoading extends AppointmentsState {}
class GetSlotsError extends AppointmentsState {
  final String errorMsg ;
  GetSlotsError({required this.errorMsg});
}
class GetSlotsSuc extends AppointmentsState {}

class GetClinicTimesLoading extends AppointmentsState{}
class GetClinicTimesSuc extends AppointmentsState{}
class GetClinicTimesError extends AppointmentsState{
  final String errorMsg ;
  GetClinicTimesError({required this.errorMsg});
}


class GetClinicPackagesLoading extends AppointmentsState{}
class GetClinicPackagesSuc extends AppointmentsState{}
class GetClinicPackagesError extends AppointmentsState{
  final String errorMsg ;
  GetClinicPackagesError({required this.errorMsg});
}

class GetTaxIngoLoaded extends AppointmentsState {}



