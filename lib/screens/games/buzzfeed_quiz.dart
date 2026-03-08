import 'package:flutter/material.dart';
import '../../config/game_data.dart';

/// "10 things I (don't) hate about you" section: 10 cards, tap to flip to next praise.
class TenThingsScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const TenThingsScreen({super.key, this.isBirthdayMode = false});

  @override
  State<TenThingsScreen> createState() => _TenThingsScreenState();
}

class _TenThingsScreenState extends State<TenThingsScreen> {
  late List<String> praises;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    praises = GameData.getPraises(widget.isBirthdayMode);
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % praises.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBday = widget.isBirthdayMode;
    final bgTop = isBday ? const Color(0xFF1A0A2E) : const Color(0xFFFAF5FF);
    final bgBottom = isBday ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF);
    final accentOrange = isBday ? const Color(0xFFFF8C42) : const Color(0xFFFFA500);
    final tileBase = isBday ? const Color(0xFF3B1F6E) : const Color(0xFFE9D5FF);
    final textPrimary = isBday ? Colors.white : const Color(0xFF2D1B4E);
    final textMuted = isBday ? Colors.white38 : Colors.purple.shade300;
    final textFaint = isBday ? Colors.white.withOpacity(0.3) : Colors.purple.shade200;

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
                              : (isBday ? Colors.white24 : Colors.purple.shade100),
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
                style: TextStyle(
                  color: textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Card area
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _nextCard,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Container(
                        key: ValueKey(currentIndex),
                        width: 320,
                        height: 240,
                        padding: const EdgeInsets.all(28),
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
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
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
                    color: textFaint,
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
