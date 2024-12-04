import 'package:flutter/material.dart';
import 'package:sofa_score/models/data.dart';
import 'package:sofa_score/models/fetch_match_detail.dart';
import 'package:intl/intl.dart';

import 'team.dart';

class MatchDetailPage extends StatefulWidget {
  const MatchDetailPage({super.key});

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadMatchData(int matchId) async {
    List<Map<String, dynamic>> fetchedMatches =
        await fetchMatchDetails(matchId);
    setState(() {
      matchDetail = fetchedMatches; // Menyimpan data yang diambil
      isLoading = false; // Mengubah status loading
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final matchId = arguments['id'] as int?;
    final area = arguments['area'];
    final competition = arguments['competition'];

    if (matchId != null && isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadMatchData(matchId);
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
                      Text('Wasit: ${matchDetail[0]['referee']}'),
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
