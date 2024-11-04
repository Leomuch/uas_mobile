import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sofa_score/models/data.dart';

Future<List<Map<String, dynamic>>> fetchMatchDetails(int matchId) async {
  final url = 'https://api.football-data.org/v4/matches/$matchId';
  final headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  matchDetail.clear();

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);
      } // Debugging untuk melihat isi respons

      final referee = data['referees']?.firstWhere(
        (ref) => ref['type'] == 'REFEREE',
        orElse: () => null,
      )?['name'];

      // Mengambil informasi umum pertandingan
      var matchInfo = {
        'id': data['id'],
        'status': data['status'],
        'utcDate': data['utcDate'],
        'minute': data['minute'] ?? 0,
        'injuryTime': data['injuryTime'] ?? 0,
        'venue': data['venue'],
        'matchday': data['matchday'] ?? 0,
        'area': data['area']['name'],
        'competition': data['competition']['name'],
        'homeTeam': data['homeTeam']['shortName'],
        'awayTeam': data['awayTeam']['shortName'],
        'homeCrest': data['homeTeam']['crest'],
        'awayCrest': data['awayTeam']['crest'],
        'homeCoach': data['homeTeam']['coach']?['name'],
        'awayCoach': data['awayTeam']['coach']?['name'],
        'formationHome': data['homeTeam']['formation'],
        'referee': referee,
        'scoreHome': data['score']['fullTime']['home'] ?? 0,
        'scoreAway': data['score']['fullTime']['away'] ?? 0,
        'goals': data['goals'],
        // 'goals': data['goals']?.map<Map<String, dynamic>>((goal) {
        //       return {
        //         'minute': goal['minute'],
        //         'injuryTime': goal['injuryTime'],
        //         'type': goal['type'],
        //         'team': goal['team']['name'],
        //         'scorer': goal['scorer']['name'],
        //         'assist': goal['assist']?['name'],
        //         'scoreHome': goal['score']['home'],
        //         'scoreAway': goal['score']['away'],
        //       };
        //     }).toList() ??
        //     [],
      };

      matchDetail.add(matchInfo);

      return matchDetail;
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
