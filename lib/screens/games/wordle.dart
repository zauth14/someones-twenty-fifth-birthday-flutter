import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class WordleScreen extends StatefulWidget {
  const WordleScreen({super.key});

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  static const List<String> wordList = [
    'FLUTTER',
    'PUZZLE',
    'GAMES',
    'PARTY',
    'HAPPY',
    'BIRTHDAY',
    'CELEBRATION',
  ];

  late String secretWord;
  List<String> guesses = [];
  String currentGuess = '';
  int attemptsLeft = 6;
  bool gameWon = false;
  bool gameLost = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    secretWord = wordList[Random().nextInt(wordList.length)];
    guesses = [];
    currentGuess = '';
    attemptsLeft = 6;
    gameWon = false;
    gameLost = false;
  }

  void _makeGuess() {
    if (currentGuess.length == secretWord.length) {
      setState(() {
        guesses.add(currentGuess);
        attemptsLeft--;

        if (currentGuess == secretWord) {
          gameWon = true;
        } else if (attemptsLeft == 0) {
          gameLost = true;
        }

        currentGuess = '';
      });
    }
  }

  Color _getLetterColor(String guess, int index) {
    final letter = guess[index];
    final secretLetter = secretWord[index];

    if (letter == secretLetter) {
      return Colors.green;
    } else if (secretWord.contains(letter)) {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🟩 Wordle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (gameWon)
              Column(
                children: [
                  const Text(
                    '🎉 You Won!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(_initializeGame);
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              )
            else if (gameLost)
              Column(
                children: [
                  Text(
                    'Game Over! The word was: $secretWord',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(_initializeGame);
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text('Attempts left: $attemptsLeft'),
                  const SizedBox(height: 20),
                  ...guesses.map(
                    (guess) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          guess.length,
                          (index) => Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _getLetterColor(guess, index),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                guess[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    maxLength: secretWord.length,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    onChanged: (value) {
                      setState(() => currentGuess = value.toUpperCase());
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your guess',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: currentGuess.length == secretWord.length
                        ? _makeGuess
                        : null,
                    child: const Text('Submit Guess'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
