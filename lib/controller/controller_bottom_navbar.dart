import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../build/build_favorite.dart';
import '../build/build_news.dart';
import '../build/build_score.dart';
import '../models/data.dart';
import '../models/fetch_news.dart';
import '../util/group_matches_by_matchday.dart';

List<Widget> widgetOptions(
  BuildContext context,
  Function(void Function()) setState,
  ScrollController scrollController,
  Future<void> Function() logout,
  VoidCallback navigateToProfile,
) {
  Map<int, List<Map<String, dynamic>>> groupedMatches =
      groupMatchesByMatchday(matchData);
  return [
    // Menampilkan daftar pertandingan
    ListView.builder(
      controller: scrollController,
      itemCount: groupedMatches.keys.length,
      itemBuilder: (context, index) {
        int matchDay = groupedMatches.keys.elementAt(index);
        List<Map<String, dynamic>> matchesForDay = groupedMatches[matchDay]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Matchday $matchDay", // Menampilkan match day
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...matchesForDay.map((match) {
              return buildScoreCard(
                context,
                match['id'],
                match['homeTeam'],
                match['awayTeam'],
                match['scoreA'],
                match['scoreB'],
                match['utcDate'],
                match['status'],
                match['homeCrest'],
                match['awayCrest'],
                (action) {
                  if (action == 'delete') {
                    setState(() {
                      matchData.remove(match); // Menghapus pertandingan
                    });
                  } else if (action == 'mute') {
                    if (kDebugMode) {
                      print(
                          'Pertandingan ${match['homeTeam']} vs ${match['awayTeam']} disenyapkan');
                    }
                  }
                },
              );
            }),
          ],
        );
      },
    ),

    // Menampilkan daftar berita sepak bola
    FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchFootballNews(), // Mengambil data berita dari API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final newsData = snapshot.data!;
          return ListView.builder(
            itemCount: newsData.length,
            itemBuilder: (context, index) {
              final news = newsData[index];
              return buildNewsCard(
                news['source'] ?? 'Unknown Source',
                news['title'] ?? 'No Title',
                news['description'] ?? 'No Description',
                news['imageUrl'],
                news['url'],
                context: context,
              );
            },
          );
        } else {
          return const Center(child: Text('No news available.'));
        }
      },
    ),

    // Menampilkan daftar favorit
    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No favorite data available.'));
        }

        var favData = snapshot.data!.docs;

        return ListView.builder(
          itemCount: favData.length,
          itemBuilder: (context, index) {
            var favItem = favData[index];
            var head = favItem['head'] ?? 'No Title';
            return buildFavoriteCard(head: head, context: context);
          },
        );
      },
    ),

    // Menampilkan loading indicator sementara navigasi ke halaman profil
    Builder(
      builder: (context) {
        // Pastikan navigasi hanya dipanggil sekali
        Future.microtask(() {
          navigateToProfile();
        });
        return const Center(
          child:
              CircularProgressIndicator(), // Menampilkan loader sementara navigasi
        );
      },
    ),
  ];
}
