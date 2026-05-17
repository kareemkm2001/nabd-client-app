import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';

class AppointmentBookingWidget extends StatelessWidget {
  const AppointmentBookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 28),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                  jsonKey: "احجز موعدا",
                textStyle: AppTextStyles.mediumBoldWhite,
              ),
              SizedBox(height: 20,),
              AppText(
                  jsonKey: "ابحث عن الأخصائي المناسب اليوم",
                textStyle: AppTextStyles.smallBoldWhite ,
              )
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16)
            ),
            child: Icon(
              Icons.date_range_outlined,
              color: AppColors.surface,
              size: 32,
            ),
          )
        ],
      ),
    );
  }
}
