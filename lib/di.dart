import 'package:clean_code_template/app/core/data/network/network_api_services.dart';
import 'package:clean_code_template/app/feature/authentication/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:clean_code_template/app/feature/authentication/presentation/riverpod/auth_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/core/data/local/local_data.dart';
import 'app/feature/authentication/data/data_source/remote_data_source/authentication_data_source.dart';
import 'app/feature/authentication/data/data_source/remote_data_source/authentication_data_source_impl.dart';
import 'app/feature/authentication/data/repository/authentication_repository_impl.dart';
import 'app/feature/authentication/domain/repository/authentication_repository.dart';
import 'app/feature/authentication/domain/use_case/login_user.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // core
  serviceLocator.registerLazySingleton<LocalData>(
    () => LocalData(sharedPreferences),
  );

  // auth
  _initAuth();
}

void _initAuth() {
  serviceLocator
    // Network API Service (needs LocalData)
    ..registerFactory(() => NetworkApiServices(serviceLocator<LocalData>()))
    
    // Remote datasource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiService: serviceLocator<NetworkApiServices>()),
    )
    
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
        localDataSource: serviceLocator<AuthLocalDataSource>(),
      ),
    )

    // Use case
    ..registerFactory(() => LoginUser(serviceLocator<AuthRepository>()))

    // Riverpod AuthNotifier
    ..registerFactory(() => Auth());
}
