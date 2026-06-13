import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import 'package:nabd_client_app/presentation/appointments/screens/package_step_screen.dart';
import 'package:nabd_client_app/presentation/appointments/screens/service_step_screen.dart';

class ClinicStepScreen extends StatefulWidget {
  const ClinicStepScreen({super.key});

  @override
  State<ClinicStepScreen> createState() => _ClinicStepScreenState();
}

class _ClinicStepScreenState extends State<ClinicStepScreen> {


  @override
  void initState() {
    context.read<AppointmentsCubit>().getClinics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final appointmentsCubit = context.read<AppointmentsCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "العيادات",),
      body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
        builder: (context, state) {
          if (state is GetClinicsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetClinicsError) {
            return Center(
              child: Text(state.errorMsg),
            );
          }

          final clinics = appointmentsCubit.clinics;

          if (clinics.isEmpty) {
            return const Center(
              child: Text('لا توجد عيادات متاحة'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "اختار معادك",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: clinics.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final clinic = clinics[index];

                      final isSelected =
                          appointmentsCubit.selectedClinicId == clinic.id;

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          appointmentsCubit.selectClinic(clinic.id);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isSelected
                                ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.08)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${clinic.name} ${clinic.id}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          clinic.doctorName.trim().isEmpty
                                              ? 'غير محدد'
                                              : clinic.doctorName,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                  ),
                                ],
                              ),

                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: isSelected
                                    ? Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AppButton(
                                          onTap: (){
                                            if(appointmentsCubit.actionType == "normal"){
                                              Navigator.push(
                                                  context,
                                                  AppRouteAnimation(page: ServiceStepScreen())
                                              );
                                            }
                                            if(appointmentsCubit.actionType == "add_sub"){
                                              Navigator.push(
                                                  context,
                                                  AppRouteAnimation(page: PackageStepScreen())
                                              );
                                            }

                                          },
                                        titleKey: appointmentsCubit.actionType == "normal" ? "الذهاب الي الخدمات" : "الذهاب الي الاشتراكات",
                                      )
                                    ),
                                  ],
                                )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
