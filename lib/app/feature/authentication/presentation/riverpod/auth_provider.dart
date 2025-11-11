import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../di.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/authentication_repository.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<Either<Failure, UserEntity?>> build() async {
    // Load current user when provider starts
    final repo = sl<AuthRepository>();
    final result = await repo.getCurrentUser();
    return result;
  }

  /// 🔹 Login
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    final repo = sl<AuthRepository>();
    final result = await repo.login(email: email, password: password);

    state = AsyncData(result);
  }

  /// 🔹 Logout and clear cache
  Future<void> logout() async {
    state = const AsyncLoading();

    final repo = sl<AuthRepository>();
    final result = await repo.logout();

    result.fold(
      (failure) => state = AsyncData(Left(failure)),
      (_) => state = const AsyncData(Right(null)),
    );
  }

  /// 🔹 Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final repo = sl<AuthRepository>();
    final result = await repo.isAuthenticated();
    return result.getOrElse(() => false);
  }
}
