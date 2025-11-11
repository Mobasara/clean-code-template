import 'package:clean_code_template/app/core/data/network/network_api_services.dart';
import 'package:clean_code_template/app/feature/authentication/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:clean_code_template/app/feature/authentication/presentation/riverpod/auth_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/core/data/local/local_data.dart';
import 'app/feature/authentication/data/data_source/local_data_source/auth_local_data_source_impl.dart';
import 'app/feature/authentication/data/data_source/remote_data_source/authentication_data_source.dart';
import 'app/feature/authentication/data/data_source/remote_data_source/authentication_data_source_impl.dart';
import 'app/feature/authentication/data/repository/authentication_repository_impl.dart';
import 'app/feature/authentication/domain/repository/authentication_repository.dart';
import 'app/feature/authentication/domain/use_case/login_use_case.dart';

final sl = GetIt.instance;
Future dI() async {
  // Local Data Storage/ Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  //-- Local Data
  sl.registerLazySingleton<LocalData>(() => LocalData(sl()));
  //-- Network API Service
  final apiService = NetworkApiServices(sl());
  sl.registerLazySingleton(() => apiService);

  // Data sources
  //-- Remote
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl()),
  );
  //-- Local
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerSingleton(() => LoginUseCase(repository: sl()));

  // Riverpod Notifier
  sl.registerFactory(() => Auth());
}
