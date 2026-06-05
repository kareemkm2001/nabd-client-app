import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/appointments/screens/payment_view_sceen.dart';

class CreateNormalAppointmentsScreen extends StatefulWidget {
  const CreateNormalAppointmentsScreen({super.key});

  @override
  State<CreateNormalAppointmentsScreen> createState() => _CreateNormalAppointmentsScreenState();
}

class _CreateNormalAppointmentsScreenState extends State<CreateNormalAppointmentsScreen> {

  int activeStep = 0;

  final List<String> titles = [
    "العيادة",
    "الخدمة",
    "الموعد",
    "الدفع",
  ];

  @override
  Widget build(BuildContext context) {
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
            activeStep: activeStep,
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

          Text(
            titles[activeStep],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: IndexedStack(
              index: activeStep,
              children: const [
                _ClinicStep(),
                _ServiceStep(),
                _DateTimeStep(),
                _PaymentStep(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: activeStep == 0
            ? SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                activeStep++;
              });
            },
            child: const Text(
              "التالي",
            ),
          ),
        )
            : Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      activeStep--;
                    });
                  },
                  child: const Text(
                    "السابق",
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (activeStep < 3) {
                      setState(() {
                        activeStep++;
                      });
                    } else {
                      Navigator.push(context, AppRouteAnimation(page: PaymentViewScreen(paymentUrl: "https://checkout.tap.company/?mode=page&themeMode=&language=en&token=eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjZhMjM0YTkyMzE2OGM1M2QyYzUwYTM4YiJ9.CYZlHfxJvAUrjzZ81IuTwIqpVLhRQJOyvA82y4EvSUw")));
                    }
                  },
                  child: Text(
                    activeStep == 3
                        ? "إتمام عملية الدفع"
                        : "التالي",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClinicStep extends StatelessWidget {
  const _ClinicStep();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("اختيار العيادة"),
    );
  }
}

class _ServiceStep extends StatelessWidget {
  const _ServiceStep();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("اختيار الخدمة ونوع الحجز"),
    );
  }
}

class _DateTimeStep extends StatelessWidget {
  const _DateTimeStep();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("اختيار التاريخ والوقت"),
    );
  }
}

class _PaymentStep extends StatelessWidget {
  const _PaymentStep();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("اختيار طريقة الدفع"),
    );
  }
}