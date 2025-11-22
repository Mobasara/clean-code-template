import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../di.dart';
import '../../domain/repository/authentication_repository.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  Future<void> build() async {
    return;
  }

  /// 🔹 Sign Up Request
  Future<void> signUpReq({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading();
    FormData formData = FormData.fromMap({
      "email": email,
      "password": password,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
    });

    final repo = sl<AuthRepository>();
    final result = await repo.signUp(
      fromData: formData,
    );

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
