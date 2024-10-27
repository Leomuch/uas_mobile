import 'package:flutter/material.dart';
import 'package:sofa_score/build/build_favorite.dart';
import 'package:sofa_score/build/build_news.dart';
import 'package:sofa_score/build/build_score.dart';
import 'package:sofa_score/models/data.dart';
import 'package:sofa_score/util/font.dart';

List<Widget> widgetOptions(BuildContext context, Function(void Function()) setState, ScrollController scrollController) {
  return [
    ListView.builder(
      controller: scrollController,
      itemCount: matchData.length,
      itemBuilder: (context, index) {
        final match = matchData[index];
        return buildScoreCard(
          context,
          match['homeTeam'],
          match['awayTeam'],
          match['scoreA'],
          match['scoreB'],
          match['utcDate'],
          match['status'],
          match['matchday'],
          match['homeCrest'],
          match['awayCrest'],
          match['area'],
          match['competition'],
          (action) {
            // Handle aksi ketika dihapus atau disenyapkan
            if (action == 'delete') {
              // Hapus pertandingan dari data
              setState(() {
                matchData.removeAt(index);
              });
            } else if (action == 'mute') {
              // Lakukan aksi senyapkan (misalnya menandai pertandingan sebagai "muted")
              print(
                  'Pertandingan ${match['homeTeam']} vs ${match['awayTeam']} disenyapkan');
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
    ListView.builder(
      itemCount: favData.length,
      itemBuilder: (context, index) {
        final fav = favData[index];
        final avatars = fav['avatar'] ?? [];
        return buildFavoriteCard(
          fav['head'],
          List<String>.from(avatars),
        );
      },
    ),
    // Profile Tab
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircleAvatar(
            radius: 60,
          ),
          const SizedBox(height: 10),
          Text(
            'Your Profile',
            style: styleKu1,
          ),
          const SizedBox(height: 10),
          Text(
            'Username: your_username',
            style: styleKu2,
          ),
          Text(
            'Email: your_email@example.com',
            style: styleKu2,
          ),
        ],
      ),
    ),
  ];
}