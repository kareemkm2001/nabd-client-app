import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';
import 'package:nabd_client_app/presentation/appointments/screens/payment_view_screen.dart';

import '../../../core/services/local_notification_service.dart';
import '../../../core/widgets/top_snackbar.dart';

class PaymentStepScreen extends StatefulWidget {
  const PaymentStepScreen({super.key});

  @override
  State<PaymentStepScreen> createState() => _PaymentStepScreenState();
}

class _PaymentStepScreenState extends State<PaymentStepScreen> {
  @override
  void initState() {
    context.read<AppointmentsCubit>().getTaxInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsCubit = context.read<AppointmentsCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "الدفع"),
      body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    "اختار وسيلة الدفع",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 24),

                _buildPaymentItem(
                  context: context,
                  title: "فيزا / ماستر كارد",
                  image: "assets/images/tap-payments.png",
                  isSelected: appointmentsCubit.selectedPaymentMethod == 1,
                  onTap: () {
                    appointmentsCubit.selectPaymentMethod(1);
                  },
                ),

                const SizedBox(height: 12),

                _buildPaymentItem(
                  context: context,
                  title: "تمارا",
                  image: "assets/images/tamara.png",
                  isSelected: appointmentsCubit.selectedPaymentMethod == 2,
                  onTap: () {
                    appointmentsCubit.selectPaymentMethod(2);
                  },
                ),

                const SizedBox(height: 12),

                _buildPaymentItem(
                  context: context,
                  title: "مدفوع",
                  image: "assets/images/madfou.png",
                  isSelected: appointmentsCubit.selectedPaymentMethod == 3,
                  onTap: () {
                    appointmentsCubit.selectPaymentMethod(3);
                  },
                ),

                const SizedBox(height: 30),

                const Text(
                  "ملخص الدفع",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _priceRow(
                        title: "سعر الخدمة",
                        value: "${appointmentsCubit.selectedPrice}",
                      ),

                      const SizedBox(height: 12),

                      _priceRow(
                        title: "الضريبة",
                        value: "${appointmentsCubit.getTaxAmount()}",
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),

                      _priceRow(
                        title: "الإجمالي",
                        value: "${appointmentsCubit.getTotalPrice()} ريال",
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  margin: 8,
                  titleKey: "اتمام الدفع",
                    onTap: () async {
                      await LocalNotificationService.show(
                        title: "تم الحجز بنجاح",
                        body: "تم تأكيد موعدك مع الطبيب",
                      );
                      if(appointmentsCubit.selectedPaymentMethod == null){
                        showAppSnackBarError(
                            context: context,
                            message: "يرجي وسيلة الدفع"
                        );
                      }else {
                        Navigator.push(
                            context,
                            AppRouteAnimation(page: PaymentViewScreen(paymentUrl: "https://www.internetdownloadmanager.com/download2.html?lng=ar"))
                        );
                      }
                    }
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentItem({
    required BuildContext context,
    required String title,
    required String image,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(image, width: 36, height: 36),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow({
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppColors.primary : Colors.black87,
          ),
        ),
      ],
    );
  }
}
