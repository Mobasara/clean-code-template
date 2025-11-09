import '../../../../core/utils/results.dart';
import '../entity/user.dart';
import '../repository/authentication_repository.dart';

class LoginUser {
  LoginUser(this.repository);

  final AuthRepository repository;

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}
