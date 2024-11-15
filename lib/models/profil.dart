import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final Future<void> Function() logout;

  const ProfilePage({super.key, required this.logout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                User user = snapshot.data!;
                String? photoURL = user.photoURL;
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: photoURL != null && photoURL.isNotEmpty
                          ? NetworkImage(photoURL)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.displayName ?? 'Nama Pengguna',
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(user.email ?? 'Email Pengguna'),
                  ],
                );
              } else {
                return const Text('Tidak ada data pengguna');
              }
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Akun'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(logout: logout)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Pilih Laman Beranda Anda'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: const Text('Semua Kompetisi'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Semua Berita'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.tips_and_updates),
                  title: const Text('Tip Harian'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Peluang'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifikasi'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.web),
                  title: const Text('Export Selections to Web'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
