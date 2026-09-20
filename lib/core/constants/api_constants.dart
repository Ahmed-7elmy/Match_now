class ApiConstants {
  ApiConstants._();

  static const String apiKeyHeader = 'x-apisports-key';

  static const String fixturesEndpoint = '/fixtures';
  static const String leaguesEndpoint = '/leagues';
  static const String standingsEndpoint = '/standings';
  static const String teamsEndpoint = '/teams';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);
}
