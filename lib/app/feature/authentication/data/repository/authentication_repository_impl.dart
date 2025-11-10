import '../../../../core/utils/results.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/authentication_repository.dart';
import '../data_source/local_data_source/auth_local_data_source.dart';
import '../data_source/remote_data_source/authentication_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    final remoteResult = await remoteDataSource.login(email, password);

    return remoteResult.fold(
      onSuccess: (userModel) async {
        await localDataSource.cacheUser(userModel);
        await localDataSource.cacheToken(userModel.id);
        return Success(userModel.toEntity());
      },
      onError: (failure) {
        return Error(failure);
      },
    );
  }
}
