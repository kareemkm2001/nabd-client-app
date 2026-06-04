import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/extensions/date_format.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';

import '../../../domain/models/appointment/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dt;
    try {
      dt = DateTime.parse("${appointment.date} ${appointment.fromTime}");
    } catch (_) {
      dt = DateTime.now();
    }


    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// 🔥 1) Clinic + Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    appointment.clinic.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: appointment.status ==  "تم إصدار الفاتورة"
                        ? AppColors.primary.withValues(alpha: 0.8)
                        : appointment.status == "قيد الإنتظار"
                          ? AppColors.warning.withValues(alpha: 0.8)
                          : appointment.status == "مكتمل"
                            ? AppColors.success.withValues(alpha: 0.8)
                            : AppColors.error.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment.status,
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔥 2) Service + Type badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    appointment.service.name,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: appointment.type == "حضوري"
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment.type,
                    style: TextStyle(
                      color: appointment.type == "حضوري" ? Colors.blue : Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "د. ${appointment.clinic.doctor.fullName}",
                  style: const TextStyle(color: Colors.grey),
                ),

                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 2),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 2),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 2),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 2),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🔥 4) TIME BLOCK (centered)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     Icon(
                      Icons.calendar_month,
                        size: 16,
                        color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),

                    Text(
                      appointment.date.toPrettyArabicDateTime(),
                      style:  TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(width: 12),
                  ],
                ),

                const SizedBox(height: 10),

                /// ⏰ Time with icon + arrow in center
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: Colors.grey),

                    const SizedBox(width: 6),

                    Text(
                      appointment.fromTime,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(width: 8),

                    const Icon(Icons.arrow_forward_rounded,
                        size: 18, color: Colors.grey),

                    const SizedBox(width: 8),

                    Text(
                      appointment.toTime,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}