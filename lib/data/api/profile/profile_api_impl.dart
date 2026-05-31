import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/error/error_handler.dart';
import 'package:nabd_client_app/core/error/failures.dart';
import 'package:nabd_client_app/core/error/server_failure.dart';
import 'package:nabd_client_app/core/network/api_constants.dart';
import 'package:nabd_client_app/core/network/api_service.dart';
import 'package:nabd_client_app/data/api/profile/profile_api.dart';
import 'package:nabd_client_app/domain/models/profile/profile_model.dart';

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


}