import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_stepper/stepper.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';

import '../widgets/clinic_step.dart';
import '../widgets/date_time_step.dart';
import '../widgets/payment_step.dart';
import '../widgets/service_step.dart';

class CreateNormalAppointmentsScreen extends StatefulWidget {
  const CreateNormalAppointmentsScreen({super.key});

  @override
  State<CreateNormalAppointmentsScreen> createState() => _CreateNormalAppointmentsScreenState();
}

class _CreateNormalAppointmentsScreenState extends State<CreateNormalAppointmentsScreen> {


  @override
  void initState() {
    context.read<AppointmentsCubit>().getClinics();
    super.initState();
  }

  final List<String> titles = [
    "العيادة",
    "الخدمة",
    "الموعد",
    "الدفع",
  ];

  @override
  Widget build(BuildContext context) {

    final appointmentsCubit = context.read<AppointmentsCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        titleKey: "حجز موعد",
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          IconStepper(
            stepColor: AppColors.secondary.withValues(alpha: 0.5),
            lineColor: AppColors.secondary.withValues(alpha: 0.5),
            activeStepColor: AppColors.primary,
            activeStepBorderColor: AppColors.primary,
            activeStep: appointmentsCubit.activeStep,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            icons:  [
              Icon(Icons.local_hospital,color: AppColors.surface,),
              Icon(Icons.medical_services,color: AppColors.surface,),
              Icon(Icons.calendar_month,color: AppColors.surface,),
              Icon(Icons.payment,color: AppColors.surface,)
            ],
          ),

          const SizedBox(height: 12),

          if(appointmentsCubit.activeStep != 0)
            IconButton(
                onPressed: (){
                  setState(() {
                    appointmentsCubit.activeStep-- ;
                    appointmentsCubit.clinicServicesData = null ;
                  });
                },
                icon: Icon(Icons.arrow_back)
            ),
          Text(
            titles[appointmentsCubit.activeStep],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: IndexedStack(
              index: appointmentsCubit.activeStep,
              children: const [
                ClinicStep(),
                ServiceStep(),
                DateTimeStep(),
                PaymentStep(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (){
              setState(() {
                appointmentsCubit.onNextPressed(context);
              });
            },
            child: Text(appointmentsCubit.getButtonTitle()),
          ),
        ),
      ),
    );
  }
}