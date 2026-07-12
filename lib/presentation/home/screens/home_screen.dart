import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/utils/get_greeting.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:nabd_client_app/presentation/home/widgets/home_clinic_card.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_cubit.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';
import 'package:nabd_client_app/presentation/profile/screens/notifications_screen.dart';
import 'package:nabd_client_app/presentation/profile/screens/update_profile_screen.dart';

import '../../../../core/theme/app_colors.dart';
import '../../appointments/cubit/appointments_cubit.dart';
import '../../appointments/cubit/appointments_state.dart';
import '../../appointments/screens/appointment_details_screen.dart';
import '../../appointments/widgets/appointment_card.dart';
import '../../appointments/widgets/appointment_confirm_card.dart';
import '../widgets/appointment_booking_widget.dart';
import '../widgets/subscription_booking_widget.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


   @override
  Widget build(BuildContext context) {

     final profileCubit = context.read<ProfileCubit>() ;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: BlocBuilder<ProfileCubit,ProfileState>(
            builder: (context , state){
              return AppText(
                jsonKey: "${getGreeting()}, ${profileCubit.profileModel?.firstName ?? "_"}",
                textStyle: AppTextStyles.mediumBoldPrimary,
              );
            }

        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
                onPressed: (){
                  Navigator.push(context, AppRouteAnimation(page: NotificationsScreen()));
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
                      jsonKey: "المواعيد الغير مؤكدة",
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
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background
              ),
              height: 250,
              child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
                builder: (context, state) {
                  if (state is GetAppointmentLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is GetAppointmentError) {
                    return Center(
                      child: Text(state.errorMsg),
                    );
                  }

                  final appointments = context.read<AppointmentsCubit>().appointments.where((e) => e.confirmed == "غير مؤكد").toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      return AppointmentConfirmCard(
                        clinicName: appointments[index].clinic.name,
                        doctorName: appointments[index].clinic.doctor.fullName,
                        appointmentDate: appointments[index].date,
                        appointmentTime: appointments[index].fromTime,
                        isConfirmed: false,
                        onConfirm: () {
                          // API Confirm
                        },
                        onTap: () {
                          print(appointments[index].confirmed);
                          Navigator.push(
                            context,
                            AppRouteAnimation(
                              page: AppointmentDetailsScreen(
                                appointmentId: appointments[index].id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
            SubscriptionBookingWidget(),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.background
              ),
              height: 250,
              child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
                builder: (context, state) {
                  final clinics = context.read<AppointmentsCubit>().clinics;

                  print(clinics.length);

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: clinics.length,
                    itemBuilder: (context, index) {
                      return HomeClinicCard(
                        clinicName: clinics[index].name,
                        doctorName: clinics[index].doctorName,
                        label: clinics[index].label,
                        rating: 4.8,
                        onTap: () {},
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      )
    );
  }
}
