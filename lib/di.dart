import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/core/data/local/local_data.dart';


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
