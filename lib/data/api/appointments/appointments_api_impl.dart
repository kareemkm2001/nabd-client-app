import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/core/network/api_service.dart';
import 'package:nabd_client_app/data/api/appointments/appointments_api.dart';
import 'package:nabd_client_app/domain/models/appointment/AppointmentClinicServisesModel.dart';
import 'package:nabd_client_app/domain/models/appointment/appointment_model.dart';
import 'package:nabd_client_app/domain/models/appointment/clinic_times_response.dart';
import 'package:nabd_client_app/domain/models/appointment/clinics_res_model.dart';
import 'package:nabd_client_app/domain/models/appointment/create_normal_appointment_request.dart';
import 'package:nabd_client_app/domain/models/appointment/create_normal_appointment_response.dart';
import 'package:nabd_client_app/domain/models/appointment/package_for_clinic_model.dart';
import 'package:nabd_client_app/domain/models/appointment/slot_model.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/server_failure.dart';
import '../../../core/network/api_constants.dart';
import '../../../domain/models/appointment/appointment_data_model.dart';

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

  @override
  Future<Either<Failure, AppointmentDataModel>> getAppointmentById({required int id}) async {
    try {

      final response = await api.get("${ApiConstants.appointments}/show/$id");


      final model = response.data['data'];

      final appointment = AppointmentDataModel.fromJson(model);

      return Right(appointment);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.message}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClinicResModel>>> getClinics() async {
    try {

      final response = await api.get(ApiConstants.clinics);


      final List<dynamic> dataList = response.data['clinics'];

      final List<ClinicResModel> clinics = dataList
          .map<ClinicResModel>((e) => ClinicResModel.fromJson(e))
          .toList();

      return Right(clinics);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.message}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClinicServicesDataModel>> getClinicServicesById({required int clinicId}) async{
    try {

      final response = await api.get("${ApiConstants.services}$clinicId}");


      final model = response.data['data'];

      final clinicServicesDataModel = ClinicServicesDataModel.fromJson(model);

      return Right(clinicServicesDataModel);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.message}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClinicTimesResponse>>> getClinicTimes({required int clinicId, required String date, required int reservationType}) async {
    try {

      final response = await api.get(
          ApiConstants.clinicTime,
          query: {
            "clinic_id": clinicId,
            "dates": date,
            "reservation_type": reservationType,
          }
      );


      final List<dynamic> dataList = response.data['data']["times"];

      final List<ClinicTimesResponse> clinicTimes = dataList
          .map<ClinicTimesResponse>((e) => ClinicTimesResponse.fromJson(e))
          .toList();

      return Right(clinicTimes);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.message}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SlotModel>>> getSlots({required int clinicTimesId, required String date, required int clinicId, required int serviceId}) async {
    try {

      final response = await api.get(
          ApiConstants.slots,
          query: {
            "id": clinicTimesId,
            "dates": date,
            "clinic_id": clinicId,
            "service_id": serviceId,
          }
      );


      final List<dynamic> dataList = response.data['data']["slots"];

      final List<SlotModel> slots = dataList
          .map<SlotModel>((e) => SlotModel.fromJson(e))
          .toList();

      return Right(slots);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.message}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    ${e}");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PackageForClinicModel>>> getClinicPackagesById(int clinicId) async {
    try {

      final response = await api.get(
          ApiConstants.packagesClinic,
          query: {
            "id": clinicId,
          }
      );


      final List<dynamic> dataList = response.data['data']["packages"];

      final List<PackageForClinicModel> packages = dataList
          .map<PackageForClinicModel>((e) => PackageForClinicModel.fromJson(e))
          .toList();

      return Right(packages);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.message}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    $e");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getTaxInfo() async {
    try {

      final response = await api.get(ApiConstants.taxInfo,);


      final  String data = response.data['data']["tax_info"];



      return Right(data);

    }on DioException catch (e){
      print("مممممممممممممممم ${e.message}");
      return Left(ErrorHandler.handle(e));
    }catch (e){
      print("،ننننننننننننن    $e");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CreateNormalAppointmentResponse>> createNormalAppointment(CreateNormalAppointmentRequest createNormalAppointmentRequest) async{
    try {

      final response = await api.post(
        ApiConstants.createNormalAppointment,
        data: createNormalAppointmentRequest.toJson(),
      );

      print("حلة الطلب من api ${response.statusCode}");

      final  data = response.data['data']['booking'];

      final CreateNormalAppointmentResponse booking = CreateNormalAppointmentResponse.fromJson(data);

      return Right(booking);

    }on DioException catch (e){
      return Left(ErrorHandler.handle(e));
    }catch (e){
      return Left(ServerFailure(e.toString()));
    }
  }


}