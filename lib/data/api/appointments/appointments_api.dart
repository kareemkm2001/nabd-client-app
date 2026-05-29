import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';

abstract class AppointmentsApi {

  Future<Either<Failure,List<AppointmentModel>>> getAppointments() ;
}