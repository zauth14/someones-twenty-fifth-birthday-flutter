import 'package:flutter/material.dart';
import 'games/wordle.dart';
import 'games/connections.dart';
import 'games/wavelength.dart';
import 'games/buzzfeed_quiz.dart';

class GameHubScreen extends StatelessWidget {
  const GameHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'name': 'Buzzfeed Quiz',
        'emoji': '🧠',
        'description': 'Generate fun personality quizzes',
        'screen': const BuzzfeedQuizScreen(),
      },
      {
        'name': 'Wordle',
        'emoji': '🟩',
        'description': 'Guess the 5-letter word in 6 tries',
        'screen': const WordleScreen(),
      },
      {
        'name': 'Connections',
        'emoji': '🔗',
        'description': 'Find four groups of related items',
        'screen': const ConnectionsScreen(),
      },
      {
        'name': 'Wavelength',
        'emoji': '🌊',
        'description': 'Place a concept on a spectrum',
        'screen': const WavelengthScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Someone's 25th Birthday Games"),
        centerTitle: true,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return GameCard(
            emoji: game['emoji'] as String,
            name: game['name'] as String,
            description: game['description'] as String,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => game['screen'] as Widget,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String description;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink.shade100, Colors.purple.shade100],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 12),
              Text(
                name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
