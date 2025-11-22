import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/sign_up_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, SignUpEntity>> signUp({
    required String email,
    required String fullName,
    required String password,
    required String phoneNumber,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isAuthenticated();
}
