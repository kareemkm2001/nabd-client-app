import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/language/screens/language_screen.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_state.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/top_snackbar.dart';
import '../../profile/cubit/profile_cubit.dart';
import '../widgets/settings_item.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    context.read<ProfileCubit>().loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "الإعدادات"),
      body: BlocBuilder<ProfileCubit,ProfileState>(
          builder:(context,state){
            return ListView(
              children: [

                SettingsItem(
                  icon: Icons.language,
                  title: AppLocalization.t('اللغة'),
                  color: Colors.blue,
                  heroTag: "lan_icon",
                  onTap: () {
                    Navigator.push(
                        context,
                        AppRouteAnimation(page: LanguageScreen())
                    );
                  },
                ),

                SettingsItem(
                  icon: Icons.fingerprint,
                  title: "تفعيل البصمة",
                  color: Colors.green,
                  isSwitch: true,
                  switchValue: profileCubit.biometricEnabled,
                  onSwitchChanged: (value) async {

                    final success = await profileCubit.toggleBiometric(value);

                    if (!context.mounted) return;

                    if (value && !success) {
                      showAppSnackBarError(
                        context: context,
                        message: "فشل التحقق من البصمة",
                      );
                      return;
                    }

                    showAppSnackBarSuc(
                      context: context,
                      message: value
                          ? "تم تفعيل البصمة بنجاح"
                          : "تم إيقاف البصمة",
                    );
                  },
                ),

                SettingsItem(
                  icon: Icons.notifications,
                  title: "الاشعارات ",
                  color: Colors.orange,
                  isSwitch: true,
                  switchValue: true,
                  onSwitchChanged: (value) async {

                    await profileCubit.toggleNotifications(value);

                    if (!context.mounted) return;

                    showAppSnackBarInfo(
                      context: context,
                      message: profileCubit.notificationsEnabled
                          ? "تم تفعيل الإشعارات"
                          : "يرجى تعديل إعدادات الإشعارات من إعدادات الجهاز",
                    );
                  },
                ),

              ],
            );
          }
      )
    );
  }
}