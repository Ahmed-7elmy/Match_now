import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Bridges dotenv configuration to the rest of the application.
class Env {
  Env._();

  static String get apiFootballBaseUrl {
    final value = dotenv.env['API_FOOTBALL_BASE_URL'];

    if (value == null || value.trim().isEmpty) {
      throw StateError(
        'API_FOOTBALL_BASE_URL is missing from the environment.',
      );
    }

    return value;
  }

  static String get apiFootballKey {
    final value = dotenv.env['API_FOOTBALL_KEY'];

    if (value == null || value.trim().isEmpty) {
      throw StateError('API_FOOTBALL_KEY is missing from the environment.');
    }

    return value;
  }
}
