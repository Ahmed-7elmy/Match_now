class ApiConstants {
  ApiConstants._();

  static const String apiKeyHeader = 'x-apisports-key';

  static const String fixturesEndpoint = '/fixtures';
  static const String leaguesEndpoint = '/leagues';
  static const String standingsEndpoint = '/standings';
  static const String teamsEndpoint = '/teams';

  static const int premierLeagueId = 39;
  static const Set<int> supportedPremierLeagueSeasons = {2022, 2023, 2024};

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);
}
