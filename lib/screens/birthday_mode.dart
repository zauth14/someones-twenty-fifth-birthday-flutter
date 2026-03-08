import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../config/user_config.dart';
import 'games/buzzfeed_quiz.dart';
import 'games/wordle.dart';
import 'games/wavelength.dart';
import 'games/connections.dart';

class BirthdayModeScreen extends StatefulWidget {
  const BirthdayModeScreen({super.key});

  @override
  State<BirthdayModeScreen> createState() => _BirthdayModeScreenState();
}

class _BirthdayModeScreenState extends State<BirthdayModeScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _glowController;

  // Spin the wheel state
  late AnimationController _wheelController;
  double _wheelAngle = 0;
  bool _isSpinning = false;
  String? _wheelResult;

  // Rewards tracking
  int _gamesPlayed = 0;
  final List<String> _unlockedRewards = [];

  final List<Map<String, String>> _wheelItems = [
    {'label': '🎁 Mystery Gift', 'color': 'purple'},
    {'label': '🎵 Song Dedication', 'color': 'orange'},
    {'label': '📸 Memory Photo', 'color': 'purple'},
    {'label': '🍰 Cake Flavor Pick', 'color': 'orange'},
    {'label': '⭐ Birthday Wish', 'color': 'purple'},
    {'label': '🎉 Party Dance', 'color': 'orange'},
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _wheelController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _wheelController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSpinning = false;
          final idx =
              ((_wheelAngle / (2 * pi)) * _wheelItems.length).floor() %
              _wheelItems.length;
          _wheelResult = _wheelItems[idx]['label'];
        });
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _glowController.dispose();
    _wheelController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _wheelResult = null;
    });
    final spins = 3 + Random().nextInt(3);
    final extra = Random().nextDouble() * 2 * pi;
    _wheelAngle = spins * 2 * pi + extra;
    _wheelController.reset();
    _wheelController.forward();
  }

  void _navigateToGame(Widget game) {
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 520),
            pageBuilder: (context, animation, secondaryAnimation) => game,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );
                  return FadeTransition(
                    opacity: curved,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.06, 0),
                        end: Offset.zero,
                      ).animate(curved),
                      child: child,
                    ),
                  );
                },
          ),
        )
        .then((_) {
          setState(() {
            _gamesPlayed++;
            if (_gamesPlayed == 1 &&
                !_unlockedRewards.contains('🏅 First Game')) {
              _unlockedRewards.add('🏅 First Game');
            }
            if (_gamesPlayed >= 3 &&
                !_unlockedRewards.contains('⭐ Trivia Master')) {
              _unlockedRewards.add('⭐ Trivia Master');
            }
            if (_gamesPlayed >= 4 &&
                !_unlockedRewards.contains('🎉 Game Champion')) {
              _unlockedRewards.add('🎉 Game Champion');
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen purple-to-orange gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.birthdayPurplePrimary,
                  AppTheme.birthdayBackground,
                ],
              ),
            ),
          ),
        ),

        // Confetti
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                painter: BirthdayConfettiPainter(_confettiController.value),
              );
            },
          ),
        ),

        // Scrollable Content
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Birthday Header
                Text(
                  UserConfig.birthdayGreeting,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  UserConfig.birthdaySubtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.birthdayTextAccent,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                // ─── SECTION 1: TRIVIA ───
                _buildSectionHeader('🧠', 'Birthday Trivia'),
                const SizedBox(height: 12),
                _buildTriviaCard(),

                const SizedBox(height: 28),

                // ─── SECTION 2: SPIN THE WHEEL ───
                _buildSectionHeader('🎡', 'Spin the Wheel'),
                const SizedBox(height: 12),
                _buildSpinWheel(),

                const SizedBox(height: 28),

                // ─── SECTION 3: GAMES ───
                _buildSectionHeader('🎮', 'Birthday Games'),
                const SizedBox(height: 12),
                _buildGamesGrid(),

                const SizedBox(height: 28),

                // ─── SECTION 4: REWARDS ───
                _buildSectionHeader('🏆', 'Rewards'),
                const SizedBox(height: 12),
                _buildRewardsSection(),

                const SizedBox(height: 20),

                // Footer
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.1 + 0.05 * _glowController.value,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.birthdayTextAccent.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '✨ All personalized just for ${UserConfig.birthdayPersonName}! ✨',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Section Header ───
  Widget _buildSectionHeader(String emoji, String title) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ─── TRIVIA Section ───
  Widget _buildTriviaCard() {
    return GestureDetector(
      onTap: () => _navigateToGame(TenThingsScreen(isBirthdayMode: true)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppTheme.birthdayPurpleDark,
              AppTheme.birthdayPurplePrimary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.birthdayPurplePrimary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('💭', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How well do you know ${UserConfig.birthdayPersonName}?',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Answer fun personalized trivia questions!',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.birthdayOrangePrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Start Trivia →',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SPIN THE WHEEL Section ───
  Widget _buildSpinWheel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.birthdayOrangeDark.withOpacity(0.8),
            AppTheme.birthdayOrangePrimary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.birthdayOrangeLight.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // The Wheel
          SizedBox(
            height: 200,
            width: 200,
            child: AnimatedBuilder(
              animation: _wheelController,
              builder: (context, child) {
                final curvedValue = Curves.easeOutCubic.transform(
                  _wheelController.value,
                );
                return Transform.rotate(
                  angle: curvedValue * _wheelAngle,
                  child: child,
                );
              },
              child: CustomPaint(
                size: const Size(200, 200),
                painter: WheelPainter(_wheelItems),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Result
          if (_wheelResult != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'You got: $_wheelResult',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          if (_wheelResult != null) const SizedBox(height: 12),

          // Spin Button
          GestureDetector(
            onTap: _isSpinning ? null : _spinWheel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: _isSpinning
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _isSpinning
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: Text(
                _isSpinning ? 'Spinning...' : '🎡 Spin!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isSpinning
                      ? Colors.white60
                      : AppTheme.birthdayOrangeDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── GAMES Grid ───
  Widget _buildGamesGrid() {
    final games = [
      {
        'icon': '🔤',
        'title': 'Word Puzzle',
        'sub': '5-letter birthday challenge',
        'colors': [AppTheme.birthdayOrangePrimary, AppTheme.birthdayOrangeDark],
        'screen': const WordleScreen(isBirthdayMode: true),
      },
      {
        'icon': '〰️',
        'title': 'Spectrum',
        'sub': "Guess ${UserConfig.birthdayPersonName}'s vibe",
        'colors': [AppTheme.birthdayPurpleDark, AppTheme.birthdayOrangeDark],
        'screen': const WavelengthScreen(isBirthdayMode: true),
      },
      {
        'icon': '🔗',
        'title': 'Link Game',
        'sub': 'Find the matching groups',
        'colors': [AppTheme.birthdayPurplePrimary, AppTheme.birthdayPurpleDark],
        'screen': const ConnectionsScreen(isBirthdayMode: true),
      },
    ];

    return Column(
      children: games.map((g) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => _navigateToGame(g['screen'] as Widget),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: g['colors'] as List<Color>,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (g['colors'] as List<Color>)[0].withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    g['icon'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g['title'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          g['sub'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── REWARDS Section ───
  Widget _buildRewardsSection() {
    final allRewards = [
      {'icon': '🏅', 'name': 'First Game', 'need': 'Play 1 game'},
      {'icon': '⭐', 'name': 'Trivia Master', 'need': 'Play 3 games'},
      {'icon': '🎉', 'name': 'Game Champion', 'need': 'Play all 4 games'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.birthdayPurpleLight.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Games played: $_gamesPlayed',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 14),
          ...allRewards.map((r) {
            final unlocked = _unlockedRewards.contains(
              '${r['icon']} ${r['name']}',
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: unlocked
                          ? AppTheme.birthdayOrangePrimary.withOpacity(0.3)
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        unlocked ? r['icon']! : '🔒',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['name']!,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: unlocked ? Colors.white : Colors.white54,
                          ),
                        ),
                        Text(
                          unlocked ? 'Unlocked! 🎉' : r['need']!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: unlocked
                                ? AppTheme.birthdayTextAccent
                                : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (unlocked)
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.birthdayTextAccent,
                      size: 22,
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Wheel Painter ───
class WheelPainter extends CustomPainter {
  final List<Map<String, String>> items;
  WheelPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segAngle = 2 * pi / items.length;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < items.length; i++) {
      paint.color = i % 2 == 0
          ? AppTheme.birthdayPurplePrimary
          : AppTheme.birthdayOrangePrimary;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * segAngle - pi / 2,
        segAngle,
        true,
        paint,
      );

      // Draw segment border
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * segAngle - pi / 2,
        segAngle,
        true,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white.withOpacity(0.3)
          ..strokeWidth = 1.5,
      );
    }

    // Center circle
    canvas.drawCircle(center, 16, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      8,
      Paint()..color = AppTheme.birthdayOrangePrimary,
    );

    // Arrow/indicator at top
    final arrowPaint = Paint()..color = Colors.white;
    final arrowPath = Path()
      ..moveTo(center.dx - 10, 0)
      ..lineTo(center.dx + 10, 0)
      ..lineTo(center.dx, 18)
      ..close();
    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Confetti Painter ───
class BirthdayConfettiPainter extends CustomPainter {
  final double animationValue;
  BirthdayConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final colors = [
      AppTheme.birthdayPurpleLight,
      AppTheme.birthdayOrangeLight,
      AppTheme.birthdayTextAccent,
      Colors.white.withOpacity(0.7),
    ];

    for (int i = 0; i < 30; i++) {
      final offsetX = (i % 8) * (size.width / 8) + 10;
      final progress = (animationValue + (i * 0.12)) % 1.0;
      final y = progress * size.height * 1.2;
      final sway = 15.0 * (i % 3 - 1) * (1 - progress);
      final x = offsetX + sway;

      paint.color = colors[i % colors.length];

      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), 2.5, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: 5, height: 5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BirthdayConfettiPainter oldDelegate) => true;
}
