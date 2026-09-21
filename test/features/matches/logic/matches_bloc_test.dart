import 'package:eyego_project/core/utils/result.dart';
import 'package:eyego_project/features/matches/data/football_repository.dart';
import 'package:eyego_project/features/matches/data/models/league_model.dart';
import 'package:eyego_project/features/matches/data/models/match_model.dart';
import 'package:eyego_project/features/matches/data/models/team_model.dart';
import 'package:eyego_project/features/matches/logic/matches_bloc.dart';
import 'package:eyego_project/features/matches/logic/matches_event.dart';
import 'package:eyego_project/features/matches/logic/matches_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps all fixtures from the initial daily request', () async {
    final repository = _FakeFootballRepository(
      matches: [
        ..._matches,
        _match(
          id: 4,
          homeTeam: 'Unknown Team',
          awayTeam: 'Another Team',
          leagueId: 2,
          leagueName: 'Unsupported League',
          statusShort: 'NS',
        ),
      ],
    );
    final bloc = MatchesBloc(repository: repository);
    addTearDown(bloc.close);

    final loaded = bloc.stream.firstWhere(
      (state) => state.status == MatchesStatus.success,
    );
    bloc.add(MatchesRequested(date: DateTime(2024, 5, 1)));
    final state = await loaded;

    expect(state.allMatches, hasLength(4));
    expect(repository.requests.single, (
      leagueId: null,
      season: null,
      date: '2024-05-01',
    ));
  });

  test('requests selected competition with its season and date', () async {
    final repository = _FakeFootballRepository();
    final bloc = MatchesBloc(repository: repository);
    addTearDown(bloc.close);

    final loaded = bloc.stream.firstWhere(
      (state) => state.status == MatchesStatus.success,
    );
    bloc.add(
      MatchesRequested(date: DateTime(2024, 5, 1), leagueId: 39, season: 2024),
    );
    await loaded;

    expect(repository.requests.single, (
      leagueId: 39,
      season: 2024,
      date: '2024-05-01',
    ));
  });

  test(
    'quick competition request omits date until the user selects one',
    () async {
      final repository = _FakeFootballRepository();
      final bloc = MatchesBloc(repository: repository);
      addTearDown(bloc.close);

      final loaded = bloc.stream.firstWhere(
        (state) => state.status == MatchesStatus.success,
      );
      bloc.add(
        MatchesRequested(
          date: DateTime(2026, 9, 21),
          leagueId: 78,
          season: 2024,
          useDateFilter: false,
        ),
      );
      await loaded;

      expect(repository.requests.single, (
        leagueId: 78,
        season: 2024,
        date: null,
      ));
    },
  );

  test(
    'reuses cached fixtures for a repeated quick competition request',
    () async {
      final repository = _FakeFootballRepository();
      final bloc = MatchesBloc(repository: repository);
      addTearDown(bloc.close);

      final firstLoaded = bloc.stream.firstWhere(
        (state) => state.status == MatchesStatus.success,
      );
      final quickRequest = MatchesRequested(
        date: DateTime(2026, 9, 21),
        leagueId: 78,
        season: 2024,
        useDateFilter: false,
      );
      bloc.add(quickRequest);
      await firstLoaded;

      final cachedLoaded = bloc.stream.firstWhere(
        (state) => state.status == MatchesStatus.success,
      );
      bloc.add(quickRequest);
      await cachedLoaded;

      expect(repository.requests, hasLength(1));
    },
  );

  test(
    'combines search, league, and status filters from cached matches',
    () async {
      final bloc = MatchesBloc(repository: _FakeFootballRepository());
      addTearDown(bloc.close);

      final loaded = bloc.stream.firstWhere(
        (state) => state.status == MatchesStatus.success,
      );
      bloc.add(MatchesRequested(date: DateTime(2026, 9, 20)));
      await loaded;

      final searched = bloc.stream.firstWhere(
        (state) => state.searchQuery == 'united',
      );
      bloc.add(const SearchQueryChanged('united'));
      expect((await searched).filteredMatches, hasLength(2));

      final leagueFiltered = bloc.stream.firstWhere(
        (state) => state.selectedLeagueId == 39,
      );
      bloc.add(const LeagueFilterChanged(39));
      final leagueState = await leagueFiltered;
      expect(leagueState.filteredMatches, hasLength(1));
      expect(
        leagueState.filteredMatches.single.homeTeam.name,
        'Manchester United',
      );

      final statusFiltered = bloc.stream.firstWhere(
        (state) => state.selectedStatus == 'FT',
      );
      bloc.add(const StatusFilterChanged('FT'));
      expect((await statusFiltered).filteredMatches, hasLength(1));

      final cleared = bloc.stream.firstWhere(
        (state) =>
            state.searchQuery.isEmpty &&
            state.selectedLeagueId == null &&
            state.selectedStatus == null,
      );
      bloc.add(const FiltersCleared());
      expect((await cleared).filteredMatches, hasLength(3));
    },
  );
}

class _FakeFootballRepository implements FootballRepository {
  _FakeFootballRepository({List<MatchModel>? matches})
    : _fixtures = matches ?? _matches;

  final List<MatchModel> _fixtures;
  final requests = <({int? leagueId, int? season, String? date})>[];

  @override
  Future<Result<List<MatchModel>>> getFixtures({
    int? leagueId,
    int? season,
    String? date,
  }) async {
    requests.add((leagueId: leagueId, season: season, date: date));
    return Success(_fixtures);
  }
}

final _matches = [
  _match(
    id: 1,
    homeTeam: 'Manchester United',
    awayTeam: 'Arsenal',
    leagueId: 39,
    leagueName: 'Premier League',
    statusShort: 'FT',
  ),
  _match(
    id: 2,
    homeTeam: 'Manchester United',
    awayTeam: 'Barcelona',
    leagueId: 135,
    leagueName: 'Serie A',
    statusShort: 'FT',
  ),
  _match(
    id: 3,
    homeTeam: 'Leeds',
    awayTeam: 'Manchester City',
    leagueId: 39,
    leagueName: 'Premier League',
    statusShort: 'NS',
  ),
];

MatchModel _match({
  required int id,
  required String homeTeam,
  required String awayTeam,
  required int leagueId,
  required String leagueName,
  required String statusShort,
}) {
  return MatchModel(
    id: id,
    date: DateTime(2026, 9, 20),
    status: statusShort == 'FT' ? 'Finished' : 'Not Started',
    statusShort: statusShort,
    league: LeagueModel(id: leagueId, name: leagueName),
    homeTeam: TeamModel(id: id * 10, name: homeTeam),
    awayTeam: TeamModel(id: id * 10 + 1, name: awayTeam),
  );
}
