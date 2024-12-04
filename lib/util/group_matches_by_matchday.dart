Map<int, List<Map<String, dynamic>>> groupMatchesByMatchday(
  List<Map<String, dynamic>> matchData) {
  Map<int, List<Map<String, dynamic>>> groupedMatches = {};

  for (var match in matchData) {
    // Menggunakan matchday yang bertipe int langsung
    int matchDay = match['matchday'];

    if (!groupedMatches.containsKey(matchDay)) {
      groupedMatches[matchDay] = [];
    }

    // Memastikan tidak ada duplikasi berdasarkan 'id' pertandingan
    if (!groupedMatches[matchDay]!.any((m) => m['id'] == match['id'])) {
      groupedMatches[matchDay]?.add(match);
    }
  }

  return groupedMatches;
}
