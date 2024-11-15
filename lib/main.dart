import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sofa_score/models/profil.dart';
import 'package:sofa_score/pages/auth.dart';
import 'package:sofa_score/pages/home_page.dart';
import 'package:sofa_score/pages/landing_page.dart';
import 'package:sofa_score/pages/league_standings.dart';
import 'package:sofa_score/pages/match_detail.dart';
import 'package:sofa_score/pages/top_score.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializtion();
  }

  void initializtion() async {
    if (kDebugMode) {
      print('pausing...');
    }
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('pausing');
    }
    FlutterNativeSplash.remove();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LandingPage();
          }
        },
      ),
      routes: {
        '/second': (context) => const Auth(),
        '/home_page': (context) => const HomePage(),
        '/profil': (context) => ProfilePage(logout: logout),
        '/match_detail': (context) => const MatchDetailPage(),
        '/league_standing': (context) => const LeagueStandings(),
        '/top_score': (context) => const TopScore(),
      },
    );
  }
}
