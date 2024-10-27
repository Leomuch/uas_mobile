import 'package:flutter/material.dart';

class MatchDetailPage extends StatelessWidget {
  const MatchDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final homeTeam = arguments['homeTeam'];
    final awayTeam = arguments['awayTeam'];
    final scoreA = arguments['scoreA'];
    final scoreB = arguments['scoreB'];
    final utcDate = arguments['utcDate'];
    final status = arguments['status'];
    final matchday = arguments['matchday'];

    return Scaffold(
      appBar: AppBar(title: Text('$homeTeam vs $awayTeam')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$homeTeam $scoreA - $scoreB $awayTeam'),
            Text('Tanggal: $utcDate'),
            Text('Status: $status'),
            Text('Matchday: $matchday'),
          ],
        ),
      ),
    );
  }
}
