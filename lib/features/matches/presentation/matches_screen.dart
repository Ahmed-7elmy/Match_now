import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../logic/matches_bloc.dart';
import '../logic/matches_event.dart';
import '../logic/matches_state.dart';
import 'widgets/competition_quick_selector.dart';
import 'widgets/match_card.dart';
import 'widgets/matches_filter_bar.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MatchesBloc>().add(MatchesRequested(date: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        actions: [
          BlocBuilder<MatchesBloc, MatchesState>(
            buildWhen: (previous, current) =>
                previous.selectedLeagueId != current.selectedLeagueId,
            builder: (context, state) {
              return IconButton(
                tooltip: "Today's fixtures",
                onPressed: state.selectedLeagueId == null
                    ? null
                    : () => context.read<MatchesBloc>().add(
                        MatchesRequested(
                          date: DateUtils.dateOnly(DateTime.now()),
                          clearFilters: true,
                        ),
                      ),
                icon: const Icon(Icons.today_outlined),
              );
            },
          ),
        ],
      ),
      body: BlocListener<MatchesBloc, MatchesState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure &&
            current.failure != null &&
            current.status != MatchesStatus.failure,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message)));
        },
        child: BlocBuilder<MatchesBloc, MatchesState>(
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MatchesState state) {
    switch (state.status) {
      case MatchesStatus.initial:
      case MatchesStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case MatchesStatus.failure:
        return _buildFailureState(context, state);
      case MatchesStatus.success:
        return _buildSuccessState(context, state);
    }
  }

  Widget _buildSuccessState(BuildContext context, MatchesState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MatchesBloc>().add(
          MatchesRefreshed(
            date: state.selectedDate ?? DateTime.now(),
            leagueId: state.selectedLeagueId,
            season: state.selectedSeason,
            useDateFilter: state.isDateFilterActive,
          ),
        );
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: CompetitionQuickSelector(state: state)),
          SliverToBoxAdapter(child: MatchesFilterBar(state: state)),
          if (state.filteredMatches.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No matches found.')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              sliver: SliverList.separated(
                itemCount: state.filteredMatches.length,
                itemBuilder: (context, index) =>
                    MatchCard(match: state.filteredMatches[index]),
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.regular),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFailureState(BuildContext context, MatchesState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MatchesBloc>().add(
          MatchesRefreshed(
            date: state.selectedDate ?? DateTime.now(),
            leagueId: state.selectedLeagueId,
            season: state.selectedSeason,
            useDateFilter: state.isDateFilterActive,
          ),
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height:
                MediaQuery.sizeOf(context).height *
                AppDimensions.failureContentHeightFactor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: AppDimensions.errorIconSize,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      state.failure?.message ?? 'Something went wrong.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.mediumLarge),
                    FilledButton(
                      onPressed: () => context.read<MatchesBloc>().add(
                        MatchesRequested(
                          date: state.selectedDate ?? DateTime.now(),
                          leagueId: state.selectedLeagueId,
                          season: state.selectedSeason,
                          useDateFilter: state.isDateFilterActive,
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
