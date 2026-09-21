import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/competition_catalog.dart';
import '../../logic/matches_bloc.dart';
import '../../logic/matches_event.dart';
import '../../logic/matches_state.dart';

class CompetitionQuickSelector extends StatelessWidget {
  const CompetitionQuickSelector({required this.state, super.key});

  final MatchesState state;

  @override
  Widget build(BuildContext context) {
    final selectedDate = state.selectedDate ?? DateTime.now();

    return SizedBox(
      height: AppDimensions.competitionSelectorHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
        itemCount: CompetitionCatalog.competitions.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.small),
        itemBuilder: (context, index) {
          final competition = CompetitionCatalog.competitions[index];
          final isSelected = state.selectedLeagueId == competition.id;
          final colorScheme = Theme.of(context).colorScheme;

          return SizedBox(
            width: AppDimensions.competitionTileWidth,
            child: Material(
              color: isSelected
                  ? colorScheme.secondaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.small),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.small),
                onTap: () => context.read<MatchesBloc>().add(
                  isSelected
                      ? MatchesRequested(date: selectedDate, clearFilters: true)
                      : MatchesRequested(
                          date: selectedDate,
                          leagueId: competition.id,
                          season: competition.defaultSeason,
                          useDateFilter: false,
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: AppDimensions.competitionLogoSize,
                        height: AppDimensions.competitionLogoSize,
                        child: Image.network(
                          competition.logoUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.emoji_events_outlined),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.compact),
                      Text(
                        competition.name,
                        textAlign: TextAlign.center,
                        maxLines: AppDimensions.teamNameMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
