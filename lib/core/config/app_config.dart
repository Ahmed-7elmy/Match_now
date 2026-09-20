import 'env.dart';

class AppConfig {
  AppConfig._();

  static const appName = 'Match point ;)';

  static String get apiBaseUrl => Env.apiFootballBaseUrl;

  static String get apiKey => Env.apiFootballKey;
}
