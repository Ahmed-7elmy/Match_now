class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException(this.message);
}

class RateLimitException implements Exception {
  final String message;

  const RateLimitException(this.message);
}

class ParsingException implements Exception {
  final String message;

  const ParsingException(this.message);
}
