import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class WordleScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const WordleScreen({super.key, this.isBirthdayMode = false});

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  static const int wordLength = 5;
  static const List<String> wordList = [
    'PARTY',
    'HAPPY',
    'GAMES',
    'SWEET',
    'DANCE',
    'LIGHT',
    'SHINE',
    'SMILE',
    'TOAST',
    'CHARM',
  ];

  late String secretWord;
  List<String> guesses = [];
  String currentGuess = '';
  final TextEditingController _guessController = TextEditingController();
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
    _guessController.clear();
    attemptsLeft = 6;
    gameWon = false;
    gameLost = false;
  }

  void _makeGuess() {
    if (currentGuess.length == wordLength) {
      setState(() {
        guesses.add(currentGuess);
        attemptsLeft--;

        if (currentGuess == secretWord) {
          gameWon = true;
        } else if (attemptsLeft == 0) {
          gameLost = true;
        }

        currentGuess = '';
        _guessController.clear();
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
      appBar: AppBar(
        title: null,
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
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
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.purple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 12,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Attempts left: $attemptsLeft',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // --- Custom grid ---
                          Column(
                            children: List.generate(6, (row) {
                              String guess = row < guesses.length
                                  ? guesses[row]
                                  : (row == guesses.length ? currentGuess : '');
                              // Staggered effect: indent odd rows
                              double leftPad = row.isOdd ? 24.0 : 0.0;
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: leftPad,
                                  bottom: 6,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(wordLength, (col) {
                                      String letter = col < guess.length
                                          ? guess[col]
                                          : '';
                                      Color color = Colors.transparent;
                                      if (row < guesses.length) {
                                        color = _getLetterColor(guess, col);
                                      } else if (row == guesses.length &&
                                          letter.isNotEmpty) {
                                        color = Colors.purple.shade100;
                                      }
                                      return AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        width: 44,
                                        height: 32,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ), // pill shape
                                          border: Border.all(
                                            color: Colors.purple.shade200,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            if (row < guesses.length)
                                              BoxShadow(
                                                color: Colors.purple.shade100,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            letter,
                                            style: TextStyle(
                                              color: row < guesses.length
                                                  ? Colors.white
                                                  : Colors.purple.shade700,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _guessController,
                            maxLength: wordLength,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            onChanged: (value) {
                              setState(
                                () => currentGuess = value.toUpperCase(),
                              );
                            },
                            decoration: InputDecoration(
                              hintText: 'Type your guess',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade400,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: currentGuess.length == wordLength
                                ? _makeGuess
                                : null,
                            child: const Text('Submit Guess'),
                          ),
                        ],
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
