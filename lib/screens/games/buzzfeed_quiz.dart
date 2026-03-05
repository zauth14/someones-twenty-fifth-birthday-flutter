import 'package:flutter/material.dart';

class BuzzfeedQuizScreen extends StatefulWidget {
  const BuzzfeedQuizScreen({super.key});

  @override
  State<BuzzfeedQuizScreen> createState() => _BuzzfeedQuizScreenState();
}

class _BuzzfeedQuizScreenState extends State<BuzzfeedQuizScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What\'s your ideal birthday celebration?',
      'answers': [
        {'text': 'Party with friends', 'type': 'extrovert'},
        {'text': 'Quiet dinner at home', 'type': 'introvert'},
        {'text': 'Adventure or travel', 'type': 'adventurous'},
        {'text': 'Do nothing special', 'type': 'chill'},
      ],
    },
    {
      'question': 'What\'s your spirit animal?',
      'answers': [
        {'text': 'Lion', 'type': 'adventurous'},
        {'text': 'Owl', 'type': 'introvert'},
        {'text': 'Dolphin', 'type': 'extrovert'},
        {'text': 'Sloth', 'type': 'chill'},
      ],
    },
    {
      'question': 'How do you handle stress?',
      'answers': [
        {'text': 'Talk it out with friends', 'type': 'extrovert'},
        {'text': 'Read or reflect alone', 'type': 'introvert'},
        {'text': 'Exercise or go outside', 'type': 'adventurous'},
        {'text': 'Take a nap', 'type': 'chill'},
      ],
    },
  ];

  final Map<String, int> scores = {
    'extrovert': 0,
    'introvert': 0,
    'adventurous': 0,
    'chill': 0,
  };

  int currentQuestionIndex = 0;
  bool quizComplete = false;
  String? result;

  final Map<String, String> resultDescriptions = {
    'extrovert': 'You\'re the life of the party! 🎉',
    'introvert': 'You\'re thoughtful and introspective! 📚',
    'adventurous': 'You\'re a thrill-seeker! 🚀',
    'chill': 'You\'re laid-back and easygoing! 😎',
  };

  void _answerQuestion(String type) {
    setState(() {
      scores[type] = (scores[type] ?? 0) + 1;

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        quizComplete = true;
        result = scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      quizComplete = false;
      result = null;
      for (var key in scores.keys) {
        scores[key] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Buzzfeed Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: quizComplete
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You are:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      resultDescriptions[result] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _resetQuiz,
                    child: const Text('Retake Quiz'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    questions[currentQuestionIndex]['question'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ...((questions[currentQuestionIndex]['answers'] as List)
                          .cast<Map<String, String>>())
                      .map(
                        (answer) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () => _answerQuestion(answer['type']!),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size(double.infinity, 0),
                            ),
                            child: Text(answer['text']!),
                          ),
                        ),
                      ),
                ],
              ),
      ),
    );
  }
}
