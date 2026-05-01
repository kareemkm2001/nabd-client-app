import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';

class AppButton extends StatelessWidget {
  final String titleKey;
  final VoidCallback onTap;
  final double margin;
  final Widget? child ;

  const AppButton({
    super.key,
    this.titleKey = "",
    required this.onTap,
    this.margin = 24,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin,vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: child ?? AppText(
              jsonKey: titleKey,
              textStyle: AppTextStyles.mediumWhite
          ),
        ),
      ),
    );
  }
}