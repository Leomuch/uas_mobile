import 'package:flutter/material.dart';
import 'package:sofa_score/models/fetch_team.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    // Mengambil idTeam dan teamName dari arguments route
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final idTeam = arguments['id'];
    final teamName = arguments['name'];

    return Scaffold(
      appBar: AppBar(
        title: Text(teamName),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTeam(idTeam),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final team = snapshot.data![0];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan logo tim (crest)
                  Image.network(team['crest'] ?? ''),
                  const SizedBox(height: 20),
                  // Menampilkan informasi tim
                  Text('Name: ${team['name']}'),
                  Text('Short Name: ${team['shortName']}'),
                  Text('Area: ${team['area']}'),
                  Text('Competitions: ${team['competitions']?.join(', ')}'),
                  const SizedBox(height: 20),
                  const Text('Squad:'),
                  // Menampilkan daftar pemain
                  if (team['squad'] != null)
                    ...team['squad']
                        .map<Widget>((player) => Text(player))
                        .toList(),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
