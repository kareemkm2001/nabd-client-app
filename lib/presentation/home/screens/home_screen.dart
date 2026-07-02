import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/utils/get_greeting.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_cubit.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';
import 'package:nabd_client_app/presentation/profile/screens/update_profile_screen.dart';

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
      body: SingleChildScrollView(
        child: Column (
          children: [
            SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.all(18),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xffFFF4E5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xffFFD8A8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xffFFE8CC),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "اكمل بيانات حسابك",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 12),
        
                  const Text(
                    "تبقى خطوة واحدة فقط!\nاستكمل بياناتك الشخصية حتى تتمكن من حجز المواعيد والاستفادة من جميع خدمات التطبيق.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
        
                  const SizedBox(height: 18),
        
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            AppRouteAnimation(page: UpdateProfileScreen())
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text("إكمال البيانات"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        ),
      )
    );
  }
}
