import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/core/data/data.dart';
import 'app/feature/authentication/data/data.dart';
import 'app/feature/authentication/domain/domain.dart';
import 'app/feature/authentication/presentation/presentation.dart';


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
