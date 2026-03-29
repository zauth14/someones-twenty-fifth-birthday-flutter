import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../config/user_config.dart';
import 'games/buzzfeed_quiz.dart';
import 'games/lyrics_screen.dart';
import 'games/wordle.dart';
import 'games/wavelength.dart';
import 'games/connections.dart';
import 'games/quiz_time.dart';
import 'game_intro_screen.dart';

// ─── Main Birthday Screen ─────────────────────────────────────────────────────

class BirthdayModeScreen extends StatefulWidget {
  const BirthdayModeScreen({super.key});

  @override
  State<BirthdayModeScreen> createState() => _BirthdayModeScreenState();
}

class _BirthdayModeScreenState extends State<BirthdayModeScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _entranceCtrl;

  @override
  void initState() {
    super.initState();

    _confettiCtrl = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _glowCtrl = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _entranceCtrl = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _glowCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  Animation<double> _cardAnim(int i) {
    final start = (i * 0.08).clamp(0.0, 0.7);
    final end = (start + 0.45).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _entranceCtrl,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1C0D33),
                  Color(0xFF24103D),
                  Color(0xFF1F1B29),
                  Color(0xFF2A1200),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),
        ),

        // Confetti layer — RepaintBoundary isolates repaints to this layer only
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _confettiCtrl,
              builder:
                  (_, __) => CustomPaint(
                    painter: BirthdayConfettiPainter(_confettiCtrl.value),
                  ),
            ),
          ),
        ),

        // Scrollable content
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final hPad = constraints.maxWidth >= 1000 ? 32.0 : 18.0;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildSectionLabel(),
                        const SizedBox(height: 16),
                        _buildCardsGrid(),
                        const SizedBox(height: 28),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder:
          (_, __) => Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (i) {
                  final pulse =
                      i % 2 == 0 ? _glowCtrl.value : 1 - _glowCtrl.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      i == 3 ? '✦' : '✧',
                      style: TextStyle(
                        color: AppTheme.birthdayTextAccent.withOpacity(
                          0.3 + 0.4 * pulse,
                        ),
                        fontSize: i == 3 ? 18 : 12,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              const Text('🎉', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 14),
              ShaderMask(
                shaderCallback:
                    (bounds) => const LinearGradient(
                      colors: [
                        AppTheme.birthdayPurpleLight,
                        Color(0xFFFBD38D),
                        AppTheme.birthdayOrangeLight,
                      ],
                    ).createShader(bounds),
                child: Text(
                  'Happy 25th Birthday to My Favorite Person!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ' ✨',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.birthdayTextAccent.withOpacity(0.85),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
    );
  }

  // ─── Section label ─────────────────────────────────────────────────────────

  Widget _buildSectionLabel() {
    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (_, child) {
        final v = CurvedAnimation(
          parent: _entranceCtrl,
          curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
        ).value;
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - v)),
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 1,
            color: Colors.white.withOpacity(0.15),
          ),
          const SizedBox(width: 10),
          Text(
            '🎮  pick your game',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.45),
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 1,
            color: Colors.white.withOpacity(0.15),
          ),
        ],
      ),
    );
  }

  // ─── Cards grid ────────────────────────────────────────────────────────────

  static const _cardDefs = [
    {
      'icon': '💭',
      'title': '10 Things I (Don\'t) Hate about You',
      'subtitle': 'This is the part where I shower...you...with compliments. Try to stay humble.',
      'action': 'Start',
      'g1': Color(0xFF5B21B6),
      'g2': Color(0xFF3B0D8E),
    },
    {
      'icon': '🎵',
      'title': 'Song Lyrics that Remind me of You',
      'subtitle': 'Because I\'m not creative enough to write poetry and recording a cover felt too cringe',
      'action': 'Open',
      'g1': Color(0xFF92400E),
      'g2': Color(0xFF78350F),
    },
    {
      'icon': '🔤',
      'title': 'Word(ish)le',
      'subtitle': 'Because I don\'t want to be sued for calling it Wordle ',
      'action': 'Play',
      'g1': Color(0xFF7C3AED),
      'g2': Color(0xFF5B21B6),
    },
    {
      'icon': '〰️',
      'title': 'The Spectrum of You',
      'subtitle': 'My attempt at making a Wavelength-style game, but with worse UI and more inside jokes',
      'action': 'Play',
      'g1': Color(0xFF9333EA),
      'g2': Color(0xFFEA580C),
    },
    {
      'icon': '🔗',
      'title': 'Connexions',
      'subtitle': 'Because I HAD to include your favourites, given that it is YOUR birthday.',
      'action': 'Play',
      'g1': Color(0xFFEA580C),
      'g2': Color(0xFF9333EA),
    },
    {
      'icon': '🧠',
      'title': 'FizzBuzzfeed Quizzes',
      'subtitle': 'You see what I did there hehehe?',
      'action': 'Play',
      'g1': Color(0xFFF97316),
      'g2': Color(0xFFEA580C),
    },
  ];

  Widget _buildCardsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 580
                ? 2
                : 1;
        const spacing = 14.0;
        final cardWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        final cardWidgets = <Widget>[];
        for (int i = 0; i < _cardDefs.length; i++) {
          final def = _cardDefs[i];
          cardWidgets.add(
            SizedBox(
              width: cardWidth,
              height: 240,
              child: _GameCard(
                icon: def['icon'] as String,
                title: def['title'] as String,
                subtitle: def['subtitle'] as String,
                actionText: def['action'] as String,
                gradientColors: [def['g1'] as Color, def['g2'] as Color],
                entrance: _cardAnim(i),
                onTap: () => _handleCardTap(i),
              ),
            ),
          );
        }

        return Wrap(spacing: spacing, runSpacing: spacing, children: cardWidgets);
      },
    );
  }

  static const _introPhases = [
    // 0 – 10 Things
    [
      'okay so...',
      'you know how I am TERRIBLE at giving you compliments, right?',
      'this probably won\'t change that, but I tried to be wholesome for once. Don\'t get used to it though.',
    ],
    // 1 – Songs for You
    [
      'music has a way of saying things...',
      'that words alone can\'t quite capture...',
      '...unless they are swear words. Teehee, jk. These songs remind me of you.',
    ],
    // 2 – Word Puzzle
    [
      '5 letters.',
      '6 tries.',
      'Good luck (not that you need it).',
    ],
    // 3 – Spectrum
    [
      'welcome to my personal hell of',
      'wavelength',
      'made with a little bit of love and a lot of overthinking',
    ],
    // 4 – Link Game
    [
      'everything is connected.',
      'some more obviously than others (wink wink).',
      'enjoy your favourite online game with a typo in the title due to copyright issues :)',
    ],
    // 5 – Quiz Time
    [
      'who are you, really?',
      'and no, "Trevor Wallace" is not the right answer',
      'but let\'s find out via these scientifically unproven, random but fun quizzes that I made up in 10 minutes!',
    ],
  ];

  void _handleCardTap(int i) {
    final Widget game;
    final List<String> phases;
    final Color accentColor;

    switch (i) {
      case 0:
        game = TenThingsScreen(isBirthdayMode: true);
        phases = List<String>.from(_introPhases[0]);
        accentColor = const Color(0xFF5B21B6);
        break;
      case 1:
        game = const LyricsScreen(isBirthdayMode: true);
        phases = List<String>.from(_introPhases[1]);
        accentColor = const Color(0xFF92400E);
        break;
      case 2:
        game = const WordleScreen(isBirthdayMode: true);
        phases = List<String>.from(_introPhases[2]);
        accentColor = const Color(0xFF7C3AED);
        break;
      case 3:
        game = const WavelengthScreen(isBirthdayMode: true);
        phases = List<String>.from(_introPhases[3]);
        accentColor = const Color(0xFF9333EA);
        break;
      case 4:
        game = const ConnectionsScreen(isBirthdayMode: true);
        phases = List<String>.from(_introPhases[4]);
        accentColor = const Color(0xFFEA580C);
        break;
      case 5:
        game = const QuizTimeScreen(isBirthdayMode: true);
        phases = List<String>.from(_introPhases[5]);
        accentColor = const Color(0xFFF97316);
        break;
      default:
        return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder:
            (_, __, ___) => GameIntroScreen(
              phases: phases,
              game: game,
              accentColor: accentColor,
            ),
        transitionsBuilder:
            (_, anim, __, child) => FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
              child: child,
            ),
      ),
    );
  }

  // ─── Footer ────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder:
          (_, __) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07 + 0.04 * _glowCtrl.value),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.birthdayTextAccent.withOpacity(0.25),
              ),
              // Static shadow — no per-frame interpolation
              boxShadow: const [
                BoxShadow(
                  color: Color(0x288B5CF6),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Text(
              '✨  Congrats on being old!!  ✨',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
    );
  }
}

