import '../errors/failures.dart';

sealed class Result<T> {
  //sealed here means en result can only be only in this file and cannot be extended outside of this file
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);
}
