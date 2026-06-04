import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';

import '../../../../core/utils/restart_widget.dart';
import '../cubits/language/language_cubit.dart';
import '../cubits/language/language_state.dart';
import '../widgets/language_item.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String initialLang;

  @override
  void initState() {
    super.initState();
    initialLang =
        context.read<LanguageCubit>().state.locale.languageCode;
  }

  void _exit() {
    final current =
        context.read<LanguageCubit>().state.locale.languageCode;

    final changed = current != initialLang;

    if (changed) {
      RestartWidget.restartApp(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final cubit = context.read<LanguageCubit>();
        final selectedLang = state.locale.languageCode;

        final languages = ['ar', 'en'];

        // ترتيب اللغة المختارة تكون فوق
        languages.sort((a, b) {
          if (a == selectedLang) return -1;
          if (b == selectedLang) return 1;
          return 0;
        });

        return Scaffold(
          backgroundColor: const Color(0xFFF6F7F9),
          appBar: AppAppBar(titleKey: cubit.t('language'),),
          body: Column(
            children: [
              SizedBox(height: 20,),
              Hero(
                tag: "lan_icon",
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withValues(alpha: 0.15),
                  ),
                  child: Icon(Icons.language, color: Colors.blue,size: 40,),
                ),
              ),
              const SizedBox(height: 20),

              ...languages.map((lang) {
                if (lang == 'ar') {
                  return LanguageItem(
                    title: "العربية",
                    selected: selectedLang == 'ar',
                    flag: const Text("🇸🇦", style: TextStyle(fontSize: 20)),
                    onTap: () => cubit.changeLanguage('ar'),
                  );
                }

                return LanguageItem(
                  title: "English",
                  selected: selectedLang == 'en',
                  flag: const Text("🇬🇧", style: TextStyle(fontSize: 20)),
                  onTap: () {} /*cubit.changeLanguage('en')*/,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}