import 'team_model.dart';

class MatchModel {
  const MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
  });

  final int id;
  final TeamModel homeTeam;
  final TeamModel awayTeam;
  final DateTime kickoff;
}
