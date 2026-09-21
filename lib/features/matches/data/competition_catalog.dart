class CompetitionConfig {
  const CompetitionConfig({
    required this.id,
    required this.name,
    required this.availableSeasons,
  });

  final int id;
  final String name;
  final List<int> availableSeasons;

  String get logoUrl => 'https://media.api-sports.io/football/leagues/$id.png';

  int get defaultSeason => availableSeasons.last;
}

class CompetitionCatalog {
  const CompetitionCatalog._();

  static const domesticSeasons = [2022, 2023, 2024];

  static const competitions = [
    CompetitionConfig(
      id: 39,
      name: 'Premier League',
      availableSeasons: domesticSeasons,
    ),
    CompetitionConfig(
      id: 140,
      name: 'La Liga',
      availableSeasons: domesticSeasons,
    ),
    CompetitionConfig(
      id: 135,
      name: 'Serie A',
      availableSeasons: domesticSeasons,
    ),
    CompetitionConfig(
      id: 78,
      name: 'Bundesliga',
      availableSeasons: domesticSeasons,
    ),
    CompetitionConfig(
      id: 61,
      name: 'Ligue 1',
      availableSeasons: domesticSeasons,
    ),
    CompetitionConfig(
      id: 233,
      name: 'Egyptian Premier League',
      availableSeasons: domesticSeasons,
    ),
    CompetitionConfig(id: 1, name: 'World Cup', availableSeasons: [2022]),
  ];

  static const supportedLeagueIds = {39, 140, 135, 78, 61, 233, 1};

  static CompetitionConfig? byId(int? id) {
    for (final competition in competitions) {
      if (competition.id == id) return competition;
    }

    return null;
  }
}
