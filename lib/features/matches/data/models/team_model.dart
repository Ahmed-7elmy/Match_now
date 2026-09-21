class TeamModel {
  const TeamModel({
    required this.id,
    required this.name,
    this.logo,
    this.winner,
  });

  final int id;
  final String name;
  final String? logo;
  final bool? winner;

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
    id: json['id'] as int,
    name: json['name'] as String? ?? 'Unknown Team',
    logo: json['logo'] as String?,
    winner: json['winner'] as bool?,
  );

  factory TeamModel.fromTeamResponse(Map<String, dynamic> json) {
    final team = json['team'] as Map<String, dynamic>?;
    return TeamModel.fromJson(team ?? json);
  }
}
