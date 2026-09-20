import '../../../core/network/api_client.dart';

abstract interface class FootballRemoteDataSource {
  Future<void> getMatches();
}

class FootballRemoteDataSourceImpl implements FootballRemoteDataSource {
  FootballRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<void> getMatches() async {
    await _apiClient.dio.get('/matches');
  }
}
