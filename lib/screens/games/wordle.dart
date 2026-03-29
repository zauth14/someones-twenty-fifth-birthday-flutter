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
    'CUTIE',
    'ADORE',
    'VALOR',
    'SWEET',
    'DANCE',
    'LIGHT',
    'SHINE',
    'SMILE',
    'COMFY',
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
      return const Color(0xFF22C55E); // green = correct
    } else if (secretWord.contains(letter)) {
      return const Color(0xFFFF8C42); // orange = in word
    } else {
      return const Color(0xFF2D1B4E); // dark plum = not in word
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF1A0A2E);
    const bgBottom = Color(0xFF2D1B4E);
    const accentOrange = Color(0xFFFF8C42);
    const accentRose = Color(0xFFFB7185);
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (gameWon)
                      Column(
                        children: [
                          const Text(
                            '✨ Cracked it!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: accentOrange,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('New Word'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentOrange,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                            ),
                            onPressed: () => setState(_initializeGame),
                          ),
                        ],
                      )
                    else if (gameLost)
                      Column(
                        children: [
                          Text(
                            '💔 The word was: $secretWord',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: accentRose,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentRose,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                            ),
                            onPressed: () => setState(_initializeGame),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          // Attempts as dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tries left  ',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ...List.generate(6, (i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: Icon(
                                    i < attemptsLeft
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: i < attemptsLeft
                                        ? accentOrange
                                        : Colors.white24,
                                    size: 12,
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Letter grid
                          Column(
                            children: List.generate(6, (row) {
                              String guess = row < guesses.length
                                  ? guesses[row]
                                  : (row == guesses.length ? currentGuess : '');
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(wordLength, (col) {
                                    String letter = col < guess.length
                                        ? guess[col]
                                        : '';
                                    Color color;
                                    if (row < guesses.length) {
                                      color = _getLetterColor(guess, col);
                                    } else if (row == guesses.length &&
                                        letter.isNotEmpty) {
                                      color = tileBase.withOpacity(0.8);
                                    } else {
                                      color = tileBase.withOpacity(0.3);
                                    }
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeOut,
                                      width: 52,
                                      height: 52,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              row == guesses.length &&
                                                  col == guess.length
                                              ? accentOrange.withOpacity(0.6)
                                              : Colors.white.withOpacity(0.08),
                                          width:
                                              row == guesses.length &&
                                                  col == guess.length
                                              ? 2
                                              : 1,
                                        ),
                                        boxShadow: row < guesses.length
                                            ? [
                                                BoxShadow(
                                                  color: color.withOpacity(0.4),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Center(
                                        child: Text(
                                          letter,
                                          style: TextStyle(
                                            color: row < guesses.length
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 22,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),

                          // Input field
                          TextField(
                            controller: _guessController,
                            maxLength: wordLength,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            onChanged: (value) {
                              setState(
                                () => currentGuess = value.toUpperCase(),
                              );
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 8,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '· · · · ·',
                              hintStyle: TextStyle(
                                color: Colors.white24,
                                letterSpacing: 12,
                                fontSize: 20,
                              ),
                              counterStyle: const TextStyle(
                                color: Colors.white30,
                              ),
                              filled: true,
                              fillColor: tileBase.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: accentOrange,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.send_rounded, size: 18),
                              label: const Text('Lock In'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentOrange,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.white
                                    .withOpacity(0.08),
                                disabledForegroundColor: Colors.white38,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: currentGuess.length == wordLength
                                  ? _makeGuess
                                  : null,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }
}
