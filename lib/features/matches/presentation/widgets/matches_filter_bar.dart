import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/competition_catalog.dart';
import '../../logic/matches_bloc.dart';
import '../../logic/matches_event.dart';
import '../../logic/matches_state.dart';

class MatchesFilterBar extends StatelessWidget {
  const MatchesFilterBar({required this.state, super.key});

  final MatchesState state;

  @override
  Widget build(BuildContext context) {
    final selectedDate = state.selectedDate ?? DateTime.now();
    final selectedCompetition = CompetitionCatalog.byId(state.selectedLeagueId);
    final statuses =
        state.allMatches.map((match) => match.statusShort).toSet().toList()
          ..sort();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(context, selectedDate),
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(
                    state.isDateFilterActive
                        ? DateFormatter.short(selectedDate)
                        : 'All season',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.regular),
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: ValueKey(state.selectedSeason),
                  initialValue: state.selectedSeason,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Season',
                    border: OutlineInputBorder(),
                  ),
                  items: selectedCompetition == null
                      ? const []
                      : selectedCompetition.availableSeasons
                            .map(
                              (season) => DropdownMenuItem<int>(
                                value: season,
                                child: Text('$season'),
                              ),
                            )
                            .toList(),
                  onChanged: selectedCompetition == null
                      ? null
                      : (season) {
                          if (season == null) return;

                          context.read<MatchesBloc>().add(
                            MatchesRequested(
                              date: selectedDate,
                              leagueId: selectedCompetition.id,
                              season: season,
                              useDateFilter: state.isDateFilterActive,
                            ),
                          );
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.regular),
          TextField(
            onChanged: (query) =>
                context.read<MatchesBloc>().add(SearchQueryChanged(query)),
            decoration: const InputDecoration(
              labelText: 'Search teams or leagues',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.regular),
          DropdownButtonFormField<String?>(
            key: ValueKey(state.selectedStatus),
            initialValue: state.selectedStatus,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<String?>(value: null, child: Text('All')),
              ...statuses.map(
                (status) => DropdownMenuItem<String?>(
                  value: status,
                  child: Text(status),
                ),
              ),
            ],
            onChanged: (status) =>
                context.read<MatchesBloc>().add(StatusFilterChanged(status)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime selectedDate) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    final initialDate = selectedDate.isBefore(yesterday)
        ? yesterday
        : selectedDate.isAfter(today)
        ? today
        : DateUtils.dateOnly(selectedDate);

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: yesterday,
      lastDate: today,
    );

    if (date == null || !context.mounted) return;

    context.read<MatchesBloc>().add(
      MatchesRequested(
        date: date,
        leagueId: state.selectedLeagueId,
        season: state.selectedSeason,
        useDateFilter: true,
      ),
    );
  }
}
