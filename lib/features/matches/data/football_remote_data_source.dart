import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import 'models/match_model.dart';

abstract interface class FootballRemoteDataSource {
  Future<List<MatchModel>> getFixtures({
    int? leagueId,
    int? season,
    String? date,
  });
}

class FootballRemoteDataSourceImpl implements FootballRemoteDataSource {
  FootballRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<MatchModel>> getFixtures({
    int? leagueId,
    int? season,
    String? date,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (leagueId != null) {
      queryParameters['league'] = leagueId;
    }

    if (season != null) {
      queryParameters['season'] = season;
    }

    if (date != null) {
      queryParameters['date'] = date;
    }

    final response = await _apiClient.get(
      ApiConstants.fixturesEndpoint,
      queryParameters: queryParameters,
    );
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const ParsingException('Invalid API response.');
    }

    _validateApiResponse(data);

    final responseList = data['response'];

    if (responseList is! List) {
      throw const ParsingException('Fixtures response is invalid.');
    }

    try {
      return responseList
          .map(
            (fixture) => MatchModel.fromJson(fixture as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      throw const ParsingException('Unable to parse fixtures.');
    }
  }

  void _validateApiResponse(Map<String, dynamic> data) {
    final errors = data['errors'];

    if (errors is Map && errors.isNotEmpty) {
      throw ServerException(errors.values.join(', '));
    }

    if (errors is List && errors.isNotEmpty) {
      throw ServerException(errors.join(', '));
    }
  }
}
