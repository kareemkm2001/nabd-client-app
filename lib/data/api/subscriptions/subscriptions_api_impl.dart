import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nabd_client_app/core/error/error_handler.dart';
import 'package:nabd_client_app/data/api/subscriptions/subscriptions_api.dart';
import 'package:nabd_client_app/domain/models/subscriptions/subscriptions_response.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../../../core/error/server_failure.dart';

class SubscriptionsApiImpl implements SubscriptionsApi{

  ApiService api ;

  SubscriptionsApiImpl({required this.api});

  @override
  Future<Either<Failure, List<SubscriptionModel>>> getSubscriptions() async {
    try {

      final response = await api.get(ApiConstants.subscriptions);


      final List<dynamic> dataList = response.data['data'];

      final List<SubscriptionModel> subscriptions = dataList
          .map<SubscriptionModel>((e) => SubscriptionModel.fromJson(e))
          .toList();

      return Right(subscriptions);

    }on DioException catch (e){
        print("مممممممممممممممم ${e.message}");
        return Left(ErrorHandler.handle(e));
      }catch (e){
        print("،ننننننننننننن    ${e}");
        return Left(ServerFailure(e.toString()));
    }
  }
}