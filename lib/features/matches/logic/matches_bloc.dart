import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/result.dart';
import '../data/football_repository.dart';
import '../data/models/match_model.dart';
import 'matches_event.dart';
import 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  MatchesBloc({required this.repository}) : super(const MatchesState()) {
    on<MatchesRequested>(_onMatchesRequested);
    on<MatchesRefreshed>(_onMatchesRefreshed);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<LeagueFilterChanged>(_onLeagueFilterChanged);
    on<StatusFilterChanged>(_onStatusFilterChanged);
    on<FiltersCleared>(_onFiltersCleared);
  }

  final FootballRepository repository;
  final _fixtureCache = <String, List<MatchModel>>{};

  Future<void> _onMatchesRequested(
    MatchesRequested event,
    Emitter<MatchesState> emit,
  ) async {
    if (state.status == MatchesStatus.loading) return;

    if (event.clearFilters) {
      emit(
        MatchesState(status: MatchesStatus.loading, selectedDate: event.date),
      );
    } else {
      emit(
        state.copyWith(
          status: MatchesStatus.loading,
          selectedDate: event.date,
          isDateFilterActive: event.useDateFilter,
          selectedLeagueId: event.leagueId,
          selectedSeason: event.season,
          clearFailure: true,
        ),
      );
    }

    final cacheKey = _cacheKey(
      leagueId: event.leagueId,
      season: event.season,
      date: event.date,
      useDateFilter: event.useDateFilter,
    );
    final cachedMatches = _fixtureCache[cacheKey];

    if (cachedMatches != null) {
      emit(_loadedState(cachedMatches, isRefreshing: false));
      return;
    }

    final result = await repository.getFixtures(
      leagueId: event.leagueId,
      season: event.season,
      date: event.useDateFilter ? DateFormatter.apiDate(event.date) : null,
    );

    switch (result) {
      case Success(data: final matches):
        _fixtureCache[cacheKey] = List<MatchModel>.unmodifiable(matches);
        emit(_loadedState(matches, isRefreshing: false));
      case FailureResult(failure: final failure):
        emit(state.copyWith(status: MatchesStatus.failure, failure: failure));
    }
  }

  Future<void> _onMatchesRefreshed(
    MatchesRefreshed event,
    Emitter<MatchesState> emit,
  ) async {
    if (state.isRefreshing) return;

    emit(
      state.copyWith(
        isRefreshing: true,
        selectedDate: event.date,
        isDateFilterActive: event.useDateFilter,
        selectedLeagueId: event.leagueId,
        selectedSeason: event.season,
        clearFailure: true,
      ),
    );

    final result = await repository.getFixtures(
      leagueId: event.leagueId,
      season: event.season,
      date: event.useDateFilter ? DateFormatter.apiDate(event.date) : null,
    );

    switch (result) {
      case Success(data: final matches):
        _fixtureCache[_cacheKey(
          leagueId: event.leagueId,
          season: event.season,
          date: event.date,
          useDateFilter: event.useDateFilter,
        )] = List<MatchModel>.unmodifiable(
          matches,
        );
        emit(_loadedState(matches, isRefreshing: false));
      case FailureResult(failure: final failure):
        emit(state.copyWith(failure: failure, isRefreshing: false));
    }
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<MatchesState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredMatches: _applyFilters(
          matches: state.allMatches,
          searchQuery: event.query,
          leagueId: state.selectedLeagueId,
          status: state.selectedStatus,
        ),
      ),
    );
  }

  void _onLeagueFilterChanged(
    LeagueFilterChanged event,
    Emitter<MatchesState> emit,
  ) {
    emit(
      state.copyWith(
        selectedLeagueId: event.leagueId,
        filteredMatches: _applyFilters(
          matches: state.allMatches,
          searchQuery: state.searchQuery,
          leagueId: event.leagueId,
          status: state.selectedStatus,
        ),
      ),
    );
  }

  void _onStatusFilterChanged(
    StatusFilterChanged event,
    Emitter<MatchesState> emit,
  ) {
    emit(
      state.copyWith(
        selectedStatus: event.status,
        filteredMatches: _applyFilters(
          matches: state.allMatches,
          searchQuery: state.searchQuery,
          leagueId: state.selectedLeagueId,
          status: event.status,
        ),
      ),
    );
  }

  void _onFiltersCleared(FiltersCleared event, Emitter<MatchesState> emit) {
    emit(
      state.copyWith(
        filteredMatches: state.allMatches,
        searchQuery: '',
        clearLeagueFilter: true,
        clearSeasonFilter: true,
        clearStatusFilter: true,
      ),
    );
  }

  MatchesState _loadedState(
    List<MatchModel> matches, {
    required bool isRefreshing,
  }) {
    return state.copyWith(
      status: MatchesStatus.success,
      allMatches: matches,
      filteredMatches: _applyFilters(
        matches: matches,
        searchQuery: state.searchQuery,
        leagueId: state.selectedLeagueId,
        status: state.selectedStatus,
      ),
      isRefreshing: isRefreshing,
      clearFailure: true,
    );
  }

  List<MatchModel> _applyFilters({
    required List<MatchModel> matches,
    required String searchQuery,
    required int? leagueId,
    required String? status,
  }) {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    return matches.where((match) {
      final matchesSearch =
          normalizedQuery.isEmpty ||
          match.homeTeam.name.toLowerCase().contains(normalizedQuery) ||
          match.awayTeam.name.toLowerCase().contains(normalizedQuery) ||
          match.league.name.toLowerCase().contains(normalizedQuery);
      final matchesLeague = leagueId == null || match.league.id == leagueId;
      final matchesStatus = status == null || match.statusShort == status;

      return matchesSearch && matchesLeague && matchesStatus;
    }).toList();
  }

  String _cacheKey({
    required int? leagueId,
    required int? season,
    required DateTime date,
    required bool useDateFilter,
  }) {
    final datePart = useDateFilter ? DateFormatter.apiDate(date) : 'all';

    return '$leagueId:$season:$datePart';
  }
}
