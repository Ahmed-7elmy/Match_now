import 'package:eyego_project/features/matches/data/models/match_model.dart';
import 'package:eyego_project/features/matches/data/models/team_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MatchModel.fromJson', () {
    test('parses an API-Football fixture response item', () {
      final match = MatchModel.fromJson({
        'fixture': {
          'id': 1207997,
          'date': '2024-08-16T19:00:00+00:00',
          'status': {'long': 'Match Finished', 'short': 'FT'},
          'venue': {'name': 'Old Trafford'},
        },
        'league': {
          'id': 39,
          'name': 'Premier League',
          'country': 'England',
          'logo': 'https://example.com/league.png',
          'season': 2024,
          'round': 'Regular Season - 1',
        },
        'teams': {
          'home': {
            'id': 33,
            'name': 'Manchester United',
            'logo': 'https://example.com/home.png',
            'winner': true,
          },
          'away': {
            'id': 40,
            'name': 'Liverpool',
            'logo': 'https://example.com/away.png',
            'winner': false,
          },
        },
        'goals': {'home': 1, 'away': 0},
      });

      expect(match.id, 1207997);
      expect(match.league.id, 39);
      expect(match.date, DateTime.parse('2024-08-16T19:00:00+00:00'));
      expect(match.statusShort, 'FT');
      expect(match.venue, 'Old Trafford');
      expect(match.homeTeam.winner, isTrue);
      expect(match.awayGoals, 0);
    });
  });

  group('TeamModel.fromTeamResponse', () {
    test('parses a /teams response item', () {
      final team = TeamModel.fromTeamResponse({
        'team': {
          'id': 40,
          'name': 'Liverpool',
          'logo': 'https://example.com/liverpool.png',
        },
      });

      expect(team.id, 40);
      expect(team.name, 'Liverpool');
      expect(team.logo, 'https://example.com/liverpool.png');
      expect(team.winner, isNull);
    });
  });
}
