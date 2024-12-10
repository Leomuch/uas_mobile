import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sofa_score/models/data.dart';
import 'package:sofa_score/models/fetch_league_standing.dart';
import 'package:sofa_score/models/fetch_match_detail.dart';
import 'package:intl/intl.dart';

import '../models/fetch_last_five.dart';

class MatchDetailPage extends StatefulWidget {
  const MatchDetailPage({super.key});

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  bool isLoading = true;
  bool isPredictionLoading = false;
  late int idHome;
  late int idAway;
  late int matchday;
  List<Map<String, dynamic>> lastFiveMatches = [];
  List<Map<String, dynamic>> lastResult = [];
  String? predictionResult;

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendDataForPrediction(int homeTeamId, int awayTeamId) async {
    const apiUrl = 'https://condatest.loca.lt/api/predict';
    const headers = {'Content-Type': 'application/json'};

    await fetchLeagueStandings();

    final homeTeamData = leagueData.firstWhere(
      (team) => team['idTeam'] == idHome,
      orElse: () => {},
    );

    final awayTeamData = leagueData.firstWhere(
      (team) => team['idTeam'] == idAway,
      orElse: () => {},
    );

    final homeTeamGD = homeTeamData['goalDifference'];
    final awayTeamGD = awayTeamData['goalDifference'];
    final homeTeamPoint = homeTeamData['points'];
    final awayTeamPoint = awayTeamData['points'];
    final difFromPTS = homeTeamPoint - awayTeamPoint;
    List<String> lastThreeHomeResults = [];
    List<String> lastThreeAwayResults = [];

    if (lastResult.isNotEmpty) {
      lastThreeHomeResults =
          lastResult[0]['matches'].take(3).map<String>((match) {
        var result = match['result'];
        if (result is String) {
          return result;
        } else {
          return ''; // return empty string if it's not a string
        }
      }).toList();

      lastThreeAwayResults =
          lastResult[1]['matches'].take(3).map<String>((match) {
        var result = match['result'];
        if (result is String) {
          return result;
        } else {
          return '';
        }
      }).toList();
    }

    // Data yang akan dikirim ke API prediksi
    final Map<String, dynamic> inputData = {
      "data": [
        homeTeamGD,
        awayTeamGD,
        homeTeamPoint,
        awayTeamPoint,
        difFromPTS,
        ...lastThreeHomeResults,
        ...lastThreeAwayResults,
      ]
    };
    print('Input data: $inputData');

    try {
      setState(() {
        isPredictionLoading = true;
      });

      // Kirim POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Cek respons API
        print('Response data: $responseData');

        setState(() {
          predictionResult =
              'Home Win: ${responseData['prediction'][0][0].toStringAsFixed(2)}%, Away Win: ${responseData['prediction'][0][1].toStringAsFixed(2)}%';
        });
      } else {
        setState(() {
          predictionResult = 'Failed to fetch prediction';
        });
      }
    } catch (error) {
      setState(() {
        predictionResult = 'Error: $error';
      });
    } finally {
      setState(() {
        isPredictionLoading = false;
      });
    }
  }

  Future<void> loadMatchData(int matchId) async {
    List<Map<String, dynamic>> fetchedMatches =
        await fetchMatchDetails(matchId);
    print(fetchedMatches);
    setState(() {
      matchDetail = fetchedMatches[0]['data'];
      isLoading = false;
    });
  }

  void fetchMatches(int idHome, int idAway) async {
    try {
      var homeResults = await getLastFiveHomeMatchResults(idHome, matchday);
      var awayResults = await getLastFiveAwayMatchResults(idAway, matchday);
      List<Map<String, dynamic>> getResults(
          List<Map<String, dynamic>> results) {
        return results.map((match) {
          return {
            'result': match['result'],
          };
        }).toList();
      }

      List<Map<String, dynamic>> homeResultsOnly = getResults(homeResults);
      List<Map<String, dynamic>> awayResultsOnly = getResults(awayResults);

      setState(() {
        // Menggabungkan hasil pertandingan home dan away ke dalam satu list
        lastFiveMatches = [
          {'label': 'Home Matches', 'matches': homeResults},
          {'label': 'Away Matches', 'matches': awayResults},
        ];
        lastResult = [
          {'label': 'Home Matches', 'matches': homeResultsOnly},
          {'label': 'Away Matches', 'matches': awayResultsOnly},
        ];
        print('Last Five Matches: $lastFiveMatches');
        print('Last Three Matches: $lastResult');
      });
      sendDataForPrediction(idHome, idAway);
    } catch (error) {
      print('Error fetching matches: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final matchId = arguments['id'] as int?;
    final area = arguments['area'];
    final competition = arguments['competition'];

    if (matchId != null && isLoading) {
      idHome = arguments['idHome']; // Mengambil idHome dari arguments
      idAway = arguments['idAway']; // Mengambil idAway dari arguments
      matchday = arguments['matchday']; // Mengambil idAway dari arguments

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          fetchMatches(idHome, idAway);
          loadMatchData(matchId);
          // sendDataForPrediction(idHome, idAway);
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/league_standing', arguments: {
                'area': area,
                'competition': competition,
              });
            },
            child: matchDetail.isNotEmpty
                ? Text(
                    '${matchDetail[0]['area']}, ${matchDetail[0]['competition']}, Ronde ${matchDetail[0]['matchday']}',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  )
                : const Text('Loading match details...'),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchDetail.isEmpty
              ? const Center(child: Text('No match data available.'))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                          'Tanggal: ${_formatDate(matchDetail[0]['utcDate'])}'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/team',
                                arguments: {
                                  'id': matchDetail[0]['idHome'],
                                  'name': matchDetail[0]['homeTeamF'],
                                  'crest': matchDetail[0]['homeCrest'],
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  matchDetail[0]['homeCrest'],
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${matchDetail[0]['homeTeam']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${matchDetail[0]['scoreHome']} - ${matchDetail[0]['scoreAway']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/team',
                                arguments: {
                                  'id': matchDetail[0]['idAway'],
                                  'name': matchDetail[0]['awayTeamF'],
                                  'crest': matchDetail[0]['awayCrest'],
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  matchDetail[0]['awayCrest'],
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${matchDetail[0]['awayTeam']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Status: ${matchDetail[0]['status']}'),
                      Text('Matchday: ${matchDetail[0]['matchday']}'),
                      Text(
                          'Wasit: ${matchDetail[0]['referee'] ?? 'Wasit belum ditentukan'}'),
                      const SizedBox(height: 20),
                      lastFiveMatches.isEmpty
                          ? const Text('Loading last five matches...')
                          : Column(
                              children: lastFiveMatches.map((matchData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(matchData['label']),
                                    ...matchData['matches'].map((match) {
                                      return Text(
                                          'Home: ${match['homeTeam']} vs Away: ${match['awayTeam']} - Score: ${match['scoreA']} - ${match['scoreB']} Result: ${match['result']}');
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                            ),
                      if (isPredictionLoading)
                        const CircularProgressIndicator(),
                      if (predictionResult != null) ...[
                        const SizedBox(height: 20),
                        Text('Prediction: $predictionResult'),
                      ],
                    ],
                  ),
                ),
    );
  }
}

// Fungsi untuk memformat tanggal
String _formatDate(String utcDate) {
  DateTime dateTime = DateTime.parse(utcDate);
  return DateFormat('d MMMM yyyy').format(dateTime);
}
