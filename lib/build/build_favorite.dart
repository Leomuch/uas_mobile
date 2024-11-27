import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofa_score/util/font.dart';

Widget buildFavoriteCard({
  required String head,
  required BuildContext context,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menampilkan judul (head)
          Text(head, style: styleKu2),
          const SizedBox(height: 4),
          // Menampilkan avatar menggunakan Row untuk tampilan horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Menambahkan tombol yang akan mengarahkan ke halaman yang sesuai berdasarkan 'head'
                IconButton(
                  onPressed: () {
                    if (head == 'team') {
                      // Jika head adalah 'team', navigasikan ke /team_page
                      Navigator.pushNamed(context, '/team_page');
                    } else if (head == 'competition') {
                      // Jika head adalah 'competition', navigasikan ke /competition_page
                      Navigator.pushNamed(context, '/competition_page');
                    }
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Menggunakan StreamBuilder untuk mengambil data favorit dari Firestore
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('favorites')
                      .where('head',
                          isEqualTo: head) // Filter berdasarkan field 'head'
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final favorites = snapshot.data!.docs;

                      // Menggunakan Set untuk menghindari duplikasi berdasarkan 'teamName'
                      Set<String> uniqueItems = {};

                      if (favorites.isEmpty) {
                        return const Center(
                            child: Text(
                                'No data available for this competition or team.'));
                      }

                      return Row(
                        children: favorites.map((favoriteDoc) {
                          // Memeriksa apakah 'teams' ada dalam data atau tidak
                          if (head == 'team') {
                            final teams =
                                favoriteDoc['teams'] as List<dynamic>? ?? [];
                            return Row(
                              children: teams.map((teamData) {
                                final teamName =
                                    teamData['teamName'] ?? 'Unknown Team';
                                final crestUrl =
                                    teamData.containsKey('crestUrl')
                                        ? teamData['crestUrl']
                                        : ''; // Safe check for 'crestUrl'

                                if (uniqueItems.contains(teamName)) {
                                  return const SizedBox.shrink();
                                } else {
                                  uniqueItems.add(teamName);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 6),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: crestUrl.isNotEmpty
                                                  ? NetworkImage(crestUrl)
                                                  : const AssetImage(
                                                          'assets/images/default.png')
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          teamName, // Menampilkan nama tim
                                          style: styleKu4,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }).toList(),
                            );
                          } else if (head == 'competition') {
                            final competitions =
                                favoriteDoc['competitions'] as List<dynamic>? ??
                                    [];
                            return Row(
                              children: competitions.map((competitionData) {
                                final competitionName =
                                    competitionData['competitionName'] ??
                                        'Unknown Competition';
                                final crestUrl =
                                    competitionData.containsKey('crestUrl')
                                        ? competitionData['crestUrl']
                                        : '';

                                if (uniqueItems.contains(competitionName)) {
                                  return const SizedBox.shrink();
                                } else {
                                  uniqueItems.add(competitionName);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 6),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: crestUrl.isNotEmpty
                                                  ? NetworkImage(crestUrl)
                                                  : const AssetImage(
                                                          'assets/images/default.png')
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          competitionName, // Menampilkan nama tim
                                          style: styleKu4,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }).toList(),
                            );
                          }
                          return const SizedBox
                              .shrink(); // Menghindari error jika tidak ada data yang cocok
                        }).toList(),
                      );
                    } else {
                      return const Center(child: Text('No favorites found.'));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
