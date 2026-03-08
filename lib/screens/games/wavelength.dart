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
    // 4 points: exact match (within 0.05)
    // 3 points: close (within 0.15)
    // 2 points: moderate (within 0.25)
    // 1 point: far (within 0.35)
    // 0 points: very far
    double diff = (guess - target).abs();
    if (diff <= 0.05) return 4;
    if (diff <= 0.15) return 3;
    if (diff <= 0.25) return 2;
    if (diff <= 0.35) return 1;
    return 0;
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Complete!'),
        content: Text('Your score: $score/${prompts.length}'),
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
            child: const Text('Play Again'),
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

    return Scaffold(
      // No title for copyright safety
      appBar: AppBar(
        title: null,
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${currentPromptIndex + 1}/${prompts.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (hint.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Hint: $hint',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prompt['left'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  prompt['right'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Slider(
                  value: sliderValue,
                  onChanged: revealed
                      ? null
                      : (value) => setState(() => sliderValue = value),
                ),
                if (revealed)
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final sliderWidth = constraints.maxWidth;
                        final guessPos = sliderWidth * sliderValue;
                        final targetPos = sliderWidth * target;
                        return Stack(
                          children: [
                            // Target marker
                            Positioned(
                              left: targetPos - 8,
                              top: 0,
                              child: Column(
                                children: [
                                  Icon(Icons.flag, color: Colors.red, size: 20),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Target',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Guess marker
                            Positioned(
                              left: guessPos - 8,
                              bottom: 0,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'You',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (revealed)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Points earned: ${_calculatePoints(sliderValue, target)} / 4',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),
            if (!revealed)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    revealed = true;
                    // Add points for this round
                    score += _calculatePoints(sliderValue, target);
                  });
                },
                child: const Text('Guess'),
              )
            else
              ElevatedButton(
                onPressed: _nextPrompt,
                child: Text(
                  currentPromptIndex < prompts.length - 1 ? 'Next' : 'Finish',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
