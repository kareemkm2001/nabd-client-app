import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:nabd_client_app/core/widgets/app_info_tile.dart';
import 'package:nabd_client_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:nabd_client_app/presentation/auth/screens/auth_screen.dart';
import 'package:nabd_client_app/presentation/invoices/screens/invoice_screen.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_cubit.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';
import 'package:nabd_client_app/presentation/profile/screens/profile_detail_screen.dart';
import 'package:nabd_client_app/presentation/profile/screens/sub_users_screen.dart';
import 'package:nabd_client_app/presentation/terms_and_conditions/terms_page.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../data/local/token_service.dart';
import '../../../../core/widgets/app_route_animation.dart';
import '../../../core/helper/avatar_helper.dart';
import '../../settings/screens/settings_screen.dart';
import '../widgets/profile_menu_item.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final profileCubit = context.read<ProfileCubit>() ;

    return Scaffold(
      appBar: AppAppBar(titleKey: "الحساب",isHome: true,),

      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(

          children: [

            const SizedBox(height: 30),

            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    AppRouteAnimation(page: ProfileDetailScreen())
                );
              },
              child: BlocBuilder<ProfileCubit,ProfileState>(
                  builder: (context , state){
                    return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Hero(
                          tag: "profile_avatar",
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              child: AvatarHelper.getAvatar(
                                profileCubit.profileModel?.firstName ?? "",
                                profileCubit.profileModel?.lastName ?? "",
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Hero(
                                tag: "full_name",
                                child: Text(
                                  "${profileCubit.profileModel?.firstName ?? ""} ${profileCubit.profileModel?.lastName ?? ""}",
                                  style: AppTextStyles.mediumBlack.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  "+${profileCubit.profileModel?.contryCode ?? "" }${profileCubit.profileModel?.mobile ?? ""}",
                                  style: AppTextStyles.smallGrey,
                                ),
                              )
                            ],
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    );
                  }
              )
            ),

            const SizedBox(height: 30),

            /// ================= MENU =================
            Expanded(
              child: ListView(

                children: [

                  MoreMenuItem(
                    icon: Icons.request_page_rounded,
                    title: AppLocalization.t('طلبات المواعيد'),
                    color: AppColors.secondary,
                    onTap: () {},
                  ),

                 MoreMenuItem(
                    icon: Icons.people,
                    title: AppLocalization.t('التابعين'),
                    color: Colors.cyan,
                    onTap: () {
                      Navigator.push(context, AppRouteAnimation(page: SubUsersScreen()));
                    },
                  ),

                  MoreMenuItem(
                    icon: Icons.notifications_active,
                    title: AppLocalization.t('الاشعارات'),
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(context, AppRouteAnimation(page: NotificationsScreen()));
                    },
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
                    icon: Icons.policy_rounded,
                    title: "الشروط والاحكام",
                    color: AppColors.warning,
                    onTap: () async {
                      Navigator.push(
                        context,
                        AppRouteAnimation(page: const TermsPage()),
                      );
                    },
                  ),

                  MoreMenuItem(
                    icon: Icons.logout,
                    title: AppLocalization.t('تسجيل الخروج'),
                    color: Colors.red,
                    onTap: () {
                      InfoDialog.show(
                          context: context,
                          title: "تسجيل الخروج",
                          icon: Icons.logout,
                          color: AppColors.error,
                          actionText: "الخروج",
                        subtitle: "هل انت متاكد من تسجيل الخروج",
                        onAction: () {
                            context.read<AuthCubit>().logout(context);
                        }
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