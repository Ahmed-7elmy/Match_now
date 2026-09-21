import '../../../core/errors/error_handler.dart';
import '../../../core/utils/result.dart';
import 'football_remote_data_source.dart';
import 'models/match_model.dart';

abstract interface class FootballRepository {
  Future<Result<List<MatchModel>>> getFixtures({
    int? leagueId,
    int? season,
    String? date,
  });
}

class FootballRepositoryImpl implements FootballRepository {
  FootballRepositoryImpl(this._remoteDataSource);

  // Gives the app fixture data without exposing how it is fetched.
  final FootballRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<MatchModel>>> getFixtures({
    int? leagueId,
    int? season,
    String? date,
  }) async {
    try {
      final matches = await _remoteDataSource.getFixtures(
        leagueId: leagueId,
        season: season,
        date: date,
      );

      return Success(matches);
    } catch (error) {
      return FailureResult(ErrorHandler.handle(error));
    }
  }
}
// The FootballRepositoryImpl class is responsible for fetching football match data from a remote data source. It implements the FootballRepository interface, which defines a method to get fixtures. The implementation uses a try-catch block to handle any exceptions that may occur during the data fetching process. If the data is fetched successfully, it returns a Success result containing the list of MatchModel objects. If an error occurs, it returns a FailureResult with the appropriate failure type handled by the ErrorHandler.
//the repository pattern is used to abstract the data fetching logic and provide a clean interface for the rest of the application to interact with.
//the
//repository pattern is used to abstract the data fetching logic and provide a clean interface for the rest of the application to interact with.
//will be used more in caching and local storage implementations, where the repository can decide whether to fetch data from a remote source or a local cache based on certain conditions.
