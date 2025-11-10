import '../error/failures.dart';

/// Represents either a successful or failed operation.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  /// Executes [onSuccess] if this is [Success],
  /// otherwise [onError].
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    switch (this) {
      case Success(:final data):
        return onSuccess(data);
      case Error(:final failure):
        return onError(failure);
    }
  }

  /// Maps the success data to another type.
  Result<R> map<R>(R Function(T data) transform) {
    switch (this) {
      case Success(:final data):
        return Success(transform(data));
      case Error(:final failure):
        return Error(failure);
    }
  }
}

/// Success case
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Failure case
class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}
