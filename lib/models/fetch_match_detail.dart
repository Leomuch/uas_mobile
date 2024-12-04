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
        print("Home Team Lineup: ${data['homeTeam']['lineup']}");
        print("Away Team Lineup: ${data['awayTeam']['lineup']}");
      }

      if (kDebugMode) {
        print(data);
      }

      final referee = data['referees']?.firstWhere(
        (ref) => ref['type'] == 'REFEREE',
        orElse: () => null,
      )?['name'];

      // Mengambil lineup tim rumah
      List<dynamic> homeLineup = data['homeTeam']['lineup'] ?? [];
      // Mengambil lineup tim tandang
      List<dynamic> awayLineup = data['awayTeam']['lineup'] ?? [];

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
        'homeLineup': homeLineup, // Menambahkan lineup tim rumah
        'awayLineup': awayLineup, // Menambahkan lineup tim tandang
      };

      if (kDebugMode) {
        print(matchInfo);
      }
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
