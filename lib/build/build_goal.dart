import 'package:flutter/material.dart';
import 'package:sofa_score/models/data.dart';

Widget buildGoalsInfo() {
  if (matchDetail.isEmpty || matchDetail[0]['goals'] == null) {
    return const Text('No goal information available.');
  }

  List goals = matchDetail[0]['goals'];

  // Debugging untuk memastikan data gol ada
  print('Goals: $goals');

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Goals:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      for (var goal in goals)
        Text(
          '${goal['scorer']} - ${goal['minute']}\' ${goal['team']}', // Menampilkan informasi gol
          style: const TextStyle(fontSize: 16),
        ),
    ],
  );
}
