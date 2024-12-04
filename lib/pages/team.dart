import 'package:flutter/material.dart';
import 'package:sofa_score/models/fetch_team.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Jangan lupa untuk dispose TabController
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil idTeam dan teamName dari arguments route
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final idTeam = arguments['id'];
    final teamName = arguments['name'];
    final crest = arguments['crest'];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (crest != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      crest,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                Text(
                  teamName,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Pertandingan'),
                Tab(text: 'Squad'),
                Tab(text: 'Deskripsi'),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTeam(idTeam),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final team = snapshot.data![0];

            return TabBarView(
              controller: _tabController,
              children: [
                // Tab Pertandingan
                const Center(
                    child: Text(
                        'Pertandingan Tab - Here you can display matches.')),

                // Tab Squad
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Squad:'),
                      if (team['squad'] != null)
                        ...team['squad']
                            .map<Widget>((player) => Text(player))
                            .toList(),
                    ],
                  ),
                ),

                // Tab Deskripsi
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${team['name']}'),
                      Text('Short Name: ${team['shortName']}'),
                      Text('Area: ${team['area']}'),
                      Text('Competitions: ${team['competitions']?.join(', ')}'),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
