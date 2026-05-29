import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/domain/models/subscriptions/subscriptions_response.dart';
import 'package:nabd_client_app/domain/usecases/subscriptions_use_case.dart';
import 'package:nabd_client_app/presentation/subscriptions/cubit/subscriptions_state.dart';

class SubscriptionsCubit  extends Cubit<SubscriptionsState> {
  final SubscriptionsUseCase subscriptionsUseCase ;

  SubscriptionsCubit({required this.subscriptionsUseCase}) : super(SubscriptionsInitial());

  List<SubscriptionModel> subscriptions = [];

  void getSubscriptions() async {
    emit(GetSubscriptionsLoading());

    final result = await subscriptionsUseCase.getSubscriptions();
    result.fold(
            (l){
          emit(GetSubscriptionError(errorMsg: l.message));
        },
            (r){
          emit(GetSubscriptionSuc(subscriptions: r));
        }
    );
  }
}