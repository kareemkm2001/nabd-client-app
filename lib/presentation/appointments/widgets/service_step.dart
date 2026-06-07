import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';

class ServiceStep extends StatelessWidget {
  const ServiceStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentsCubit>();

    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        final services =
            cubit.clinicServicesData?.services ?? [];

        if (state is GetClinicServicesByIdLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (services.isEmpty) {
          return const Center(child: Text("لا توجد خدمات"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final service = services[index];

            final isSelected =
                cubit.selectedServiceId == service.id;

            final selectedType =
            cubit.serviceVisitType[service.id];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                color: Colors.white,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  cubit.selectService(service.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ===== MAIN ROW =====
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

                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
                                surfaceTintColor: AppColors.secondary,
                                checkmarkColor: AppColors.surface,
                                selectedColor: AppColors.primary,
                                label:  Text("حضوري",style: TextStyle(color: AppColors.surface),),
                                selected: selectedType == 1,
                                onSelected: (_) {
                                  cubit.selectVisitType(
                                      service.id, 1);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ChoiceChip(
                                disabledColor: AppColors.surface,
                                backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
                                surfaceTintColor: AppColors.secondary,
                                checkmarkColor: AppColors.surface,
                                selectedColor: AppColors.primary,
                                label: const Text("أونلاين",style: TextStyle(color: AppColors.surface),),
                                selected: selectedType == 2,
                                onSelected: (_) {
                                  cubit.selectVisitType(
                                      service.id, 2);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}