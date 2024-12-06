import 'package:flutter/foundation.dart';
import 'fetch_match_team.dart';

// Fungsi untuk memparsing hasil pertandingan dan mengambil 5 pertandingan home terakhir
List<Map<String, dynamic>> parseLastFiveHomeMatches(List<Map<String, dynamic>> matches, int teamId) {
  List<Map<String, dynamic>> lastFiveHomeMatches = [];

  // Ambil 5 pertandingan terakhir yang sesuai dengan tim dan home (tim sebagai tuan rumah)
  for (var match in matches.take(5)) {
    if (match['idHome'] == teamId || match['idAway'] == teamId) {
      var result = '';

      // Tentukan hasil pertandingan (Win, Lose, Draw)
      if (match['idHome'] == teamId) {
        // Tim sebagai tuan rumah
        if (match['scoreA'] > match['scoreB']) {
          result = 'Win';
        } else if (match['scoreA'] < match['scoreB']) {
          result = 'Lose';
        } else {
          result = 'Draw';
        }
      } else if (match['idAway'] == teamId) {
        // Tim sebagai tamu
        if (match['scoreB'] > match['scoreA']) {
          result = 'Win';
        } else if (match['scoreB'] < match['scoreA']) {
          result = 'Lose';
        } else {
          result = 'Draw';
        }
      }

      lastFiveHomeMatches.add({
        'idHome': match['idHome'],
        'idAway': match['idAway'],
        'homeTeam': match['homeTeam'],
        'awayTeam': match['awayTeam'],
        'scoreA': match['scoreA'],
        'scoreB': match['scoreB'],
        'result': result, // Menyimpan hasil pertandingan
        'utcDate': match['utcDate'],
      });
    }
  }

  return lastFiveHomeMatches;
}

// Fungsi untuk memparsing hasil pertandingan dan mengambil 5 pertandingan away terakhir
List<Map<String, dynamic>> parseLastFiveAwayMatches(List<Map<String, dynamic>> matches, int teamId) {
  List<Map<String, dynamic>> lastFiveAwayMatches = [];

  // Ambil 5 pertandingan terakhir yang sesuai dengan tim dan away (tim sebagai tamu)
  for (var match in matches.take(5)) {
    if (match['idAway'] == teamId || match['idHome'] == teamId) {
      var result = '';

      // Tentukan hasil pertandingan (Win, Lose, Draw)
      if (match['idAway'] == teamId) {
        // Tim sebagai tuan rumah
        if (match['scoreB'] > match['scoreA']) {
          result = 'Win';
        } else if (match['scoreB'] < match['scoreA']) {
          result = 'Lose';
        } else {
          result = 'Draw';
        }
      } else if (match['idHome'] == teamId) {
        // Tim sebagai tamu
        if (match['scoreA'] > match['scoreB']) {
          result = 'Win';
        } else if (match['scoreA'] < match['scoreB']) {
          result = 'Lose';
        } else {
          result = 'Draw';
        }
      }

      lastFiveAwayMatches.add({
        'idHome': match['idHome'],
        'idAway': match['idAway'],
        'homeTeam': match['homeTeam'],
        'awayTeam': match['awayTeam'],
        'scoreA': match['scoreA'],
        'scoreB': match['scoreB'],
        'result': result, // Menyimpan hasil pertandingan
        'utcDate': match['utcDate'],
      });
    }
  }

  return lastFiveAwayMatches;
}

// Fungsi untuk mengambil dan memparsing data dari fetchMatchesForTeam untuk home matches
Future<List<Map<String, dynamic>>> getLastFiveHomeMatchResults(int teamId) async {
  try {
    // Ambil data pertandingan untuk tim dengan ID yang diberikan
    var matches = await fetchMatchesForTeam(teamId);

    // Parsing dan ambil 5 pertandingan home terakhir
    return parseLastFiveHomeMatches(matches, teamId);
  } catch (e) {
    if (kDebugMode) {
      print('Error parsing home matches: $e');
    }
    return [];
  }
}

// Fungsi untuk mengambil dan memparsing data dari fetchMatchesForTeam untuk away matches
Future<List<Map<String, dynamic>>> getLastFiveAwayMatchResults(int teamId) async {
  try {
    // Ambil data pertandingan untuk tim dengan ID yang diberikan
    var matches = await fetchMatchesForTeam(teamId);

    // Parsing dan ambil 5 pertandingan away terakhir
    return parseLastFiveAwayMatches(matches, teamId);
  } catch (e) {
    if (kDebugMode) {
      print('Error parsing away matches: $e');
    }
    return [];
  }
}
