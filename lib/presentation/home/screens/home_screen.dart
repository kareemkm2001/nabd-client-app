import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/services/language_service.dart';
import 'package:nabd_client_app/core/services/token_service.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/core/widgets/app_text_field.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalization.t('home')),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Text(
                      AppLocalization.t('app_name'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(AppLocalization.t('settings')),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(AppLocalization.t('logout')),
                  onTap: () async {
                    TokenService.clearToken().whenComplete((){
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                          context,
                          AppRouteAnimation(page: AuthScreen()),
                              (route) => false
                      );
                    });
                  },
                ),
              ],
            ),
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
        );
      },
    );
  }
}
