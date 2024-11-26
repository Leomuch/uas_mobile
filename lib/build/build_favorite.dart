import 'package:flutter/material.dart';
import 'package:sofa_score/util/font.dart';

Widget buildFavoriteCard({required String head, required List<String> avatars}) {
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
          // Menampilkan avatar menggunakan Wrap
          Wrap(
            spacing: 1,
            alignment: WrapAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  // Logika ketika tombol 'add' ditekan
                },
                icon: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              // Menampilkan setiap avatar dalam list
              ...List.generate(
                avatars.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                  child: Column(
                    children: [
                      const CircleAvatar(), // Ganti dengan avatar sesuai data yang tersedia
                      const SizedBox(height: 4),
                      Text(
                        avatars[index], // Menampilkan nama avatar
                        style: styleKu4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
