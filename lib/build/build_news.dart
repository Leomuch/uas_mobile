import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../util/font.dart';

Widget buildNewsCard(String jurnalis, String headline, String dateline,
    String? imageUrl, String url, {required BuildContext context}) {
  return GestureDetector(
    onTap: () async {
      final Uri uri = Uri.parse(url);

      // Mencoba membuka URL jika bisa diluncurkan
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    },
    child: Card(
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
                Text(jurnalis,
                    style: styleKu2(context), overflow: TextOverflow.ellipsis),
                Text(headline,
                    style: styleKu3(context), overflow: TextOverflow.ellipsis),
                Text(dateline,
                    style: styleKu2(context), overflow: TextOverflow.ellipsis),
              ],
            ),
            imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl) // Jika ada gambar, tampilkan gambar
                : Image.asset('assets/default_image.png'),
          ],
        ),
      ),
    ),
  );
}
