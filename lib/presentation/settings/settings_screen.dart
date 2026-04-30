import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../core/localization/app_localization.dart';
import '../language/cubits/language/language_cubit.dart';
import '../language/cubits/language/language_state.dart';
import '../language/screens/language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalization.t('settings')),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(AppLocalization.t('language')),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LanguageScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
