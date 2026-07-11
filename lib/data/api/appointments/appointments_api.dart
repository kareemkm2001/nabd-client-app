import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';
import 'package:nabd_client_app/domain/models/appointment/clinics_res_model.dart';
import 'package:nabd_client_app/domain/models/appointment/create_normal_appointment_request.dart';
import 'package:nabd_client_app/domain/models/appointment/create_normal_appointment_response.dart';
import 'package:nabd_client_app/domain/models/appointment/slot_model.dart';

import '../../../domain/models/appointment/AppointmentClinicServisesModel.dart';
import '../../../domain/models/appointment/appointment_data_model.dart';
import '../../../domain/models/appointment/clinic_times_response.dart';
import '../../../domain/models/appointment/package_for_clinic_model.dart';

abstract class AppointmentsApi {

  Future<Either<Failure,List<AppointmentModel>>> getAppointments() ;


  Future<Either<Failure,AppointmentDataModel>> getAppointmentById({required int id}) ;

  Future<Either<Failure,List<ClinicResModel>>> getClinics() ;

  Future<Either<Failure,ClinicServicesDataModel>> getClinicServicesById({required int clinicId}) ;


  Future<Either<Failure,List<ClinicTimesResponse>>> getClinicTimes({required int clinicId , required String date ,required int reservationType});

  Future<Either<Failure , List<SlotModel>>> getSlots({required int clinicTimesId , required String date , required int clinicId , required int serviceId});

  Future<Either<Failure , List<PackageForClinicModel>>> getClinicPackagesById(int clinicId);

  Future<Either<Failure,String>> getTaxInfo() ;

  Future<Either<Failure,CreateNormalAppointmentResponse>> createNormalAppointment(CreateNormalAppointmentRequest createNormalAppointmentRequest) ;

}