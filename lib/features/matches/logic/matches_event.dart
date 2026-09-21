import 'package:equatable/equatable.dart';

sealed class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object?> get props => [];
}

class MatchesRequested extends MatchesEvent {
  const MatchesRequested({
    required this.date,
    this.leagueId,
    this.season,
    this.useDateFilter = true,
    this.clearFilters = false,
  });

  final DateTime date;
  final int? leagueId;
  final int? season;
  final bool useDateFilter;
  final bool clearFilters;

  @override
  List<Object?> get props => [
    date,
    leagueId,
    season,
    useDateFilter,
    clearFilters,
  ];
}

class MatchesRefreshed extends MatchesEvent {
  const MatchesRefreshed({
    required this.date,
    this.leagueId,
    this.season,
    this.useDateFilter = true,
  });

  final DateTime date;
  final int? leagueId;
  final int? season;
  final bool useDateFilter;

  @override
  List<Object?> get props => [date, leagueId, season, useDateFilter];
}

class SearchQueryChanged extends MatchesEvent {
  const SearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class LeagueFilterChanged extends MatchesEvent {
  const LeagueFilterChanged(this.leagueId);

  final int? leagueId;

  @override
  List<Object?> get props => [leagueId];
}

class StatusFilterChanged extends MatchesEvent {
  const StatusFilterChanged(this.status);

  final String? status;

  @override
  List<Object?> get props => [status];
}

class FiltersCleared extends MatchesEvent {
  const FiltersCleared();
}
