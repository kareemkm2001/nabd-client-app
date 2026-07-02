import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import 'package:nabd_client_app/presentation/appointments/screens/date_time_step_screen.dart';


class ServiceStepScreen extends StatefulWidget {
  const ServiceStepScreen({super.key});

  @override
  State<ServiceStepScreen> createState() => _ServiceStepScreenState();
}

class _ServiceStepScreenState extends State<ServiceStepScreen> {


  @override
  void initState() {
    context.read<AppointmentsCubit>().getClinicServicesById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final appointmentsCubit = context.read<AppointmentsCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "الخدمات",),
      body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
        builder: (context, state) {
          final services =
              appointmentsCubit.clinicServicesData?.services ?? [];

          if (state is GetClinicServicesByIdLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (services.isEmpty) {
            return const Center(child: Text("لا توجد خدمات"));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "اختار خدمتك",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: services.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final service = services[index];

                      final isSelected =
                          appointmentsCubit.selectedServiceId == service.id;

                      final selectedType =
                      appointmentsCubit.serviceVisitType[service.id];

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                            width: isSelected ? 1 : 1,
                          ),
                          color: Colors.white,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            appointmentsCubit.selectService(id: service.id,price: service.price);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "${service.price} ريال",
                                            style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                    )
                                  ],
                                ),

                                /// ===== EXPANDED SECTION =====
                                if (isSelected) ...[
                                  const SizedBox(height: 12),

                                  const Divider(),

                                  const SizedBox(height: 8),

                                  if (service.visitType == 1) ...[
                                    Center(
                                      child: ChoiceChip(
                                        backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
                                        selectedColor: AppColors.primary,
                                        checkmarkColor: AppColors.surface,
                                        label: const Text("حضوري"),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        selected: true,
                                        onSelected: null,
                                      ),
                                    ),
                                  ] else if (service.visitType == 2) ...[
                                    Center(
                                      child: ChoiceChip(
                                        backgroundColor:
                                        AppColors.secondary.withValues(alpha: 0.5),
                                        selectedColor: AppColors.primary,
                                        checkmarkColor: AppColors.surface,
                                        label: const Text(
                                          "أونلاين",
                                          style: TextStyle(color: AppColors.surface),
                                        ),
                                        selected: true,
                                        onSelected: null,
                                      ),
                                    ),
                                  ] else ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ChoiceChip(
                                            backgroundColor:
                                            AppColors.secondary.withValues(alpha: 0.5),
                                            selectedColor: AppColors.primary,
                                            checkmarkColor: AppColors.surface,
                                            label: const Text(
                                              "حضوري",
                                              style: TextStyle(color: AppColors.surface),
                                            ),
                                            selected: selectedType == 1,
                                            onSelected: (_) {
                                              appointmentsCubit.selectVisitType(service.id, 1);
                                              print("النوع ${service.id}");
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ChoiceChip(
                                            backgroundColor:
                                            AppColors.secondary.withValues(alpha: 0.5),
                                            selectedColor: AppColors.primary,
                                            checkmarkColor: AppColors.surface,
                                            label: const Text(
                                              "أونلاين",
                                              style: TextStyle(color: AppColors.surface),
                                            ),
                                            selected: selectedType == 2,
                                            onSelected: (_) {
                                              appointmentsCubit.selectVisitType(service.id, 2);
                                              print("النوع ${service.id}");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  AppButton(
                                      titleKey: "حدد معادك",
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          AppRouteAnimation(page: DateTimeStepScreen())
                                        );
                                      }
                                  )
                                ],
                              ],
                            ),
                          ),
                        ),
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
