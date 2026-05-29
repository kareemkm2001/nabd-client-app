import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/domain/models/subscriptions/subscriptions_response.dart';

import '../../../core/error/failures.dart';

abstract class SubscriptionsApi {

  Future<Either<Failure,List<SubscriptionModel>>> getSubscriptions() ;
}