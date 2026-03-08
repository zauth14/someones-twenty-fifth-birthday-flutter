import 'package:flutter/material.dart';
import 'dart:math';
import '../../config/game_data.dart';

/// Fun personality-style quiz section (BuzzFeed-inspired but unique UI)
class QuizTimeScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const QuizTimeScreen({super.key, this.isBirthdayMode = false});

  @override
  State<QuizTimeScreen> createState() => _QuizTimeScreenState();
}

class _QuizTimeScreenState extends State<QuizTimeScreen> {
  late List<Map<String, dynamic>> quizzes;

  int currentQuizIndex = 0;
  int currentQuestionIndex = 0;
  List<int> answers = [];
  String? result;
  bool quizStarted = false;

  late Map<String, dynamic> currentQuiz;

  @override
  void initState() {
    super.initState();
    quizzes = GameData.getQuizzes(widget.isBirthdayMode);
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
    final isBday = widget.isBirthdayMode;
    final bgTop = isBday ? const Color(0xFF1A0A2E) : const Color(0xFFFAF5FF);
    final bgBottom = isBday ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF);
    final accentOrange = isBday ? const Color(0xFFFF8C42) : const Color(0xFFFFA500);
    final accentGold = isBday ? const Color(0xFFFFD166) : const Color(0xFFFFD166);
    final tileBase = isBday ? const Color(0xFF3B1F6E) : const Color(0xFFE9D5FF);

    return Scaffold(
      appBar: AppBar(
        title: null,
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: bgTop,
        iconTheme: IconThemeData(
          color: isBday ? Colors.white70 : Colors.purple.shade400,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
    final isBday = widget.isBirthdayMode;
    final textPrimary = isBday ? Colors.white : const Color(0xFF2D1B4E);
    final textMuted = isBday ? Colors.white.withOpacity(0.5) : Colors.purple.shade300;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pick a Quiz',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap one to find out something fun!',
            style: TextStyle(
              fontSize: 14,
              color: textMuted,
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
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
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
    final isBday = widget.isBirthdayMode;
    final textPrimary = isBday ? Colors.white : const Color(0xFF2D1B4E);
    final textMuted = isBday ? Colors.white38 : Colors.purple.shade200;
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
                        : (widget.isBirthdayMode ? Colors.white24 : Colors.purple.shade100),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            '${currentQuiz['emoji']}  ${currentQuiz['title']}',
            style: TextStyle(
              color: textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),

          // Question
          Text(
            question['q'] as String,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: textPrimary,
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
                    foregroundColor: textPrimary,
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
    final textPrimary = widget.isBirthdayMode ? Colors.white : const Color(0xFF2D1B4E);
    final textMuted = widget.isBirthdayMode ? Colors.white54 : Colors.purple.shade300;
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textPrimary,
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
              foregroundColor: textMuted,
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
