import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/extensions/date_format.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/domain/models/subscriptions/subscriptions_response.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  final SubscriptionModel subscription;

  const SubscriptionDetailsPage({
    super.key,
    required this.subscription,
  });

  double get progress =>
      subscription.numberOfSessions == 0
          ? 0
          : subscription.completedSessions /
          subscription.numberOfSessions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppAppBar(titleKey:"تفاصيل الاشتراك",),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// ================= CIRCLE PROGRESS =================
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child:CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade300,
                      color: AppColors.primary,
                      strokeCap: StrokeCap.round,
                    )
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${subscription.completedSessions}/${subscription.numberOfSessions}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "جلسات",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= MAIN CARD =================
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _item("الباقة", subscription.packageName),
                  _item("الخدمة", subscription.serviceName),
                  _item("العيادة", subscription.clinicName),
                  _item("الدكتور", subscription.doctorName),

                  const Divider(height: 30),

                  _item("الحالة", subscription.status),
                  _item("حالة الفاتورة", subscription.invoiceStatus),

                  const Divider(height: 30),

                  _item("السعر", "${subscription.price} ريال"),
                  _item("المتبقي", "${subscription.remainingSessions} جلسات"),

                  const Divider(height: 30),

                  _item(
                    "تاريخ البداية",
                    subscription.startDate.toPrettyArabicDateTime(),
                  ),
                  _item(
                    "تاريخ النهاية",
                    subscription.endDate.toPrettyArabicDateTime(),
                  ),
                  _item(
                    "تاريخ الإنشاء",
                    subscription.createdAt.toPrettyArabicDateTime(),
                  ),

                  if (subscription.notes != null &&
                      subscription.notes!.isNotEmpty) ...[
                    const Divider(height: 30),
                    _item("ملاحظات", subscription.notes!),
                  ],
                ],
              ),
            ),
            
            AppButton(
                onTap: (){},
                titleKey: "احجز جلستك القادمة",
              margin: 16,
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}