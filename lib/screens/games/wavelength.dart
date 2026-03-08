import 'package:flutter/material.dart';

class WavelengthScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const WavelengthScreen({super.key, this.isBirthdayMode = false});

  @override
  State<WavelengthScreen> createState() => _WavelengthScreenState();
}

class _WavelengthScreenState extends State<WavelengthScreen> {
  final List<Map<String, dynamic>> prompts = [
    {
      'left': 'Hot',
      'right': 'Cold',
      'answer': 'Temperature',
      'hint': 'Temperature',
      'target': 0.2,
    },
    {
      'left': 'Love',
      'right': 'Hate',
      'answer': 'Emotion',
      'hint': 'Emotion',
      'target': 0.8,
    },
    {
      'left': 'Morning',
      'right': 'Night',
      'answer': 'Time of Day',
      'hint': 'Time of Day',
      'target': 0.3,
    },
    {
      'left': 'Fast',
      'right': 'Slow',
      'answer': 'Speed',
      'hint': 'Speed',
      'target': 0.1,
    },
    {
      'left': 'Happy',
      'right': 'Sad',
      'answer': 'Mood',
      'hint': 'Mood',
      'target': 0.4,
    },
  ];

  int currentPromptIndex = 0;
  double sliderValue = 0.5;
  bool revealed = false;
  int score = 0;

  void _nextPrompt() {
    if (currentPromptIndex < prompts.length - 1) {
      setState(() {
        currentPromptIndex++;
        sliderValue = 0.5;
        revealed = false;
      });
    } else {
      _showGameOver();
    }
  }

  int _calculatePoints(double guess, double target) {
    double diff = (guess - target).abs();
    if (diff <= 0.05) return 4;
    if (diff <= 0.15) return 3;
    if (diff <= 0.25) return 2;
    if (diff <= 0.35) return 1;
    return 0;
  }

  void _showGameOver() {
    const accentOrange = Color(0xFFFF8C42);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Round Complete!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Your score: $score / ${prompts.length * 4}',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentPromptIndex = 0;
                sliderValue = 0.5;
                revealed = false;
                score = 0;
              });
            },
            child: const Text(
              'Play Again',
              style: TextStyle(
                color: accentOrange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prompt = prompts[currentPromptIndex];
    final double target = prompt['target'] ?? 0.5;
    final String hint = prompt['hint'] ?? '';

    const bgTop = Color(0xFF1A0A2E);
    const bgBottom = Color(0xFF2D1B4E);
    const accentOrange = Color(0xFFFF8C42);
    const accentRose = Color(0xFFFB7185);
    const accentGold = Color(0xFFFFD166);
    const tileBase = Color(0xFF3B1F6E);

    final int pts = _calculatePoints(sliderValue, target);

    return Scaffold(
      appBar: AppBar(
        title: null,
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: bgTop,
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // Progress dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(prompts.length, (i) {
                    Color dotColor;
                    if (i < currentPromptIndex) {
                      dotColor = accentOrange;
                    } else if (i == currentPromptIndex) {
                      dotColor = Colors.white;
                    } else {
                      dotColor = Colors.white24;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i == currentPromptIndex ? 24 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: dotColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: $score',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // Hint badge
                if (hint.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: tileBase.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: accentOrange.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: accentGold,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hint,
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Left / Right labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: accentRose.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accentRose.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          prompt['left'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: accentRose,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: accentOrange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accentOrange.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          prompt['right'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: accentOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Custom slider track
                SizedBox(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Track background
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [accentRose, accentGold, accentOrange],
                          ),
                        ),
                      ),
                      // Target marker (only when revealed)
                      if (revealed)
                        Positioned(
                          left:
                              (MediaQuery.of(context).size.width - 72) * target,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 4,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'TARGET',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Slider
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 14,
                          ),
                          overlayColor: accentOrange.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: sliderValue,
                          onChanged: revealed
                              ? null
                              : (value) => setState(() => sliderValue = value),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Result panel
                if (revealed)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: tileBase.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: pts >= 3
                            ? accentOrange.withOpacity(0.5)
                            : pts >= 1
                            ? accentGold.withOpacity(0.5)
                            : accentRose.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          pts >= 3
                              ? Icons.star_rounded
                              : pts >= 1
                              ? Icons.star_half_rounded
                              : Icons.star_border_rounded,
                          color: pts >= 3
                              ? accentOrange
                              : pts >= 1
                              ? accentGold
                              : accentRose,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '+$pts points',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: pts >= 3
                                ? accentOrange
                                : pts >= 1
                                ? accentGold
                                : accentRose,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Action button
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: revealed
                        ? ElevatedButton.icon(
                            icon: Icon(
                              currentPromptIndex < prompts.length - 1
                                  ? Icons.arrow_forward_rounded
                                  : Icons.flag_rounded,
                              size: 20,
                            ),
                            label: Text(
                              currentPromptIndex < prompts.length - 1
                                  ? 'Next'
                                  : 'See Results',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentOrange,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: _nextPrompt,
                          )
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.gps_fixed_rounded, size: 20),
                            label: const Text('Lock In'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentOrange,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                revealed = true;
                                score += _calculatePoints(sliderValue, target);
                              });
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
