import '../../../../core/utils/results.dart';
import '../entity/user.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login({required String email, required String password});
}
