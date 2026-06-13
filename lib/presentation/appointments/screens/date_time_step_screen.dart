import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import 'package:nabd_client_app/presentation/appointments/screens/payment_step_screen.dart';

import '../../../core/widgets/custom_calendar_widget.dart';

class DateTimeStepScreen extends StatefulWidget {
  const DateTimeStepScreen({super.key});

  @override
  State<DateTimeStepScreen> createState() => _DateTimeStepScreenState();
}

class _DateTimeStepScreenState extends State<DateTimeStepScreen> {
  @override
  Widget build(BuildContext context) {
    final appointmentsCubit = context.read<AppointmentsCubit>();

    return Scaffold(
      appBar: AppAppBar(titleKey: "المواعيد"),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                "اختار معادك",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// ===== CALENDAR =====
              CustomCalendarWidget(
                onTap: (date) {
                  appointmentsCubit.getClinicTimes();
                },
              ),

              const SizedBox(height: 20),

              /// ===== PERIODS + SLOTS =====
              BlocBuilder<AppointmentsCubit, AppointmentsState>(
                buildWhen: (prev, curr) =>
                curr is GetClinicTimesLoading ||
                    curr is GetClinicTimesSuc ||
                    curr is GetClinicTimesError ||
                    curr is PeriodSelectedState ||
                    curr is GetSlotsLoading ||
                    curr is GetSlotsSuc,
                builder: (context, state) {
                  if (state is GetClinicTimesLoading) {
                    return const CircularProgressIndicator();
                  }

                  if (state is GetClinicTimesError) {
                    return Text(state.errorMsg);
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointmentsCubit.clinicTimes?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = appointmentsCubit.clinicTimes![index];

                      final isExpanded =
                          appointmentsCubit.selectedPeriodId == item.id;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isExpanded
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            /// ===== PERIOD HEADER =====
                            InkWell(
                              onTap: () {
                                appointmentsCubit.selectPeriod(item.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.period ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isExpanded
                                            ? AppColors.primary
                                            : Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                    )
                                  ],
                                ),
                              ),
                            ),

                            /// ===== SLOTS =====
                            if (isExpanded)
                              if(state is GetSlotsLoading)
                                Padding(
                                    padding: EdgeInsetsGeometry.symmetric(horizontal: 20,vertical: 20),
                                  child: LinearProgressIndicator(
                                    color: AppColors.primary,
                                    backgroundColor: AppColors.background,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              else if(state is GetSlotsError)
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Icon(Icons.error_rounded),
                                )
                              else if(appointmentsCubit.slots!.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text("لا توجد مواعيد"),
                                )

                              else Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        bottom: 12),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: (appointmentsCubit.slots ?? [])
                                          .map(
                                            (slot) => GestureDetector(
                                          onTap: () {
                                          },
                                          child: Container(
                                            padding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: slot.appointment
                                                  ? Colors.red
                                                  .withOpacity(0.1)
                                                  : AppColors.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                              BorderRadius.circular(20),
                                              border: Border.all(
                                                color: slot.appointment
                                                    ? Colors.red
                                                    : AppColors.primary,
                                              ),
                                            ),
                                            child: Text(
                                              "${slot.fromTime} - ${slot.toTime}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: slot.appointment
                                                    ? Colors.red
                                                    : AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    ),
                                  ),

                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              /// ===== BUTTON =====
              AppButton(
                margin: 0,
                titleKey: "الذهاب الي الدفع",
                onTap: () {
                  Navigator.push(
                    context,
                    AppRouteAnimation(
                      page: const PaymentStepScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}