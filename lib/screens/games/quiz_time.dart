import 'package:flutter/material.dart';
import 'dart:math';

/// Fun personality-style quiz section (BuzzFeed-inspired but unique UI)
class QuizTimeScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const QuizTimeScreen({super.key, this.isBirthdayMode = false});

  @override
  State<QuizTimeScreen> createState() => _QuizTimeScreenState();
}

class _QuizTimeScreenState extends State<QuizTimeScreen> {
  // Multiple quizzes — each with questions and a result mapping
  final List<Map<String, dynamic>> quizzes = [
    {
      'title': 'Which Dessert Are You?',
      'emoji': '🍰',
      'questions': [
        {
          'q': 'Pick a weekend vibe:',
          'options': [
            'Beach day',
            'Movie marathon',
            'Road trip',
            'Cooking at home',
          ],
        },
        {
          'q': 'Choose a color palette:',
          'options': [
            'Sunset orange',
            'Ocean blue',
            'Forest green',
            'Berry pink',
          ],
        },
        {
          'q': 'Your go-to drink:',
          'options': [
            'Iced coffee',
            'Smoothie',
            'Hot chocolate',
            'Sparkling water',
          ],
        },
        {
          'q': 'Pick a superpower:',
          'options': ['Time travel', 'Invisibility', 'Flying', 'Mind reading'],
        },
      ],
      'results': [
        'You\'re a classic Tiramisu — layered, elegant, and unforgettable!',
        'You\'re a warm Brownie — rich, comforting, and loved by everyone!',
        'You\'re a colorful Macaron — unique, trendy, and full of surprises!',
        'You\'re a refreshing Sorbet — vibrant, light, and always uplifting!',
      ],
    },
    {
      'title': 'What\'s Your Party Anthem?',
      'emoji': '🎶',
      'questions': [
        {
          'q': 'Pick a dance move:',
          'options': ['The Spin', 'The Shimmy', 'The Dip', 'Free-style chaos'],
        },
        {
          'q': 'Your ideal party size:',
          'options': [
            'Just my crew (5-8)',
            'Medium bash (20-30)',
            'Huge blowout (50+)',
            'One-on-one hangout',
          ],
        },
        {
          'q': 'What are you doing at a party?',
          'options': [
            'Dancing non-stop',
            'By the snack table',
            'Telling stories',
            'Taking photos',
          ],
        },
        {
          'q': 'Choose a party theme:',
          'options': ['Retro disco', 'Garden party', 'Masquerade', 'Neon glow'],
        },
      ],
      'results': [
        'Your anthem is "Dancing Queen" — you own every dance floor!',
        'Your anthem is "Good as Hell" — confident and unstoppable!',
        'Your anthem is "Mr. Brightside" — you bring the energy!',
        'Your anthem is "Levitating" — smooth, groovy, and magnetic!',
      ],
    },
    {
      'title': 'What Kind of Friend Are You?',
      'emoji': '💛',
      'questions': [
        {
          'q': 'A friend calls at 2 AM — you:',
          'options': [
            'Answer immediately',
            'Text "you ok?"',
            'Call back in the morning',
            'Show up at their door',
          ],
        },
        {
          'q': 'Your friend group role:',
          'options': [
            'The planner',
            'The hype person',
            'The therapist',
            'The wildcard',
          ],
        },
        {
          'q': 'Pick a friendship activity:',
          'options': [
            'Brunch',
            'Karaoke night',
            'Deep talks on a drive',
            'Spontaneous adventure',
          ],
        },
        {
          'q': 'Your love language with friends:',
          'options': [
            'Words of affirmation',
            'Quality time',
            'Acts of service',
            'Gifts & surprises',
          ],
        },
      ],
      'results': [
        'You\'re The Rock — reliable, strong, and always there!',
        'You\'re The Hype Machine — you lift everyone\'s spirits!',
        'You\'re The Sage — wise, caring, and everyone\'s safe space!',
        'You\'re The Spark — spontaneous, fun, and full of life!',
      ],
    },
  ];

  int currentQuizIndex = 0;
  int currentQuestionIndex = 0;
  List<int> answers = [];
  String? result;
  bool quizStarted = false;

  late Map<String, dynamic> currentQuiz;

  @override
  void initState() {
    super.initState();
    currentQuiz = quizzes[Random().nextInt(quizzes.length)];
  }

  void _startQuiz(int index) {
    setState(() {
      currentQuizIndex = index;
      currentQuiz = quizzes[index];
      currentQuestionIndex = 0;
      answers = [];
      result = null;
      quizStarted = true;
    });
  }

  void _answer(int optionIndex) {
    setState(() {
      answers.add(optionIndex);
      final questions = currentQuiz['questions'] as List;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Calculate result based on most chosen index
        final counts = [0, 0, 0, 0];
        for (final a in answers) {
          counts[a]++;
        }
        int maxIdx = 0;
        for (int i = 1; i < counts.length; i++) {
          if (counts[i] > counts[maxIdx]) maxIdx = i;
        }
        result = (currentQuiz['results'] as List)[maxIdx];
      }
    });
  }

  void _resetToMenu() {
    setState(() {
      quizStarted = false;
      result = null;
      answers = [];
      currentQuestionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF1A0A2E);
    const bgBottom = Color(0xFF2D1B4E);
    const accentOrange = Color(0xFFFF8C42);
    const accentGold = Color(0xFFFFD166);
    const tileBase = Color(0xFF3B1F6E);

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
          child: !quizStarted
              ? _buildQuizMenu(accentOrange, accentGold, tileBase)
              : result != null
              ? _buildResult(accentOrange, accentGold, tileBase)
              : _buildQuestion(accentOrange, accentGold, tileBase),
        ),
      ),
    );
  }

  Widget _buildQuizMenu(Color accentOrange, Color accentGold, Color tileBase) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pick a Quiz',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap one to find out something fun!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          ...quizzes.asMap().entries.map((entry) {
            final idx = entry.key;
            final quiz = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () => _startQuiz(idx),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: tileBase,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentOrange.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        quiz['emoji'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          quiz['title'] as String,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: accentOrange,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestion(Color accentOrange, Color accentGold, Color tileBase) {
    final questions = currentQuiz['questions'] as List;
    final question = questions[currentQuestionIndex] as Map<String, dynamic>;
    final options = question['options'] as List;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(questions.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: i == currentQuestionIndex ? 28 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: i <= currentQuestionIndex
                        ? accentOrange
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            '${currentQuiz['emoji']}  ${currentQuiz['title']}',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),

          // Question
          Text(
            question['q'] as String,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Options
          ...options.asMap().entries.map((entry) {
            final optIdx = entry.key;
            final opt = entry.value as String;
            // Alternate option accent colors
            final isEven = optIdx % 2 == 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _answer(optIdx),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isEven
                          ? accentOrange.withOpacity(0.5)
                          : accentGold.withOpacity(0.5),
                      width: 1.5,
                    ),
                    backgroundColor: tileBase.withOpacity(0.6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(opt),
                ),
              ),
            );
          }),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildResult(Color accentOrange, Color accentGold, Color tileBase) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentQuiz['emoji'] as String,
            style: const TextStyle(fontSize: 52),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: tileBase,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: accentOrange.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentOrange.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              result!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Try Another Quiz'),
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
              onPressed: _resetToMenu,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white54,
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
            child: const Text('Back to Games'),
          ),
        ],
      ),
    );
  }
}
