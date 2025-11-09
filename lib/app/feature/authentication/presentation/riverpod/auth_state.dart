import '../../domain/entity/user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  forgotPasswordSuccess,
}

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? message;

  const AuthState({required this.status, this.user, this.message});

  const AuthState.initial() : this(status: AuthStatus.initial);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.authenticated(UserEntity user)
    : this(status: AuthStatus.authenticated, user: user);
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);
  const AuthState.error(String message)
    : this(status: AuthStatus.error, message: message);
  const AuthState.forgotPasswordSuccess(String message)
    : this(status: AuthStatus.forgotPasswordSuccess, message: message);
}
