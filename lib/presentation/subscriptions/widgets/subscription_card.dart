import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/extensions/date_format.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:nabd_client_app/domain/models/subscriptions/subscriptions_response.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscriptionModel ;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.subscriptionModel,
    required this.onTap,
  });

  double get progress =>
      subscriptionModel.numberOfSessions == 0 ? 0 : subscriptionModel.completedSessions / subscriptionModel.numberOfSessions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Expanded(
                  child: AppText(
                    jsonKey: subscriptionModel.packageName,
                    textStyle: AppTextStyles.mediumBoldBlack,
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: subscriptionModel.status == "مفعل"
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subscriptionModel.status,
                    style: TextStyle(
                      color: subscriptionModel.status == "مفعل"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ================= PROGRESS =================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  color: AppColors.primary,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),

                const SizedBox(height: 6),

                Text(
                  "${subscriptionModel.completedSessions} / ${subscriptionModel.numberOfSessions} جلسات",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ================= BOTTOM INFO =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${subscriptionModel.price} ريال",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "ينتهي: ${subscriptionModel.endDate.toPrettyArabicDateTime()}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}