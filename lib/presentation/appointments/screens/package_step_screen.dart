import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import 'package:nabd_client_app/presentation/appointments/screens/date_time_step_screen.dart';
import 'package:nabd_client_app/presentation/appointments/screens/payment_step_screen.dart';

class PackageStepScreen extends StatefulWidget {
  const PackageStepScreen({super.key});

  @override
  State<PackageStepScreen> createState() => _PackageStepScreenState();
}

class _PackageStepScreenState extends State<PackageStepScreen> {

  @override
  void initState() {
    context.read<AppointmentsCubit>().getClinicPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final appointmentsCubit = context.read<AppointmentsCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "الاشتركات"),
      body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
        builder: (context, state) {

          final packages = appointmentsCubit.packagesClinic?.where((p) => p.show == 1).toList();

          if (state is GetClinicPackagesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (packages?.isEmpty ?? false) {
            return const Center(
              child: Text("لا توجد اشتراكات متاحة"),
            );
          }

          return Column(
            children: [

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: packages?.length,
                  itemBuilder: (context, index) {

                    final package = packages?[index];

                    final isSelected =
                        appointmentsCubit.selectedPackageId ==
                            package?.id;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        appointmentsCubit
                            .selectPackage(id: package!.id , price: package.price.toDouble());
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context)
                                .colorScheme
                                .primary
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
                                        package?.name ?? "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        "${package?.numberOfSessions} جلسة",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "${package?.price} ريال",
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "سعر الجلسة ${package?.sessionPrice} ريال",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  isSelected
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                              ],
                            ),

                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              child: isSelected
                                  ? Column(
                                children: [

                                  const SizedBox(height: 12),

                                  const Divider(),

                                  const SizedBox(height: 12),

                                  SizedBox(
                                    width: double.infinity,
                                    child: AppButton(
                                      titleKey: "الذهاب لصفحة الدفع",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          AppRouteAnimation(
                                            page: const PaymentStepScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}