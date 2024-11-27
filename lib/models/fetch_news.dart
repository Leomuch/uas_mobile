import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchFootballNews() async {
  const url =
      'https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=97c9bc6670834448a355b9226a52d7ad';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List news = data['articles'] ?? [];
      List<Map<String, dynamic>> newsData = [];

      // Mengambil data berita
      for (var article in news) {
        newsData.add({
          'source': article['source']['name'],
          'title': article['title'],
          'description': article['description'],
          'imageUrl': article['urlToImage'],
          'url': article['url'],
        });
      }

      return newsData;
    } else {
      print('Failed to load news: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching football news: $e');
    return [];
  }
}
