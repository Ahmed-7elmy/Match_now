import 'league_model.dart';
import 'team_model.dart';

class MatchModel {
  const MatchModel({
    required this.id,
    required this.date,
    required this.status,
    required this.statusShort,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    this.venue,
    this.homeGoals,
    this.awayGoals,
  });

  final int id;
  final DateTime date;
  final String status;
  final String statusShort;
  final String? venue;
  final LeagueModel league;
  final TeamModel homeTeam;
  final TeamModel awayTeam;
  final int? homeGoals;
  final int? awayGoals;

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final fixture = json['fixture'] as Map<String, dynamic>? ?? const {};
    final fixtureStatus =
        fixture['status'] as Map<String, dynamic>? ?? const {};
    final fixtureLeague = json['league'] as Map<String, dynamic>? ?? const {};
    final teams = json['teams'] as Map<String, dynamic>? ?? const {};
    final goals = json['goals'] as Map<String, dynamic>? ?? const {};
    final venue = fixture['venue'] as Map<String, dynamic>?;
    final rawDate = fixture['date'] as String?;

    if (rawDate == null) {
      throw const FormatException('Fixture date is missing.');
    }

    return MatchModel(
      id: fixture['id'] as int,
      date: DateTime.parse(rawDate),
      status: fixtureStatus['long'] as String? ?? 'Unknown',
      statusShort: fixtureStatus['short'] as String? ?? 'NS',
      venue: venue?['name'] as String?,
      league: LeagueModel.fromJson(fixtureLeague),
      homeTeam: TeamModel.fromJson(
        teams['home'] as Map<String, dynamic>? ?? const {},
      ),
      awayTeam: TeamModel.fromJson(
        teams['away'] as Map<String, dynamic>? ?? const {},
      ),
      homeGoals: goals['home'] as int?,
      awayGoals: goals['away'] as int?,
    );
  }
}
