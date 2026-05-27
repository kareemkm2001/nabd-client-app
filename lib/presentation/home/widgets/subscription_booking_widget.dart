import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text.dart';

class SubscriptionBookingWidget extends StatelessWidget {
  const SubscriptionBookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 28),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.secondary,width: 1,),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.secondary,
            child: Icon(
              Icons.subdirectory_arrow_left,
              color: AppColors.surface,
            ),
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                jsonKey: "وفر مع خطط",
                textStyle: AppTextStyles.mediumBlack,
              ),
              SizedBox(height: 10,),
              AppText(
                jsonKey: "الاشتراك الخاصة بنا",
                textStyle: AppTextStyles.mediumBlack ,
              )
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .6),
                borderRadius: BorderRadius.circular(8)
            ),
            child: AppText(
                jsonKey: "اشترك الان",
              textStyle: AppTextStyles.mediumWhite,
            )
          )
        ],
      ),
    );
  }
}
