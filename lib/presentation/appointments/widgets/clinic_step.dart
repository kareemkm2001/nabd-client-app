import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';

class ClinicStep extends StatelessWidget {
  const ClinicStep({super.key});

  @override
  Widget build(BuildContext context) {

    final appointmentsCubit = context.read<AppointmentsCubit>();

    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
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

        return ListView.separated(
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            clinic.name,
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
              ),
            );
          },
        );
      },
    );
  }
}