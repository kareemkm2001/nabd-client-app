import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/presentation/language/screens/language_screen.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/top_snackbar.dart';
import '../../../data/local/biometric_prefs.dart';
import '../widgets/settings_item.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    biometricEnabled = await BiometricPrefs.isEnabled();
    setState(() {});
  }

  Future<void> toggleBiometric(bool value) async {
    if (value) {
      final success = await BiometricService.authenticate();

      if (!success) {
        showAppSnackBarError(
          context: context,
          message: "فشل التحقق من البصمة",
        );
        return;
      }

      await BiometricPrefs.setEnabled(true);

      setState(() {
        biometricEnabled = true;
      });

      showAppSnackBarSuc(
        context: context,
        message: "تم تفعيل البصمة بنجاح",
      );

      return;
    }

    await BiometricPrefs.setEnabled(false);

    setState(() {
      biometricEnabled = false;
    });

    showAppSnackBarInfo(
      context: context,
      message: "تم إيقاف البصمة",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "الإعدادات"),
      body: ListView(
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
            switchValue: biometricEnabled,
            onSwitchChanged: toggleBiometric,
          ),

          SettingsItem(
            icon: Icons.notifications,
            title: "الاشعارات ",
            color: Colors.orange,
            isSwitch: true,
            switchValue: true,
            onSwitchChanged: (value){},
          ),

        ],
      ),
    );
  }
}