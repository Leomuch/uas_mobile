import 'package:flutter/material.dart';
import 'package:sofa_score/util/font.dart';

Widget buildFavoriteCard(String head, List<String> avatar) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(head, style: styleKu2),
            const SizedBox(height: 4),
            Wrap(
              spacing: 1,
              alignment: WrapAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                ...List.generate(
                  avatar.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 6),
                    child: Column(
                      children: [
                        const CircleAvatar(),
                        const SizedBox(height: 4),
                        Text(
                          avatar[index],
                          style: styleKu4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    ),
  );
}
