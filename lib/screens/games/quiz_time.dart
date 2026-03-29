import 'package:flutter/material.dart';
import 'dart:math';

/// Fun personality-style quiz section (BuzzFeed-inspired but unique UI)
class QuizTimeScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const QuizTimeScreen({super.key, this.isBirthdayMode = false});

  @override
  State<QuizTimeScreen> createState() => _QuizTimeScreenState();
}

class _QuizTimeScreenState extends State<QuizTimeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  bool _isFading = false;
  // Multiple quizzes — each with questions and a result mapping
  final List<Map<String, dynamic>> quizzes = [
    {
      'title': 'Which Dessert Are You?',
      'emoji': '🍰',
      'questions': [
        {
          'q': 'Pick a weekend vibe:',
          'options': [
            'Chill day at home',
            'Movie marathon',
            'Road trip',
            'Going out with friends',
          ],
        },
        {
          'q': 'Choose a color palette:',
          'options': [
            'Sunset orange',
            'Ocean blue',
            'Forest green',
            'Lavender Purple',
          ],
        },
        {
          'q': 'Your go-to drink:',
          'options': [
            'Iced coffee',
            'Smoothie',
            'Energy Drink',
            'Sparkling water',
          ],
        },
        {
          'q': 'Pick a superpower:',
          'options': ['Time travel', 'Invisibility', 'Flying', 'Mind reading'],
        },
      ],
      'results': [
        'You\'re a New York Style Blueberry Cheesecake — layered, elegant, (kinda fancy) and unforgettable. Smooth at first, but with just the right amount of boldness underneath. Sweet, a little indulgent, and honestly… kind of addictive. The kind of person people keep coming back to without even realizing why.',
        'You\'re a Tiramisu — complicated, mysterious, and full of depth! You have a rich blend of qualities that keep people intrigued. You can be sweet and comforting, but also have a bold, unexpected side that keeps things interesting. You\'re the person who always has a story to tell and a unique perspective to share.',
        'You\'re a Birthday Cake (hey, what a coincidence) — unique, trendy, and full of surprises! You have a childlike joy and a colorful personality that lights up any room. You\'re the life of the party, always ready to celebrate and make every moment special. People are drawn to your fun-loving spirit and your ability to make even ordinary days feel like a celebration.',
        'You\'re a Refreshing Sorbet — vibrant, light, and always uplifting! You have a zest for life and a refreshing outlook that inspires those around you. You\'re the person who brings a burst of energy and positivity wherever you go. People love your ability to brighten their day and your knack for making even the simplest moments feel special.',
      ],
    },
    {
      'title': 'What\'s Your Go-To Party Anthem?',
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
        'Your anthem is "Dancing Queen" — you own every dance floor! You are the life of the party, always ready to dance and have a good time. Your energy is infectious, and you know how to get everyone moving. You\'re the person who can turn any gathering into a dance party, and people love your carefree spirit and your ability to make everyone feel included.',
        'Your anthem is "Good as Hell" — confident and unstoppable! You have a powerful presence and a can-do attitude that inspires those around you. You\'re the person who walks into a room and immediately commands attention with your confidence and charisma. Your anthem reflects your ability to overcome challenges and come out on top, no matter what life throws at you.',
        'Your anthem is "Mr. Brightside" — you bring the energy! You have a passionate and intense personality that shines through in everything you do. You\'re the person who can turn even the most mundane moments into something exciting and memorable. Your anthem reflects your ability to find joy and excitement in the little things, and people are drawn to your vibrant energy.',
        'Your anthem is "Levitating" — smooth, groovy, and magnetic! You have a cool and effortless vibe that makes people want to be around you. You\'re the person who can make any situation feel fun and lighthearted with your charm and charisma. Your anthem reflects your ability to lift people\'s spirits and create a positive atmosphere wherever you go.',
      ],
    },
    {
      'title': 'What is Your Best Quality?',
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
            'The hype-man',
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
        'You\'re The Rock — reliable, strong, and always there! You\'re the person everyone can count on, no matter what. You provide a sense of stability and security that makes your friends feel safe and supported. Your loyalty and dependability are unmatched, and you\'re the one people turn to when they need a shoulder to lean on.',
        'You\'re The Hype Machine — you lift everyone\'s spirits! You have an infectious energy and a positive outlook that makes people feel good just by being around you. You\'re the one who always knows how to make your friends laugh and feel appreciated. Your enthusiasm and encouragement are like a boost of confidence for everyone in your circle.',
        'You\'re The Sage — wise, caring, and everyone\'s safe space! You have a deep understanding of people and a compassionate heart that makes you the go-to person for advice and support. You\'re the one who listens without judgment and offers thoughtful insights that help your friends navigate life\'s challenges. Your empathy and wisdom create a sense of comfort and trust that is truly special.',
        'You\'re The Spark — spontaneous, fun, and full of life! You bring excitement and unpredictability to your friendships, making every moment feel like an adventure. You\'re the one who encourages your friends to step out of their comfort zones and try new things. Your vibrant personality and zest for life make you the friend who keeps things interesting and fun.',
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
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
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

  Future<void> _answer(int optionIndex) async {
    if (_isFading) return;
    _isFading = true;
    await _fadeCtrl.animateTo(0.0, curve: Curves.easeOut);
    if (!mounted) return;
    setState(() {
      answers.add(optionIndex);
      final questions = currentQuiz['questions'] as List;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
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
    await _fadeCtrl.animateTo(1.0, curve: Curves.easeIn);
    _isFading = false;
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

          AnimatedBuilder(
            animation: _fadeCtrl,
            builder: (_, child) => Opacity(
              opacity: _fadeCtrl.value,
              child: child,
            ),
            child: Column(
              children: [
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
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildResult(Color accentOrange, Color accentGold, Color tileBase) {
    return SingleChildScrollView(
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
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.6,
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
