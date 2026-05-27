import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/utils/get_greeting.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/appointment_booking_widget.dart';
import '../widgets/subscription_booking_widget.dart';
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: AppText(
            jsonKey: "${getGreeting()}, كريم",
          textStyle: AppTextStyles.mediumBoldPrimary,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.png"),
          ),
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
