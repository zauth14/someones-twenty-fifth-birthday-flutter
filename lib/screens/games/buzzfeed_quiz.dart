import 'package:flutter/material.dart';

/// "10 things I (don't) hate about you" section: 10 cards, tap to flip to next praise.
class TenThingsScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const TenThingsScreen({super.key, this.isBirthdayMode = false});

  @override
  State<TenThingsScreen> createState() => _TenThingsScreenState();
}

class _TenThingsScreenState extends State<TenThingsScreen> {
  final List<String> praises = [
    'You always make everyone laugh!',
    'Your curiosity is inspiring.',
    'You’re a loyal friend.',
    'You have great taste in music.',
    'You’re always up for an adventure.',
    'You give the best advice.',
    'You’re incredibly thoughtful.',
    'You light up every room.',
    'You’re a problem solver.',
    'You make life more fun!',
  ];

  int currentIndex = 0;

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % praises.length;
    });
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
      body: Center(
        child: GestureDetector(
          onTap: _nextCard,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Container(
              key: ValueKey(currentIndex),
              width: 320,
              height: 220,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  praises[currentIndex],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
