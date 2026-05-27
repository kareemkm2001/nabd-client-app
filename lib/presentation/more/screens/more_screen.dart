import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/presentation/auth/screens/auth_screen.dart';
import 'package:nabd_client_app/presentation/invoices/screens/invoice_screen.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/widgets/app_route_animation.dart';
import '../../../core/helper/avatar_helper.dart';
import '../../settings/settings_screen.dart';
import '../widgets/more_menu_item.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(

          children: [

            const SizedBox(height: 30),

            Center(
              child: Column(
                children: [

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(
                        AvatarHelper.getAvatar('hijab', '123'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "User Name",
                    style: AppTextStyles.mediumBlack.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "user@email.com",
                    style: AppTextStyles.smallGrey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ================= MENU =================
            Expanded(
              child: ListView(

                children: [

                  MoreMenuItem(
                    icon: Icons.calendar_month,
                    title: AppLocalization.t('المواعيد'),
                    color: Colors.blue,
                    onTap: () {},
                  ),

                  MoreMenuItem(
                    icon: Icons.request_page_rounded,
                    title: AppLocalization.t('طلبات المواعيد'),
                    color: Colors.orange,
                    onTap: () {},
                  ),

                  MoreMenuItem(
                    icon: Icons.receipt_long,
                    title: AppLocalization.t('الفواتير'),
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoiceScreen(),
                        ),
                      );
                    },
                  ),

                  MoreMenuItem(
                    icon: Icons.settings,
                    title: AppLocalization.t('الإعدادات'),
                    color: Colors.grey,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),

                  MoreMenuItem(
                    icon: Icons.logout,
                    title: AppLocalization.t('تسجيل الخروج'),
                    color: Colors.red,
                    onTap: () async {
                      await TokenService.clearToken();

                      Navigator.pushAndRemoveUntil(
                        context,
                        AppRouteAnimation(page: const AuthScreen()),
                            (_) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}