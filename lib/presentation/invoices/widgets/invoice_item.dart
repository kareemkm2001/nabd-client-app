
import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/extensions/date_format.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import '../../../core/helper/file_downloader.dart';

class InvoiceCard extends StatelessWidget {

  final int invoiceId;
  final String serviceName ;
  final String clinicName;
  final String doctorName;
  final String invoiceType;
  final String invoiceState;
  final double totalAmount;
  final String createdAt;
  final String paymentStatus;
  final String insurance;
  final String paymentMode;
  final String pdfLink;

   const InvoiceCard({
     super.key,
     required this.invoiceId,
     required this.serviceName,
     required this.clinicName,
     required this.doctorName,
     required this.invoiceType,
     required this.invoiceState,
     required this.totalAmount,
     required this.createdAt,
     required this.paymentStatus,
     required this.insurance,
     required this.paymentMode,
     required this.pdfLink
   });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                    jsonKey: serviceName,
                    textStyle: AppTextStyles.mediumBoldBlack,
                )
              ),

              GestureDetector(
                onTap: ()async {
                  await FileDownloader.downloadPdf(
                    url: pdfLink,
                    fileName: "Invoice_$invoiceId",
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primary
                  ),
                  child: AppText(
                      jsonKey: "تحميل الفاتورة",
                    textStyle: AppTextStyles.smallWhite,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Text(
              "#INV-$invoiceId",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 16),
          Wrap(
            runSpacing: 12,
            spacing: 20,
            children: [
              _InfoItem(title: "العيادة", value: clinicName),
              _InfoItem(title: "المختص", value: doctorName),
              _InfoItem(title: "نوع الفاتورة", value: invoiceType),
              _InfoItem(title: "حالة الفاتورة", value: invoiceState),
              _InfoItem(title: "حالة التامين", value: insurance),
              _InfoItem(title: "تم الدفع بواسطة", value: paymentMode),
            ],
          ),

          const SizedBox(height: 16),

          Divider(color: AppColors.primary,),

          const SizedBox(height: 12),


          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "تاريخ الانشاء: ${createdAt.toPrettyArabicDateTime()}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$totalAmount ريال ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.green),
                    SizedBox(width: 6),
                    Text(
                      paymentStatus,
                      style: TextStyle(
                        color: paymentStatus == "تم الدفع" ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 🔥 reusable info item
class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.38,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}