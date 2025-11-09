import '../utils/results.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  Future<Result<Type>> call();
}

class NoParams {
  const NoParams();
}

class PaginationParams {
  final int page;
  final int limit;

  const PaginationParams({required this.page, required this.limit});
}
