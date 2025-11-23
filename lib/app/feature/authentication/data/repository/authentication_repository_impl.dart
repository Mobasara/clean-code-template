import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/data/local/local_data.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_map.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/sign_up_entity.dart';
import '../../domain/repository/authentication_repository.dart';
import '../data_source/authentication_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authRemoteDataSource});

  final AuthRemoteDataSource authRemoteDataSource;

  @override
  Future<Either<Failure, SignUpEntity>> signUp({
    required String email,
    required String fullName,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final signUpReq = await authRemoteDataSource.signUp(
        email: email,
        fullName: fullName,
        password: password,
        phoneNumber: phoneNumber,
      );

      return Right(signUpReq.toEntity());
    } on AppException catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = GetIt.I<LocalData>().getAccessToken();
      return Right(token.isNotEmpty);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemoteDataSource.logout();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
