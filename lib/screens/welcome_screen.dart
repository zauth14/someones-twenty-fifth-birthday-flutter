import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import 'birthday_mode.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _textCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _bgCtrl;

  int _phase = 0;
  bool _navigating = false;

  static const _messages = [
    'Hi there, stranger',
    'If you think I took this time to curate\nsomething specifically for you...',
    '...you\'re wrong.\ni just love sidequesting',
    '...and building stuff...',
    '...and maaaybe also you (a little bit)',
  ];

  @override
  void initState() {
    super.initState();
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    );
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _runSequence();
  }

  Future<void> _runSequence() async {
    for (int i = 0; i < _messages.length; i++) {
      if (!mounted) return;
      setState(() => _phase = i);
      _textCtrl.value = 0.0;

      // Fade in
      await _textCtrl.animateTo(
        0.5,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOut,
      );

      // Hold
      final holdMs =
          i == 0
              ? 1800
              : (i == _messages.length - 1 ? 2800 : 2300);
      await Future.delayed(Duration(milliseconds: holdMs));
      if (!mounted) return;

      // Fade out (except last phase)
      if (i < _messages.length - 1) {
        await _textCtrl.animateTo(
          1.0,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeIn,
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) _doNavigate();
  }

  void _doNavigate() {
    if (_navigating) return;
    _navigating = true;
    // Stop expensive background animations so the departing screen
    // is completely static during the fade — no per-frame repaints.
    _particleCtrl.stop();
    _bgCtrl.stop();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder:
            (_, __, ___) => const Scaffold(
              backgroundColor: AppTheme.birthdayBackground,
              body: SafeArea(child: BirthdayModeScreen()),
            ),
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
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final isSmall = sw < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0615),
      body: Stack(
        children: [
          // Animated radial gradient background — isolated layer
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _bgCtrl,
                builder:
                    (_, __) => Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(
                            -0.3 + 0.25 * _bgCtrl.value,
                            -0.2 + 0.15 * _bgCtrl.value,
                          ),
                          radius: 1.1 + 0.25 * _bgCtrl.value,
                          colors: const [
                            Color(0xFF3B1F6A),
                            Color(0xFF1A0D2E),
                            Color(0xFF0D0615),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
              ),
            ),
          ),

          // Orange ambient glow bottom-right
          Positioned(
            right: -80,
            bottom: -80,
            child: IgnorePointer(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.birthdayOrangePrimary.withOpacity(0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Purple ambient glow top-left
          Positioned(
            left: -100,
            top: -100,
            child: IgnorePointer(
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.birthdayPurplePrimary.withOpacity(0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Starfield — isolated layer so text repaints don't touch it
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _particleCtrl,
                builder:
                    (_, __) => CustomPaint(
                      painter: _StarfieldPainter(_particleCtrl.value),
                    ),
              ),
            ),
          ),

          // Main text content
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 28.0 : 80.0,
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
                      slideY = 30.0 * (1 - p);
                    } else {
                      final p = Curves.easeIn.transform((v - 0.5) * 2);
                      opacity = 1.0 - p;
                      slideY = -30.0 * p;
                    }

                    return Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, slideY),
                        child: _buildPhaseContent(isSmall),
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

  Widget _buildPhaseContent(bool isSmall) {
    // Shared plain white style used by most phases
    TextStyle plainStyle(double small, double large) => GoogleFonts.poppins(
      fontSize: isSmall ? small : large,
      fontWeight: FontWeight.w400,
      color: Colors.white.withOpacity(0.88),
      height: 1.75,
      letterSpacing: 0.3,
      shadows: [
        Shadow(
          color: AppTheme.birthdayPurpleLight.withOpacity(0.4),
          blurRadius: 18,
        ),
      ],
    );

    switch (_phase) {
      // ── "hi there, stranger" ──────────────────────────────────────────────
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('✨', style: TextStyle(fontSize: isSmall ? 48 : 64)),
            const SizedBox(height: 20),
            Text(
              _messages[0],
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: isSmall ? 34 : 52,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 1.4,
                shadows: [
                  Shadow(
                    color: AppTheme.birthdayPurplePrimary.withOpacity(0.85),
                    blurRadius: 36,
                  ),
                ],
              ),
            ),
          ],
        );

      // ── "if you think i took this time to curate..." ──────────────────────
      case 1:
        return Text(
          _messages[1],
          textAlign: TextAlign.center,
          style: plainStyle(20, 30),
        );

      // ── "...you're wrong. i just love sidequesting" ───────────────────────
      // "sidequesting" gets accent emphasis; everything else plain white
      case 2:
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: isSmall ? 22 : 34,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.88),
              height: 1.65,
              letterSpacing: 0.2,
            ),
            children: [
              const TextSpan(text: '...you\'re wrong.\ni just love '),
              TextSpan(
                text: 'sidequesting',
                style: GoogleFonts.poppins(
                  fontSize: isSmall ? 22 : 34,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.birthdayOrangeLight,
                  height: 1.65,
                  shadows: [
                    Shadow(
                      color: AppTheme.birthdayOrangePrimary.withOpacity(0.75),
                      blurRadius: 28,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      // ── "...and building stuff..." — full emphasis ─────────────────────────
      case 3:
        return Text(
          _messages[3],
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: isSmall ? 28 : 44,
            fontWeight: FontWeight.bold,
            color: AppTheme.birthdayOrangeLight,
            height: 1.5,
            letterSpacing: 0.4,
            shadows: [
              Shadow(
                color: AppTheme.birthdayOrangePrimary.withOpacity(0.7),
                blurRadius: 34,
              ),
              Shadow(
                color: AppTheme.birthdayPurplePrimary.withOpacity(0.45),
                blurRadius: 60,
              ),
            ],
          ),
        );

      // ── "...and maaaybe also you (a little bit)" ──────────────────────────
      case 4:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _messages[4],
              textAlign: TextAlign.center,
              style: plainStyle(22, 34),
            ),
            const SizedBox(height: 28),
            Text('🎂', style: TextStyle(fontSize: isSmall ? 40 : 56)),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Starfield Painter ───────────────────────────────────────────────────────

class _StarfieldPainter extends CustomPainter {
  final double t;
  _StarfieldPainter(this.t);

  static final _rng = Random(99);
  static final _stars = List.generate(80, (i) {
    return [
      _rng.nextDouble(), // x
      _rng.nextDouble(), // y
      _rng.nextDouble(), // size factor
      _rng.nextDouble(), // phase offset
      (_rng.nextInt(3)).toDouble(), // color type
    ];
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _stars.length; i++) {
      final s = _stars[i];
      final x = s[0] * size.width;
      final y = s[1] * size.height;
      final sz = 0.5 + s[2] * 2.2;
      final phase = (t * 1.2 + s[3] * 3) % 1.0;
      final opacity = (sin(phase * 2 * pi) * 0.5 + 0.5) * 0.6;

      final Color c;
      switch (s[4].toInt()) {
        case 0:
          c = AppTheme.birthdayOrangeLight.withOpacity(opacity * 0.8);
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
  bool shouldRepaint(_StarfieldPainter old) => old.t != t;
}
