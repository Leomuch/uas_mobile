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
    final area = arguments['area'];
    final competition = arguments['competition'];
    final homeCrest = arguments['homeCrest'];
    final awayCrest = arguments['awayCrest'];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 50),
            Expanded(
              child: Text(
                '$area,  $competition, Ronde $matchday',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Row for displaying team crests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.network(homeCrest, width: 50, height: 50),
                    const SizedBox(height: 5),
                    Text(
                      '$homeTeam',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Text(
                  '$scoreA - $scoreB',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        Image.network(awayCrest, width: 50, height: 50),
                        const SizedBox(height: 5),
                        Text(
                          '$awayTeam',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20), // Add some spacing below crests
            // Other match details
            Text('Tanggal: $utcDate'),
            Text('Status: $status'),
            Text('Matchday: $matchday'),
          ],
        ),
      ),
    );
  }
}
