abstract class Failure {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'The request timed out. Please try again.',
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Authentication failed.']);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure([
    super.message = 'Too many requests. Please try again later.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'The server is currently unavailable.']);
}

class ParsingFailure extends Failure {
  const ParsingFailure([
    super.message = 'Unable to process the server response.',
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
