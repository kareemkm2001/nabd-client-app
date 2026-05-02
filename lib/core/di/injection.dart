import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nabd_client_app/core/network/dio_client.dart';
import 'package:nabd_client_app/presentation/language/cubits/language/language_cubit.dart';

import '../../data/api/auth/auth_api.dart';
import '../../data/api/auth/auth_api_impl.dart';
import '../../domain/usecases/auth_use_case.dart';
import '../../presentation/auth/cubit/auth_cubit.dart';
import '../network/api_service.dart';

final sl = GetIt.instance ;

Future<void> setupLocator() async {

  sl.registerLazySingleton<Dio>(() => DioClient.instance);

  sl.registerLazySingleton<ApiService>(() => ApiService(dio: sl<Dio>()),);

  /* ================= AUTH ================= */
  sl.registerLazySingleton<AuthApi>(() => AuthApiImpl(api: sl<ApiService>()),);
  sl.registerLazySingleton<AuthUseCase>(() => AuthUseCase(authApi: sl<AuthApi>()),);
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthUseCase>()),);


  /* ================= HOME ================= */


  /* ================= LANGUAGE ================= */
  sl.registerFactory<LanguageCubit>(() => LanguageCubit());





}