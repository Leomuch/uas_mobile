import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofa_score/build/build_favorite.dart';
import 'package:sofa_score/build/build_news.dart';
import 'package:sofa_score/build/build_score.dart';
import 'package:sofa_score/models/data.dart';
import 'package:sofa_score/util/font.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<Widget> widgetOptions(BuildContext context,
    Function(void Function()) setState, ScrollController scrollController) {
  // Fungsi untuk logout
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Arahkan kembali ke halaman login setelah logout
      Navigator.pushReplacementNamed(
          context, '/second'); // Sesuaikan dengan nama rute login Anda
    } catch (e) {
      // Tampilkan pesan kesalahan jika logout gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout gagal: $e')),
      );
    }
  }

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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    ),
  ];
}
