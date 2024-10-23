import 'package:flutter/material.dart';
import 'package:sofa_score/build/build_favorite.dart';
import 'package:sofa_score/build/build_news.dart';
import 'package:sofa_score/build/build_score.dart';
import 'package:sofa_score/models/data.dart';
import 'package:sofa_score/util/font.dart';

List<Widget> get widgetOptions {
  return [
    ListView.builder(
      itemCount: matchData.length,
      itemBuilder: (context, index) {
        final match = matchData[index];
        return buildScoreCard(
          match['homeTeam'],
          match['awayTeam'],
          match['scoreA'],
          match['scoreB'],
          match['utcDate'],
          match['status'],
          match['matchday'],
          match['homeCrest'],
          match['awayCrest'],
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