// ─── Game Card ────────────────────────────────────────────────────────────────

class _GameCard extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String actionText;
  final List<Color> gradientColors;
  final Animation<double> entrance;
  final VoidCallback onTap;

  const _GameCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.gradientColors,
    required this.entrance,
    required this.onTap,
  });

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _active => _hovered || _pressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.entrance,
      builder: (_, child) {
        final v = widget.entrance.value;
        return Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 28 * (1 - v)),
            child: child,
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _active ? 1.035 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.gradientColors,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      _active
                          ? Colors.white.withOpacity(0.45)
                          : Colors.white.withOpacity(0.1),
                  width: _active ? 1.5 : 1.0,
                ),
                // Static shadow — never interpolated, no per-frame shadow cost
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors[0].withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.icon,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: Colors.white.withOpacity(0.72),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_active ? 0.28 : 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.actionText,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Confetti Painter ─────────────────────────────────────────────────────────

class BirthdayConfettiPainter extends CustomPainter {
  final double animationValue;
  BirthdayConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final colors = [
      AppTheme.birthdayPurpleLight,
      AppTheme.birthdayOrangeLight,
      AppTheme.birthdayTextAccent,
      Colors.white.withOpacity(0.6),
      const Color(0xFFFFB3C1),
    ];

    for (int i = 0; i < 22; i++) {
      final offsetX = (i % 11) * (size.width / 11) + rng.nextDouble() * 10;
      final progress = (animationValue + (i * 0.09)) % 1.0;
      final y = progress * size.height * 1.15 - 10;
      final sway = 14.0 * sin(progress * pi * 2 + i);
      final x = offsetX + sway;
      final rotation = progress * pi * 4 + i;

      final paint = Paint()..color = colors[i % colors.length];

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      if (i % 4 == 0) {
        canvas.drawCircle(Offset.zero, 3, paint);
      } else if (i % 4 == 1) {
        canvas.drawRect(const Rect.fromLTWH(-3, -3, 6, 6), paint);
      } else if (i % 4 == 2) {
        canvas.drawRect(const Rect.fromLTWH(-1, -5, 2, 10), paint);
      } else {
        final path =
            Path()
              ..moveTo(0, -4)
              ..lineTo(3, 0)
              ..lineTo(0, 4)
              ..lineTo(-3, 0)
              ..close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(BirthdayConfettiPainter old) =>
      old.animationValue != animationValue;
}

