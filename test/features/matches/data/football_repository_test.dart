import 'package:eyego_project/core/errors/exceptions.dart';
import 'package:eyego_project/core/errors/failures.dart';
import 'package:eyego_project/core/utils/result.dart';
import 'package:eyego_project/features/matches/data/football_remote_data_source.dart';
import 'package:eyego_project/features/matches/data/football_repository.dart';
import 'package:eyego_project/features/matches/data/models/match_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FootballRepositoryImpl', () {
    test(
      'returns Success when the remote data source returns fixtures',
      () async {
        final repository = FootballRepositoryImpl(
          _StubFootballRemoteDataSource(fixtures: const []),
        );

        final result = await repository.getFixtures();

        expect(result, isA<Success<List<MatchModel>>>());
        expect((result as Success<List<MatchModel>>).data, isEmpty);
      },
    );

    test('maps remote exceptions to FailureResult', () async {
      final repository = FootballRepositoryImpl(
        _StubFootballRemoteDataSource(
          error: const NetworkException('Connection unavailable.'),
        ),
      );

      final result = await repository.getFixtures();

      expect(result, isA<FailureResult<List<MatchModel>>>());
      expect(
        (result as FailureResult<List<MatchModel>>).failure,
        isA<NetworkFailure>(),
      );
    });
  });
}

class _StubFootballRemoteDataSource implements FootballRemoteDataSource {
  const _StubFootballRemoteDataSource({this.fixtures = const [], this.error});

  final List<MatchModel> fixtures;
  final Object? error;

  @override
  Future<List<MatchModel>> getFixtures({
    int? leagueId,
    int? season,
    String? date,
  }) async {
    if (error != null) {
      throw error!;
    }

    return fixtures;
  }
}
