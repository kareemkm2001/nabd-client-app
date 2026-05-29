import 'package:nabd_client_app/domain/models/subscriptions/subscriptions_response.dart';

class SubscriptionsState {}

class SubscriptionsInitial  extends SubscriptionsState {}


class GetSubscriptionSuc extends SubscriptionsState {
  final List<SubscriptionModel> subscriptions ;

  GetSubscriptionSuc({required this.subscriptions});
}

class GetSubscriptionsLoading extends SubscriptionsState {}

class GetSubscriptionError extends SubscriptionsState {
  final String errorMsg ;

  GetSubscriptionError({required this.errorMsg});
}
