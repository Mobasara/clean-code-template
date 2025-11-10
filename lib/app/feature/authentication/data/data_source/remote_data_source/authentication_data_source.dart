import '../../../../../core/utils/results.dart' as results;
import '../../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<results.Result<UserModel>> login(String email, String password);
}

