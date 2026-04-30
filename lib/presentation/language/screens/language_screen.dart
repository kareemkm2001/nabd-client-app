import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../core/utils/restart_widget.dart';
import '../cubits/language/language_cubit.dart';
import '../cubits/language/language_state.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late final String _initialLanguageCode;

  @override
  void initState() {
    super.initState();
    _initialLanguageCode = context.read<LanguageCubit>().state.locale.languageCode;
  }

  void _handleExit() {
    final currentLanguageCode = context.read<LanguageCubit>().state.locale.languageCode;
    final hasLanguageChanged = currentLanguageCode != _initialLanguageCode;

    if (hasLanguageChanged) {
      RestartWidget.restartApp(context);
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final cubit = context.read<LanguageCubit>();

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            _handleExit();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _handleExit,
              ),
              title: Text(cubit.t('language')),
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text(cubit.t('arabic')),
                  trailing: state.locale.languageCode == 'ar'
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => cubit.changeLanguage('ar'),
                ),
                ListTile(
                  title: Text(cubit.t('english')),
                  trailing: state.locale.languageCode == 'en'
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => cubit.changeLanguage('en'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
