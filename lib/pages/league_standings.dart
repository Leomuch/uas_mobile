import 'package:flutter/material.dart';
import 'package:sofa_score/models/fetch_league_standing.dart';

class LeagueStandings extends StatelessWidget {
  const LeagueStandings({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final area = arguments['area'];
    final competition = arguments['competition'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$competition Standings - $area'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchLeagueStandings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No standings data available.'));
          } else {
            final standings = snapshot.data!;
            return ListView.builder(
              itemCount: standings.length,
              itemBuilder: (context, index) {
                final team = standings[index];
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(team['teamName']),
                  subtitle: Text('Points: ${team['points']}'),
                  trailing: Text(
                      'W: ${team['wins']} D: ${team['draws']} L: ${team['losses']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
