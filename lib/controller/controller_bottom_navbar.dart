import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofa_score/build/build_favorite.dart';
import 'package:sofa_score/build/build_news.dart';
import 'package:sofa_score/build/build_score.dart';
import 'package:sofa_score/models/data.dart';

List<Widget> widgetOptions(
    BuildContext context,
    Function(void Function()) setState,
    ScrollController scrollController,
    Future<void> Function() logout) {
  return [
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
    ListView.builder(
      itemCount: newsData.length,
      itemBuilder: (context, index) {
        final news = newsData[index];
        return buildNewsCard(
          news['jurnalis'],
          news['headline'],
          news['dateline'],
        );
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
    Builder(
      builder: (context) {
        // Navigasi langsung ke halaman profil ketika tab profil dipilih
        Future.microtask(() {
          Navigator.pushNamed(context, '/profil');
        });
        return const Center(
          child:
              CircularProgressIndicator(), // Menampilkan loader sementara navigasi
        );
      },
    ),
  ];
}
