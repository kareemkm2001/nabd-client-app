import 'package:dartz/dartz.dart';
import 'package:nabd_client_app/data/api/subscriptions/subscriptions_api.dart';

import '../../core/error/failures.dart';
import '../models/subscriptions/subscriptions_response.dart';

class SubscriptionsUseCase {
  final SubscriptionsApi subscriptionsApi ;

  SubscriptionsUseCase({required this.subscriptionsApi});

  Future<Either<Failure, List<SubscriptionModel>>> getSubscriptions() async {
    return subscriptionsApi.getSubscriptions();
  }
}