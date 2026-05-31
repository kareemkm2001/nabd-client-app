import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/utils/get_greeting.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_cubit.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/appointment_booking_widget.dart';
import '../widgets/subscription_booking_widget.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: BlocBuilder<ProfileCubit,ProfileState>(
            builder: (context , state){
              if(state is GetProfilesSuc){
                return AppText(
                  jsonKey: "${getGreeting()}, ${state.profile.firstName}",
                  textStyle: AppTextStyles.mediumBoldPrimary,
                );
              }
              return AppText(
                  jsonKey: "${getGreeting()}, _ ",
              textStyle: AppTextStyles.mediumBoldPrimary
              );
            }

        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
                onPressed: (){

                },
                icon: Icon(
                  Icons.notifications,
                  color: AppColors.primary,
                ),
            ),
          )
        ],
      ),
      body: Column (
        children: [
          AppointmentBookingWidget(),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                AppText(
                    jsonKey: "المواعيد القادمة",
                    textStyle: AppTextStyles.mediumPrimary,
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){

                  },
                  child: AppText(
                    jsonKey: "عرض الكل",
                    textStyle: AppTextStyles.smallPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 200,),
          SizedBox(height: 10,),
          SubscriptionBookingWidget(),
          SizedBox(),
        ],
      )
    );
  }
}
