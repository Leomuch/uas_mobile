import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    // Ambil tema saat ini
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sofa Score'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Image.network(
                  'https://databar.ai/media/external_source_logo/Sofascore.png',
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 320,
                  child: Text(
                    'Welcome to Sofa Score',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: 24,
                      fontFamily: 'Work Sans',
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 320,
                  child: Text(
                    'Discover live scores, stats, and news for your favorite sports teams and players!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 16,
                      fontFamily: 'Work Sans',
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
