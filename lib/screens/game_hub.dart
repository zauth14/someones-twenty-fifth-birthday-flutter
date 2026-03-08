import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import 'games/wordle.dart';
import 'games/connections.dart';
import 'games/wavelength.dart';
import 'games/buzzfeed_quiz.dart';

class GameHubScreen extends StatelessWidget {
  const GameHubScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 520),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.06, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'name': 'Personality Quiz',
        'emoji': '💭',
        'description': 'Fun quizzes about you',
        'screen': TenThingsScreen(isBirthdayMode: false),
        'color': AppTheme.normalBluePrimary,
      },
      {
        'name': '5-Letter Challenge',
        'emoji': '🔤',
        'description': 'Guess the word in 6 tries',
        'screen': const WordleScreen(isBirthdayMode: false),
        'color': AppTheme.normalGreenPrimary,
      },
      {
        'name': 'Spectrum Game',
        'emoji': '〰️',
        'description': 'Place concepts on a scale',
        'screen': const WavelengthScreen(isBirthdayMode: false),
        'color': AppTheme.normalAccent,
      },
      {
        'name': 'Category Match',
        'emoji': '🔗',
        'description': 'Find groups of four',
        'screen': const ConnectionsScreen(isBirthdayMode: false),
        'color': const Color(0xFFEC4899),
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Choose Your Game 🎮',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.normalTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pick a game and have fun!',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),

          // Games List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _GameCard(
                    emoji: game['emoji'] as String,
                    name: game['name'] as String,
                    description: game['description'] as String,
                    color: game['color'] as Color,
                    onTap: () => _navigateTo(context, game['screen'] as Widget),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.emoji,
    required this.name,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji Circle
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.normalTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
