import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nabd_client_app/core/network/dio_client.dart';
import 'package:nabd_client_app/data/api/appointments/appointments_api.dart';
import 'package:nabd_client_app/data/api/appointments/appointments_api_impl.dart';
import 'package:nabd_client_app/data/api/invoice/invoice_api.dart';
import 'package:nabd_client_app/data/api/invoice/invoice_api_impl.dart';
import 'package:nabd_client_app/data/api/subscriptions/subscriptions_api.dart';
import 'package:nabd_client_app/data/api/subscriptions/subscriptions_api_impl.dart';
import 'package:nabd_client_app/domain/usecases/appointment_use_case.dart';
import 'package:nabd_client_app/domain/usecases/invoice_use_case.dart';
import 'package:nabd_client_app/domain/usecases/subscriptions_use_case.dart';
import 'package:nabd_client_app/presentation/appointments/cubit/appointments_cubit.dart';
import 'package:nabd_client_app/presentation/invoices/cubits/invoices_cubit.dart';
import 'package:nabd_client_app/presentation/language/cubits/language/language_cubit.dart';
import 'package:nabd_client_app/presentation/subscriptions/cubit/subscriptions_cubit.dart';

import '../../data/api/auth/auth_api.dart';
import '../../data/api/auth/auth_api_impl.dart';
import '../../domain/usecases/auth_use_case.dart';
import '../../presentation/auth/cubit/auth_cubit.dart';
import '../network/api_service.dart';
import '../network/app_interceptor.dart';

final sl = GetIt.instance ;
Future<void> setupLocator() async {

  final dio = DioClient.instance;

  dio.interceptors.add(AppInterceptor(dio: dio));
  sl.registerLazySingleton<Dio>(() => dio);
  sl.registerLazySingleton<ApiService>(() => ApiService(dio: sl<Dio>()),);


  /* AUTH */

  sl.registerLazySingleton<AuthApi>(() => AuthApiImpl(api: sl<ApiService>()),);
  sl.registerLazySingleton<AuthUseCase>(() => AuthUseCase(authApi: sl<AuthApi>()),);
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthUseCase>()),);

  /* LANGUAGE */

  sl.registerFactory(() => LanguageCubit());

  /* INVOICE */
  sl.registerLazySingleton<InvoiceApi>(() => InvoiceApiImpl(api: sl<ApiService>()),);
  sl.registerLazySingleton<InvoiceUseCase>(() => InvoiceUseCase(invoiceApi: sl<InvoiceApi>()),);
  sl.registerFactory<InvoicesCubit>(() => InvoicesCubit(invoiceUseCase: sl<InvoiceUseCase>()),);

  /* SUBSCRIPTION */
  sl.registerLazySingleton<SubscriptionsApi>(() => SubscriptionsApiImpl(api: sl<ApiService>()));
  sl.registerLazySingleton<SubscriptionsUseCase>(() => SubscriptionsUseCase(subscriptionsApi: sl<SubscriptionsApi>()));
  sl.registerFactory<SubscriptionsCubit>(() => SubscriptionsCubit(subscriptionsUseCase: sl<SubscriptionsUseCase>()));

  /* APPOINTMENTS */
  sl.registerLazySingleton<AppointmentsApi>(() => AppointmentsApiImpl(api: sl<ApiService>()));
  sl.registerLazySingleton<AppointmentUseCase>(() => AppointmentUseCase(appointmentsApi: sl<AppointmentsApi>()));
  sl.registerFactory<AppointmentsCubit>(()=> AppointmentsCubit(appointmentUseCase: sl<AppointmentUseCase>()));


}