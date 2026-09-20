import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  const ErrorHandler._();

  static Failure handle(Object error) {
    if (error is AppException) return NetworkFailure(error.message);
    return NetworkFailure('An unexpected error occurred.');
  }
}
