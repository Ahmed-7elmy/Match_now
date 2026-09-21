import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handle(Object error) {
    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is NetworkException) {
      return NetworkFailure(error.message);
    }

    if (error is TimeoutException) {
      return TimeoutFailure(error.message);
    }

    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message);
    }

    if (error is RateLimitException) {
      return RateLimitFailure(error.message);
    }

    if (error is ServerException) {
      return ServerFailure(error.message);
    }

    if (error is ParsingException) {
      return ParsingFailure(error.message);
    }

    return const UnknownFailure();
  }

  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return const UnknownFailure('The request was cancelled.');

      case DioExceptionType.badCertificate:
        return const NetworkFailure('Secure connection failed.');

      case DioExceptionType.unknown:
        return const UnknownFailure();
    }
  }

  static Failure _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 401:
      case 403:
        return const UnauthorizedFailure();

      case 429:
        return const RateLimitFailure();

      case 500:
      case 502:
      case 503:
      case 504:
        return const ServerFailure();

      default:
        return const UnknownFailure();
    }
  }
}
