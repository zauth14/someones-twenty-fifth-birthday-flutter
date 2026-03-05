import 'package:flutter/material.dart';
import 'game_hub.dart';

class BirthdayModeScreen extends StatefulWidget {
  const BirthdayModeScreen({super.key});

  @override
  State<BirthdayModeScreen> createState() => _BirthdayModeScreenState();
}

class _BirthdayModeScreenState extends State<BirthdayModeScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple.shade400, Colors.pink.shade300],
              ),
            ),
          ),
          // Confetti (simplified)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(_confettiController.value),
                );
              },
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎂', style: TextStyle(fontSize: 120)),
                const SizedBox(height: 30),
                Text(
                  '🎉 Happy 25th Birthday! 🎉',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const GameHubScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink.shade700,
                  ),
                  child: const Text(
                    "Let's Play!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double animationValue;

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final colors = [Colors.pink, Colors.purple, Colors.yellow, Colors.green];

    for (int i = 0; i < 50; i++) {
      final angle = (i / 50) * 2 * 3.14159;
      final distance = (animationValue * size.height * 1.5) % size.height;

      final x = size.width / 2 + (distance * 0.3) * (i % 2 == 0 ? 1 : -1);
      final y = distance;

      paint.color = colors[i % colors.length];

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}
