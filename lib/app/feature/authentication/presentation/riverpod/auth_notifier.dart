import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class Auth extends _$Auth {
  // final AuthRepository repository = serviceLocator<AuthRepository>();

  @override
  AuthState build() {
    return const AuthInitial();
  }

  var isLoading = false;

  Future<void> login({required String email, required String password}) async {
    isLoading = true;

    // final loginUser = LoginUser(repository);
    // final Result<UserEntity> result = await loginUser(
    //   email: email,
    //   password: password,
    // );

    isLoading = false;
    // result.fold(
    //   onSuccess: (user) {
    //     state = AuthAuthenticated(user);
    //   },
    //   onError: (failure) {
    //     state = AuthError(failure.message);
    //   },
    // );
  }
}
