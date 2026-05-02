import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nabd_client_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:nabd_client_app/presentation/language/cubits/language/language_cubit.dart';
import 'package:nabd_client_app/presentation/language/cubits/language/language_state.dart';
import 'package:nabd_client_app/presentation/splash/splash_screen.dart';

import 'core/di/injection.dart';
import 'core/utils/restart_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(
    RestartWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LanguageCubit>(create: (_) => sl<LanguageCubit>()..init(),),
          BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>(),)
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: state.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            fontFamily: 'Cairo'
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}