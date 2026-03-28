import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';

/// Full-screen intro animation that plays before a game loads.
///
/// [phases]      – List of text lines to cycle through (placeholders for now).
/// [game]        – The game widget to push after the animation completes.
/// [accentColor] – Primary color from the card gradient, used for the ambient glow.
class GameIntroScreen extends StatefulWidget {
  final List<String> phases;
  final Widget game;
  final Color accentColor;

  const GameIntroScreen({
    super.key,
    required this.phases,
    required this.game,
    required this.accentColor,
  });

  @override
  State<GameIntroScreen> createState() => _GameIntroScreenState();
}

class _GameIntroScreenState extends State<GameIntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _textCtrl;
  late AnimationController _particleCtrl;
  int _phase = 0;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    );
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _runSequence();
  }

  Future<void> _runSequence() async {
    for (int i = 0; i < widget.phases.length; i++) {
      if (!mounted) return;
      setState(() => _phase = i);
      _textCtrl.value = 0.0;

      // Fade in
      await _textCtrl.animateTo(
        0.5,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
      );

      // Hold — first phase is shorter, last is longer for emphasis
      final holdMs =
          i == 0
              ? 1400
              : (i == widget.phases.length - 1 ? 2200 : 1800);
      await Future.delayed(Duration(milliseconds: holdMs));
      if (!mounted) return;

      // Fade out (except the last phase — it fades directly into the game)
      if (i < widget.phases.length - 1) {
        await _textCtrl.animateTo(
          1.0,
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeIn,
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _doNavigate();
  }

  void _doNavigate() {
    if (_navigating) return;
    _navigating = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (_, __, ___) => widget.game,
        transitionsBuilder:
            (_, anim, __, child) => FadeTransition(
              opacity: CurvedAnimation(
                parent: anim,
                curve: Curves.easeInOut,
              ),
              child: child,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0615),
      body: Stack(
        children: [
          // Dark background with accent glow in the center
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    widget.accentColor.withOpacity(0.18),
                    const Color(0xFF1A0D2E),
                    const Color(0xFF0D0615),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // Subtle accent glow top-left (purple tint)
          Positioned(
            left: -60,
            top: -60,
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.birthdayPurplePrimary.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Accent glow bottom-right (card color)
          Positioned(
            right: -60,
            bottom: -60,
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.accentColor.withOpacity(0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Starfield
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleCtrl,
              builder:
                  (_, __) => CustomPaint(
                    painter: _IntroStarfieldPainter(
                      _particleCtrl.value,
                      widget.accentColor,
                    ),
                  ),
            ),
          ),

          // Text content
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 32.0 : 80.0,
                ),
                child: AnimatedBuilder(
                  animation: _textCtrl,
                  builder: (_, __) {
                    final v = _textCtrl.value;
                    final double opacity;
                    final double slideY;
                    if (v <= 0.5) {
                      final p = Curves.easeOut.transform(v * 2);
                      opacity = p;
                      slideY = 26.0 * (1 - p);
                    } else {
                      final p = Curves.easeIn.transform((v - 0.5) * 2);
                      opacity = 1.0 - p;
                      slideY = -26.0 * p;
                    }

                    return Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, slideY),
                        child: _buildPhaseText(isSmall),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Skip button
          Positioned(
            bottom: 32,
            right: 32,
            child: TextButton(
              onPressed: _doNavigate,
              child: Text(
                'skip  →',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.28),
                  fontSize: 13,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseText(bool isSmall) {
    if (_phase >= widget.phases.length) return const SizedBox.shrink();
    final text = widget.phases[_phase];
    final isLast = _phase == widget.phases.length - 1;
    final isFirst = _phase == 0;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize:
            isFirst
                ? (isSmall ? 30 : 44)
                : isLast
                ? (isSmall ? 24 : 36)
                : (isSmall ? 20 : 28),
        fontWeight:
            isFirst
                ? FontWeight.bold
                : isLast
                ? FontWeight.w600
                : FontWeight.w400,
        color:
            isLast
                ? widget.accentColor.withOpacity(0.95)
                : Colors.white.withOpacity(isFirst ? 1.0 : 0.88),
        height: 1.6,
        letterSpacing: isFirst ? 0.8 : 0.3,
        shadows: [
          Shadow(
            color:
                isLast
                    ? widget.accentColor.withOpacity(0.6)
                    : AppTheme.birthdayPurplePrimary.withOpacity(0.5),
            blurRadius: isLast ? 28 : 18,
          ),
        ],
      ),
    );
  }
}

// ─── Starfield painter (same idea as welcome screen, but lighter) ─────────────

class _IntroStarfieldPainter extends CustomPainter {
  final double t;
  final Color accentColor;
  _IntroStarfieldPainter(this.t, this.accentColor);

  static final _rng = Random(77);
  static final _stars = List.generate(55, (i) {
    return [
      _rng.nextDouble(),
      _rng.nextDouble(),
      _rng.nextDouble(),
      _rng.nextDouble(),
      (_rng.nextInt(3)).toDouble(),
    ];
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _stars.length; i++) {
      final s = _stars[i];
      final x = s[0] * size.width;
      final y = s[1] * size.height;
      final sz = 0.5 + s[2] * 1.8;
      final phase = (t * 1.3 + s[3] * 3) % 1.0;
      final opacity = (sin(phase * 2 * pi) * 0.5 + 0.5) * 0.55;

      final Color c;
      switch (s[4].toInt()) {
        case 0:
          c = accentColor.withOpacity(opacity * 0.85);
          break;
        case 1:
          c = AppTheme.birthdayPurpleLight.withOpacity(opacity * 0.7);
          break;
        default:
          c = Colors.white.withOpacity(opacity);
      }

      canvas.drawCircle(Offset(x, y), sz, Paint()..color = c);
    }
  }

  @override
  bool shouldRepaint(_IntroStarfieldPainter old) => true;
}
