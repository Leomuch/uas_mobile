import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sofa_score/pages/auth.dart';
import 'package:sofa_score/pages/home_page.dart';
import 'package:sofa_score/pages/landing_page.dart';
import 'package:sofa_score/pages/league_standings.dart';
import 'package:sofa_score/pages/match_detail.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/second': (context) => const Auth(),
        '/home_page': (context) => const HomePage(),
        '/match_detail': (context) => const MatchDetailPage(),
        '/league_standing': (context) => const LeagueStandings(),
      },
    );
  }
}
