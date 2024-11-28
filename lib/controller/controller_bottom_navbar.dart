import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../build/build_favorite.dart';
import '../build/build_news.dart';
import '../build/build_score.dart';
import '../models/data.dart';
import '../models/fetch_news.dart';

List<Widget> widgetOptions(
  BuildContext context,
  Function(void Function()) setState,
  ScrollController scrollController,
  Future<void> Function() logout,
  VoidCallback navigateToProfile,
) {
  return [
    // Menampilkan daftar pertandingan
    ListView.builder(
      controller: scrollController,
      itemCount: matchData.length,
      itemBuilder: (context, index) {
        final match = matchData[index];
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
                matchData.removeAt(index);
              });
            } else if (action == 'mute') {
              if (kDebugMode) {
                print(
                    'Pertandingan ${match['homeTeam']} vs ${match['awayTeam']} disenyapkan');
              }
            }
          },
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
              );
            },
          );
        } else {
          return const Center(child: Text('No news available.'));
        }
      },
    ),
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
        // Navigasi langsung ke halaman profil ketika tab profil dipilih
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
