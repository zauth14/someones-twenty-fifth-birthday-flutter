import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "10 things I (don't) hate about you" section: 10 cards, tap to flip to next praise.
class TenThingsScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const TenThingsScreen({super.key, this.isBirthdayMode = false});

  @override
  State<TenThingsScreen> createState() => _TenThingsScreenState();
}

class _TenThingsScreenState extends State<TenThingsScreen>
    with SingleTickerProviderStateMixin {
  final List<String> praises = [
    'You are great at connections. And wavelength. And wordle. And quickly doing Buzzfeed quizzes. And everything you do, really.',
    'You are the most wholesome, caring, sweetest (and, yes, loveable) person I know.',
    'You do SO much for everyone (seriously, how do you have time??), and you never ask for anything in return (well, boobs/sex but we don\'t speak about that).',
    'You always know how to make me laugh, even when I don\'t want to.',
    'You stay true to yourself and your values, dreams, ambitions, and you inspire me to be a better person just by being you.',
    'You light up my life and the lives of everyone around you.',
    'You are a baddie on the outside, but a softie on the inside (and I love that)',
    'You make me feel super loved and cared for (even from 5845 miles away)',
    'You are the life of the party, hyping everyone up and making the feel prioritized and included (even though you are getting older and probably want to just go home and sleep instead).',
    'You are an ethereal angel and I am so lucky to have you in my life.',
  ];

  int currentIndex = 0;
  late AnimationController _fadeCtrl;
  bool _isFading = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> _nextCard() async {
    if (_isFading) return;
    _isFading = true;
    // Fade out
    await _fadeCtrl.animateTo(0.0, curve: Curves.easeOut);
    if (!mounted) return;
    setState(() {
      currentIndex = (currentIndex + 1) % praises.length;
    });
    // Fade in
    await _fadeCtrl.animateTo(1.0, curve: Curves.easeIn);
    _isFading = false;
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF1A0A2E);
    const bgBottom = Color(0xFF2D1B4E);
    const accentOrange = Color(0xFFFF8C42);
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
          child: Column(
            children: [
              // Card counter
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(praises.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: i == currentIndex ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == currentIndex
                              ? accentOrange
                              : i < currentIndex
                              ? accentOrange.withOpacity(0.4)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${currentIndex + 1} / ${praises.length}',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              // Title + description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      '💭',
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '10 Things I (don\'t) Hate About You',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                        shadows: [
                          Shadow(
                            color: accentOrange.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'a love letter, in 10 parts',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.45),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Card area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: GestureDetector(
                    onTap: _nextCard,
                    child: AnimatedBuilder(
                      animation: _fadeCtrl,
                      builder: (_, child) => Opacity(
                        opacity: _fadeCtrl.value,
                        child: child,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 300,
                          maxWidth: 480,
                          minHeight: 220,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 36,
                          ),
                          decoration: BoxDecoration(
                            color: tileBase,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: accentOrange.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentOrange.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              praises[currentIndex],
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.55,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
              // Tap hint
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Text(
                  'Tap the card to reveal the next one',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
