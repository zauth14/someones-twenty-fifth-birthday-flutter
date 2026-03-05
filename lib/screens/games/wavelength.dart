import 'package:flutter/material.dart';

class WavelengthScreen extends StatefulWidget {
  const WavelengthScreen({super.key});

  @override
  State<WavelengthScreen> createState() => _WavelengthScreenState();
}

class _WavelengthScreenState extends State<WavelengthScreen> {
  final List<Map<String, dynamic>> prompts = [
    {'left': 'Hot', 'right': 'Cold', 'answer': 'Temperature'},
    {'left': 'Love', 'right': 'Hate', 'answer': 'Emotion'},
    {'left': 'Morning', 'right': 'Night', 'answer': 'Time of Day'},
    {'left': 'Fast', 'right': 'Slow', 'answer': 'Speed'},
    {'left': 'Happy', 'right': 'Sad', 'answer': 'Mood'},
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

    return Scaffold(
      appBar: AppBar(title: const Text('🌊 Wavelength')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${currentPromptIndex + 1}/${prompts.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
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
            Slider(
              value: sliderValue,
              onChanged: (value) => setState(() => sliderValue = value),
            ),
            const SizedBox(height: 20),
            if (revealed) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'The answer was: ${prompt['answer']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 30),
            if (!revealed)
              ElevatedButton(
                onPressed: () => setState(() => revealed = true),
                child: const Text('Reveal Answer'),
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
