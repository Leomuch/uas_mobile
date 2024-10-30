import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sofa_score/models/data.dart';

Future<List<Map<String, dynamic>>> fetchLeagueStandings() async {
  const url = 'https://api.football-data.org/v4/competitions/PD/standings';
  const headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List standing = data['standings'][0]['table'] ?? [];

      for (var team in standing) {
        leagueData.add({
          'position': team['position'],
          'teamName': team['team']['shortName'] ?? team['team']['name'],
          'points': team['points'],
          'playedGames': team['playedGames'],
          'wins': team['won'],
          'draws': team['draw'],
          'losses': team['lost'],
          'goalDifference': team['goalDifference'],
          'crestUrl': team['team']['crest'],
        });
      }

      return leagueData;
    } else {
      if (kDebugMode) {
        print('Failed to load matches: ${response.statusCode}');
      }
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching match data: $e');
    }
    return [];
  }
}
