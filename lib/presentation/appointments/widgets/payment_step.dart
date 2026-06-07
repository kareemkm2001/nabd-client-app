import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_state.dart';

class PaymentStep extends StatelessWidget {
  const PaymentStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentsCubit>();

    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// ===== TITLE =====
              const Text(
                "اختار وسيلة الدفع",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// ===== PAYMENT OPTIONS =====
              _buildItem(
                context: context,
                title: "فيزا / ماستر كارد",
                image: "assets/images/tap-payments.png",
                isSelected: cubit.selectedPaymentMethod == 1,
                onTap: () => cubit.selectPaymentMethod(1),
              ),

              const SizedBox(height: 12),

              _buildItem(
                context: context,
                title: "تمارا",
                image: "assets/images/tamara.png",
                isSelected: cubit.selectedPaymentMethod == 2,
                onTap: () => cubit.selectPaymentMethod(2),
              ),

              const SizedBox(height: 12),

              _buildItem(
                context: context,
                title: "مدفوع",
                image: "assets/images/madfou.png",
                isSelected: cubit.selectedPaymentMethod == 3,
                onTap: () => cubit.selectPaymentMethod(3),
              ),

              const Spacer(),

              /// ===== PRICE =====
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "إجمالي السعر",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "50 ريال",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem({
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(0.08)
              : Colors.white,
        ),
        child: Row(
          children: [
            /// ===== IMAGE =====
            Image.asset(
              image,
              width: 30,
              height: 30,
            ),

            const SizedBox(width: 10),

            /// ===== TEXT =====
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black,
                ),
              ),
            ),

            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}