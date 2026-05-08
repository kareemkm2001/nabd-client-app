import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/services/language_service.dart';
import 'package:nabd_client_app/core/services/token_service.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/core/widgets/app_text_field.dart';
import 'package:nabd_client_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:nabd_client_app/presentation/auth/screens/auth_screen.dart';
import 'package:nabd_client_app/presentation/splash/splash_screen.dart';

import '../../../../core/localization/app_localization.dart';
import '../../language/cubits/language/language_cubit.dart';
import '../../language/cubits/language/language_state.dart';
import '../../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  final phoneController = TextEditingController();
   final passwordController = TextEditingController();
   final formKey = GlobalKey<FormState>();

   final _advancedDrawerController = AdvancedDrawerController();

   void _handleMenuButtonPressed() {
     _advancedDrawerController.showDrawer();
   }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return AdvancedDrawer(
          backdropColor: AppColors.primary,
            drawer: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person),
                  ),

                  const SizedBox(height: 20),

                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Home"),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text("Appointments"),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Settings"),
                    onTap: () {
                      Navigator.push(
                          context,
                          AppRouteAnimation(page: SettingsScreen())
                      );
                    },
                  ),
                  Spacer(),
                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text("Logout"),
                    onTap: () {
                      context.read<AuthCubit>().logout(context);
                    },
                  ),
                ],
              ),
            ),
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: _handleMenuButtonPressed,
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable: _advancedDrawerController,
                      builder: (_, value, __) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            value.visible ? Icons.clear : Icons.menu,
                            key: ValueKey(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
                  title: const Text("MindCare"),
                ),
                body: Column (
                  children: [
                    AppButton(
                      titleKey: "send_otp",
                      onTap: (){

                      },
                      margin: 50,
                    )
                  ],
                )
            )
        );
      },
    );
  }
}
