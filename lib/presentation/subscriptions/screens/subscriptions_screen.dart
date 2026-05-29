import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/subscriptions/cubit/subscriptions_cubit.dart';
import 'package:nabd_client_app/presentation/subscriptions/cubit/subscriptions_state.dart';
import 'package:nabd_client_app/presentation/subscriptions/screens/subscription_details_page.dart';
import 'package:nabd_client_app/presentation/subscriptions/widgets/subscription_card.dart';
class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "الاشتراكات", isHome: true,),
      body: BlocBuilder<SubscriptionsCubit,SubscriptionsState>(
          builder: (context, state){
            if(state is GetSubscriptionsLoading){
              return Center(child: CircularProgressIndicator(),);
            }if(state is GetSubscriptionError){
              return Center(child: Text(state.errorMsg),);
            }if(state is GetSubscriptionSuc){
              return ListView.builder(
                  itemCount: state.subscriptions.length,
                  itemBuilder: (context,index){
                    return SubscriptionCard(
                        subscriptionModel: state.subscriptions[index],
                        onTap: (){
                          Navigator.push(
                              context,
                              AppRouteAnimation(page: SubscriptionDetailsPage(subscription: state.subscriptions[index],))
                          );
                        }
                    );
                  }
              );
            }
            return SizedBox();
          }
      ),
    );
  }
}

