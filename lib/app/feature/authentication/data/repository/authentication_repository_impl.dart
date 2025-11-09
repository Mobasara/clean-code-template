import 'package:clean_code_template/app/feature/authentication/data/model/user_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/results.dart';
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
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDataSource.login(email, password);

      // Cache user and token
      await localDataSource.cacheUser(authResponse);
      await localDataSource.cacheToken(authResponse.id);

      return Result.success(authResponse);
    } on AuthenticationException catch (e) {
      return Result.failure(
        AuthenticationFailure(message: e.message, code: e.code),
      );
    } on ValidationException catch (e) {
      return Result.failure(
        ValidationFailure(message: e.message, code: e.code, errors: e.errors),
      );
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message, code: e.code));
    } on TimeoutException catch (e) {
      return Result.failure(TimeoutFailure(message: e.message, code: e.code));
    } catch (e) {
      return Result.failure(
        const UnexpectedFailure(
          message: 'An unexpected error occurred during login',
        ),
      );
    }
  }
}
