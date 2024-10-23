import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:sofa_score/util/font.dart';

Widget buildScoreCard(
    String homeTeam,
    String awayTeam,
    int scoreA,
    int scoreB,
    String utcDate,
    String status,
    int matchday,
    String homeCrest,
    String awayCrest) {
  // Format tanggal dari UTC ke format yang lebih mudah dibaca
  DateTime dateTime = DateTime.parse(utcDate);
  String formattedDate = DateFormat('d MMMM y HH:mm').format(dateTime);

  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tampilkan Crest (logo tim) dan Nama Tim
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.network(homeCrest, width: 30, height: 30),
                  const SizedBox(height: 8),
                  Text(homeTeam, style: const TextStyle(fontSize: 14)),
                ],
              ),
              Column(
                children: [
                  Image.network(awayCrest, width: 30, height: 30),
                  const SizedBox(height: 8),
                  Text(awayTeam, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Tampilkan skor pertandingan
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$scoreA - $scoreB',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Tampilkan tanggal, matchday, status, dan stage
          Text('Date: $formattedDate', style: const TextStyle(fontSize: 14)),
          Text('Matchday: $matchday', style: const TextStyle(fontSize: 14)),
          Text('Status: $status', style: const TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );
}
