import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../di.dart';
import '../../../../core/error/failures.dart';
import '../../domain/use_case/sign_up_use_case.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<Either<Failure, dynamic>> build() async {
    return const Right(null);
  }

  /// 🔹 Sign Up Request
  Future<void> signUpReq({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading();

    final signUp = sl<SignUpUseCase>();
    final result = await signUp(
      SignUpParams(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      ),
    );

    state = AsyncData(result);
  }
}
