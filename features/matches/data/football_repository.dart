import 'football_remote_data_source.dart';

abstract interface class FootballRepository {
  Future<void> getMatches();
}

class FootballRepositoryImpl implements FootballRepository {
  FootballRepositoryImpl(this._remoteDataSource);

  final FootballRemoteDataSource _remoteDataSource;

  @override
  Future<void> getMatches() => _remoteDataSource.getMatches();
}
