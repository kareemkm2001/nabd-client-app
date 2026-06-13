import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:nabd_client_app/presentation/invoices/cubits/invoices_cubit.dart';
import 'package:nabd_client_app/presentation/language/cubits/language/language_cubit.dart';
import 'package:nabd_client_app/presentation/language/cubits/language/language_state.dart';
import 'package:nabd_client_app/presentation/profile/cubit/profile_cubit.dart';
import 'package:nabd_client_app/presentation/splash/splash_screen.dart';
import 'package:nabd_client_app/presentation/subscriptions/cubit/subscriptions_cubit.dart';

import 'core/di/injection.dart';
import 'core/services/fcm_service.dart';
import 'core/services/local_notification_service.dart';
import 'core/utils/restart_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);

  await FCMService.init();
  await LocalNotificationService.init();

  await setupLocator();

  runApp(
    RestartWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LanguageCubit>(create: (_) => sl<LanguageCubit>()..init(),),
          BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>(),),
          BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
          BlocProvider<InvoicesCubit>(create: (_) => sl<InvoicesCubit>(),),
          BlocProvider<SubscriptionsCubit>(create: (_) => sl<SubscriptionsCubit>(),),
          BlocProvider<AppointmentsCubit>(create: (_) => sl<AppointmentsCubit>(),),
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