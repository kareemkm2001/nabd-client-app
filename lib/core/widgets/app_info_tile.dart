import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  final String actionText;
  final VoidCallback? onAction;

  const InfoDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.actionText,
    this.onAction,
  });

  static void show({
    required BuildContext context,
    required String title,
    String? subtitle,
    required IconData icon,
    required Color color,
    required String actionText,
    VoidCallback? onAction,
  }) {
    showDialog(
      context: context,
      builder: (_) => InfoDialog(
        title: title,
        subtitle: subtitle,
        icon: icon,
        color: color,
        actionText: actionText,
        onAction: onAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ICON
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(height: 16),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),

            /// SUBTITLE
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              children: [

                /// CLOSE
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("إغلاق",style: TextStyle(color: AppColors.textPrimary,),),
                  ),
                ),

                const SizedBox(width: 10),

                /// ACTION
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onAction != null) onAction!();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(actionText),
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