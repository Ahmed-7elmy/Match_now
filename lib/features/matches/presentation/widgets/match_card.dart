import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/match_model.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({required this.match, super.key});

  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.league.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  _statusText(match.statusShort),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _statusColor(match.statusShort),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            Row(
              children: [
                Expanded(
                  child: _TeamView(
                    name: match.homeTeam.name,
                    logo: match.homeTeam.logo,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.regular,
                  ),
                  child: _ScoreView(
                    homeGoals: match.homeGoals,
                    awayGoals: match.awayGoals,
                    status: match.statusShort,
                    matchDate: match.date,
                  ),
                ),
                Expanded(
                  child: _TeamView(
                    name: match.awayTeam.name,
                    logo: match.awayTeam.logo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.schedule, size: AppSpacing.medium),
                const SizedBox(width: AppSpacing.compact),
                Text(
                  DateFormatter.time(match.date),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            if (match.venue != null) ...[
              const SizedBox(height: AppSpacing.small),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: AppSpacing.medium,
                  ),
                  const SizedBox(width: AppSpacing.compact),
                  Flexible(
                    child: Text(
                      match.venue!,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'NS':
        return 'Not Started';
      case '1H':
        return '1st Half';
      case 'HT':
        return 'Half Time';
      case '2H':
        return '2nd Half';
      case 'FT':
        return 'Finished';
      case 'AET':
        return 'After Extra Time';
      case 'PEN':
        return 'Penalties';
      case 'PST':
        return 'Postponed';
      case 'CANC':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color _statusColor(String status) => switch (status) {
    '1H' || 'HT' || '2H' || 'LIVE' => AppColors.error,
    'NS' => AppColors.primary,
    _ => AppColors.textSecondary,
  };
}

class _TeamView extends StatelessWidget {
  const _TeamView({required this.name, this.logo});

  final String name;
  final String? logo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: AppDimensions.teamLogoSize,
          height: AppDimensions.teamLogoSize,
          child: logo == null
              ? const Icon(Icons.sports_soccer)
              : Image.network(
                  logo!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(Icons.sports_soccer),
                ),
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: AppDimensions.teamNameMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ScoreView extends StatelessWidget {
  const _ScoreView({
    required this.homeGoals,
    required this.awayGoals,
    required this.status,
    required this.matchDate,
  });

  final int? homeGoals;
  final int? awayGoals;
  final String status;
  final DateTime matchDate;

  @override
  Widget build(BuildContext context) {
    final hasScore = homeGoals != null && awayGoals != null;
    final label = hasScore
        ? '$homeGoals - $awayGoals'
        : DateFormatter.time(matchDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.extraSmall),
        Text(status, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
