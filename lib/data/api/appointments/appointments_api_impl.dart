import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/core/network/api_service.dart';
import 'package:nabd_client_app/data/api/appointments/appointments_api.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/server_failure.dart';
import '../../../core/network/api_constants.dart';

class AppointmentsApiImpl implements AppointmentsApi {

  ApiService api ;

  AppointmentsApiImpl({required this.api}) ;

  @override
  Future<Either<Failure, List<AppointmentModel>>> getAppointments() async {
    try {

      final response = await api.get(ApiConstants.appointments);


      final List<dynamic> dataList = response.data['data'];

      final List<AppointmentModel> appointments = dataList
          .map<AppointmentModel>((e) => AppointmentModel.fromJson(e))
          .toList();

      return Right(appointments);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.message}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }
}