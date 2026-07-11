import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/data/api/appointments/appointments_api.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';

import '../../core/error/failures.dart';
import '../models/appointment/AppointmentClinicServisesModel.dart';
import '../models/appointment/appointment_data_model.dart';
import '../models/appointment/clinic_times_response.dart';
import '../models/appointment/clinics_res_model.dart';
import '../models/appointment/create_normal_appointment_request.dart';
import '../models/appointment/create_normal_appointment_response.dart';
import '../models/appointment/package_for_clinic_model.dart';
import '../models/appointment/slot_model.dart';

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

  Future<Either<Failure,List<ClinicTimesResponse>>> getClinicTimes({required int clinicId , required String date ,required int reservationType}) async {
    return await appointmentsApi.getClinicTimes(clinicId: clinicId, date: date, reservationType: reservationType);
  }

  Future<Either<Failure, List<SlotModel>>> getSlots({required int clinicTimesId, required String date, required int clinicId, required int serviceId}) async {
    return await appointmentsApi.getSlots(clinicTimesId: clinicTimesId, date: date, clinicId: clinicId, serviceId: serviceId);
  }

  Future<Either<Failure, List<PackageForClinicModel>>> getClinicPackagesById(int clinicId) async {
    return await appointmentsApi.getClinicPackagesById(clinicId);
  }

  Future<Either<Failure, String>> getTaxInfo() async {
    return await appointmentsApi.getTaxInfo();
  }

  Future<Either<Failure,CreateNormalAppointmentResponse>> createNormalAppointment(CreateNormalAppointmentRequest createNormalAppointmentRequest) async {
    return await appointmentsApi.createNormalAppointment(createNormalAppointmentRequest);
  }
}