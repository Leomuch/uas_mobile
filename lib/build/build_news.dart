import 'package:flutter/material.dart';
import 'package:sofa_score/util/font.dart';

Widget buildNewsCard(String jurnalis, String headline, String dateline) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jurnalis, style: styleKu2, overflow: TextOverflow.ellipsis),
              Text(headline, style: styleKu3, overflow: TextOverflow.ellipsis),
              Text(dateline, style: styleKu2, overflow: TextOverflow.ellipsis),
            ],
          ),
          const Placeholder(
            fallbackHeight: 200,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}
