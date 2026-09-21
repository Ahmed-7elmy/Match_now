class LeagueModel {
  const LeagueModel({
    required this.id,
    required this.name,
    this.country,
    this.logo,
    this.season,
    this.round,
  });

  final int id;
  final String name;
  final String? country;
  final String? logo;
  final int? season;
  final String? round;

  factory LeagueModel.fromJson(Map<String, dynamic> json) => LeagueModel(
    id: json['id'] as int,
    name: json['name'] as String? ?? 'Unknown League',
    country: json['country'] as String?,
    logo: json['logo'] as String?,
    season: json['season'] as int?,
    round: json['round'] as String?,
  );
}
