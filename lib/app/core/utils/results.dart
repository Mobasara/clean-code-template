import '../error/failures.dart';

class Result<T> {
  final T? data;
  final Failure? failure;

  bool get isSuccess => data != null;
  bool get isFailure => failure != null;

  Result.success(this.data) : failure = null;
  Result.failure(this.failure) : data = null;
}
