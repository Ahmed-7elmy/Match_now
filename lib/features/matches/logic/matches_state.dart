import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../data/models/match_model.dart';

enum MatchesStatus { initial, loading, success, failure }

class MatchesState extends Equatable {
  const MatchesState({
    this.status = MatchesStatus.initial,
    this.allMatches = const [],
    this.filteredMatches = const [],
    this.searchQuery = '',
    this.selectedDate,
    this.isDateFilterActive = true,
    this.selectedLeagueId,
    this.selectedSeason,
    this.selectedStatus,
    this.failure,
    this.isRefreshing = false,
  });

  final MatchesStatus status;
  final List<MatchModel> allMatches; //for api quota
  final List<MatchModel> filteredMatches;
  final String searchQuery;
  final DateTime? selectedDate;
  final bool isDateFilterActive;
  final int? selectedLeagueId;
  final int? selectedSeason;
  final String? selectedStatus;
  final Failure? failure;
  final bool isRefreshing;

  MatchesState copyWith({
    MatchesStatus? status,
    List<MatchModel>? allMatches,
    List<MatchModel>? filteredMatches,
    String? searchQuery,
    DateTime? selectedDate,
    bool? isDateFilterActive,
    int? selectedLeagueId,
    int? selectedSeason,
    String? selectedStatus,
    Failure? failure,
    bool clearFailure = false,
    bool clearLeagueFilter = false,
    bool clearSeasonFilter = false,
    bool clearStatusFilter = false,
    bool? isRefreshing,
  }) {
    return MatchesState(
      status: status ?? this.status,
      allMatches: allMatches ?? this.allMatches,
      filteredMatches: filteredMatches ?? this.filteredMatches,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDate: selectedDate ?? this.selectedDate,
      isDateFilterActive: isDateFilterActive ?? this.isDateFilterActive,
      selectedLeagueId: clearLeagueFilter
          ? null
          : selectedLeagueId ?? this.selectedLeagueId,
      selectedSeason: clearSeasonFilter
          ? null
          : selectedSeason ?? this.selectedSeason,
      selectedStatus: clearStatusFilter
          ? null
          : selectedStatus ?? this.selectedStatus,
      failure: clearFailure ? null : failure ?? this.failure,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allMatches,
    filteredMatches,
    searchQuery,
    selectedDate,
    isDateFilterActive,
    selectedLeagueId,
    selectedSeason,
    selectedStatus,
    failure,
    isRefreshing,
  ];
}
