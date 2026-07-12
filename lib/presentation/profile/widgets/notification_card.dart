import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';

import '../../../domain/models/profile/notifications_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationsModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  bool get isRead => notification.readAt != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.surface
            : AppColors.primary.withOpacity(.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRead
              ? Colors.grey.shade200
              : AppColors.primary.withOpacity(.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _iconColor().withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon(),
              color: _iconColor(),
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  notification.data?.title ?? "",
                  style: AppTextStyles.mediumBoldBlack,
                ),

                const SizedBox(height: 8),

                /// Body
                Text(
                  notification.data?.body ?? "",
                  style: AppTextStyles.smallGrey,
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),

                    Text(
                      _formatDate(notification.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                    const Spacer(),

                    if (!isRead)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "جديد",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _icon() {
    switch (notification.data?.type) {
      case "subscription_created":
        return Icons.event_available_rounded;

      case "subscription_status":
        return Icons.autorenew_rounded;

      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _iconColor() {
    switch (notification.data?.type) {
      case "subscription_created":
        return Colors.green;

      case "subscription_status":
        return Colors.orange;

      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";

    return "${date.day}/${date.month}/${date.year}";
  }
}