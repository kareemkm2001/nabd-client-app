import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/data/api/appointments/appointments_api.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';

import '../../core/error/failures.dart';
import '../models/appointment/AppointmentClinicServisesModel.dart';
import '../models/appointment/appointment_data_model.dart';
import '../models/appointment/clinics_res_model.dart';

class AppointmentUseCase {

  final AppointmentsApi appointmentsApi ;

  AppointmentUseCase({required this.appointmentsApi});

  Future<Either<Failure,List<AppointmentModel>>> getAppointments() async {
    return await appointmentsApi.getAppointments();
  }

  Future<Either<Failure,AppointmentDataModel>> getAppointmentById({required int id}) async {
    return await appointmentsApi.getAppointmentById(id: id);
  }

  Future<Either<Failure,List<ClinicResModel>>> getClinics() async {
    return await appointmentsApi.getClinics();
  }

  Future<Either<Failure,ClinicServicesDataModel>> getClinicServicesById({required int clinicId}) async {
    return await appointmentsApi.getClinicServicesById(clinicId: clinicId);
  }
}