class Env {
  const Env._();

  static const footballApiBaseUrl = String.fromEnvironment(
    'FOOTBALL_API_BASE_URL',
  );
}
