import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/screens/clinic_step_screen.dart';
import 'package:nabd_client_app/presentation/subscriptions/cubit/subscriptions_cubit.dart';
import 'package:nabd_client_app/presentation/subscriptions/cubit/subscriptions_state.dart';
import 'package:nabd_client_app/presentation/subscriptions/screens/subscription_details_page.dart';
import 'package:nabd_client_app/presentation/subscriptions/widgets/subscription_card.dart';

import '../../../core/widgets/custom_speed_dial.dart';
class SubscriptionsScreen extends StatelessWidget {
  SubscriptionsScreen({super.key});


  final ScrollController _scrollController = ScrollController();


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
                controller: _scrollController,
                  itemCount: state.subscriptions.length,
                  itemBuilder: (context,index){
                    return SubscriptionCard(
                        subscriptionModel: state.subscriptions[index],
                        onTap: (){
                          Navigator.push(
                              context,
                              AppRouteAnimation(page: SubscriptionDetailScreen(subscription: state.subscriptions[index],))
                          );
                        }
                    );
                  }
              );
            }
            return SizedBox();
          }
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

      floatingActionButton: CustomSpeedDial(
        scrollController: _scrollController,
        backgroundColor: AppColors.premium,
        children: [
          SpeedDialChild(
            backgroundColor: AppColors.premium,
            labelWidget: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.premium,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Text(
                  "اشتراك جديد",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            onTap: () {
              context.read<AppointmentsCubit>().actionType = "add_sub" ;
              Navigator.push(
                  context,
                  AppRouteAnimation(page: ClinicStepScreen())
              ).then((_){
                context.read<AppointmentsCubit>().resetAppointmentDataSelection();
              });
            },
          ),
        ],
      ),
    );
  }
}

