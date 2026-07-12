import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/error/error_handler.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/core/error/server_failure.dart';
import 'package:nabd_client_app/core/network/api_constants.dart';
import 'package:nabd_client_app/core/network/api_service.dart';
import 'package:nabd_client_app/data/api/profile/profile_api.dart';
import 'package:nabd_client_app/domain/models/profile/notifications_model.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';
import 'package:nabd_client_app/domain/models/profile/sub_user_model.dart';
import 'package:nabd_client_app/domain/models/profile/update_profile_request.dart';

class ProfileApiImpl implements ProfileApi {

  ApiService api ;
  ProfileApiImpl({required this.api});

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {

    try {

      final response = await api.get(ApiConstants.profile);


      final  data = response.data['data']['user'];

      final ProfileModel profile = ProfileModel.fromJson(data);

      return Right(profile);

    }on DioException catch (e){
      return Left(ErrorHandler.handle(e));
    }catch (e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> updateProfileRequest(UpdateProfileRequest updateProfileRequest) async {
    try {

      final response = await api.put(
        ApiConstants.updateProfile,
        data: updateProfileRequest.toJson(),
      );

      print("حلة الطلب من api ${response.statusCode}");

      return Right(response.statusCode ?? 200);

    }on DioException catch (e){
      return Left(ErrorHandler.handle(e));
    }catch (e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubUserModel>>> getSubUsers() async {
    try {

      final response = await api.get(ApiConstants.subUsers);

      final subUsers = SubUserModel.fromJsonList(response.data["data"]);

      return Right(subUsers);

    }on DioException catch (e){
      return Left(ErrorHandler.handle(e));
    }catch (e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationsModel>>> getNotifications() async {
    try {

      final response = await api.get(ApiConstants.notifications);

      final List<dynamic> dataList = response.data['data']["notifications"]["data"];


      final List<NotificationsModel> notifications = dataList
          .map<NotificationsModel>((e) => NotificationsModel.fromJson(e))
          .toList();

      print("الشكل ${notifications[0]}");

      return Right(notifications);

    }on DioException catch (e){
      return Left(ErrorHandler.handle(e));
    }catch (e){
      return Left(ServerFailure(e.toString()));
    }
  }


}