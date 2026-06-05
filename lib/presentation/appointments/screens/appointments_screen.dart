import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import 'package:nabd_client_app/presentation/appointments/screens/appointment_details_screen.dart';
import 'package:nabd_client_app/presentation/appointments/screens/create_normal_appointments_screen.dart';
import 'package:nabd_client_app/presentation/appointments/widgets/appointment_card.dart';

import '../../../core/widgets/custom_speed_dial.dart';

class AppointmentsScreen extends StatelessWidget {
  AppointmentsScreen({super.key});


  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "المواعيد", isHome: true,),
      body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
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

          final appointments =
              context.read<AppointmentsCubit>().appointments;

          return ListView.builder(
            controller: _scrollController,
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return AppointmentCard(
                appointment: appointments[index],
                onTap: () {
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
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

      floatingActionButton: CustomSpeedDial(
        scrollController: _scrollController,
        backgroundColor: AppColors.secondary,
        children: [
          SpeedDialChild(
            backgroundColor: AppColors.secondary,
            labelWidget: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Text(
                  "حجز موعد",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            onTap: () {
              Navigator.push(context, AppRouteAnimation(page: CreateNormalAppointmentsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
