import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_text_field.dart';

import '../../cubits/language/language_cubit.dart';
import '../../cubits/language/language_state.dart';
import '../../../core/localization/app_localization.dart';
import '../settings/settings_screen.dart';

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
              ],
            ),
          ),
          body: Column(
            children: [

              AppButton(
                titleKey: "send_otp",
                onTap: (){},
                margin: 50,
              )
            ],
          )
        );
      },
    );
  }
}
