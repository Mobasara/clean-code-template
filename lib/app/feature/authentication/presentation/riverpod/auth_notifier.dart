import 'package:clean_code_template/app/feature/authentication/domain/use_case/login_user.dart';
import 'package:clean_code_template/di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repository/authentication_repository.dart';
import 'auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class Auth extends _$Auth {
  // Don't define constructor
  final AuthRepository repository = serviceLocator<AuthRepository>();

  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();

    final loginUser = LoginUser(repository);
    final result = await loginUser(email: email, password: password);

    if (result.isSuccess && result.data != null) {
      state = AuthState.authenticated(result.data!);
    } else {
      state = AuthState.error(result.failure?.message ?? "Login failed");
    }
  }
}
