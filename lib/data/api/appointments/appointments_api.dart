import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';
import 'package:nabd_client_app/domain/models/appointment/clinics_res_model.dart';

import '../../../domain/models/appointment/AppointmentClinicServisesModel.dart';
import '../../../domain/models/appointment/appointment_data_model.dart';

abstract class AppointmentsApi {

  Future<Either<Failure,List<AppointmentModel>>> getAppointments() ;


  Future<Either<Failure,AppointmentDataModel>> getAppointmentById({required int id}) ;

  Future<Either<Failure,List<ClinicResModel>>> getClinics() ;

  Future<Either<Failure,ClinicServicesDataModel>> getClinicServicesById({required int clinicId}) ;
}