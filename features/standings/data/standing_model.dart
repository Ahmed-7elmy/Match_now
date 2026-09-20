import '../../matches/data/team_model.dart';

class StandingModel {
  const StandingModel({
    required this.position,
    required this.team,
    required this.points,
  });

  final int position;
  final TeamModel team;
  final int points;
}
