import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'screens/games/buzzfeed_quiz.dart';
import 'screens/games/connections.dart';
import 'screens/games/wavelength.dart';
import 'screens/games/wordle.dart';

void main() {
  runApp(const BirthdayApp());
}

Route<T> _smoothRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 520),
    reverseTransitionDuration: const Duration(milliseconds: 340),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final slide = Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(curved);
      final fade = Tween<double>(begin: 0, end: 1).animate(curved);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

class BirthdayApp extends StatelessWidget {
  const BirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Someone's 25th Birthday",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showBirthdayMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _showBirthdayMode
                ? const BirthdayModeScreen()
                : const GameHubScreen(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _showBirthdayMode ? 'Birthday Mode' : 'Normal Mode',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5E4A78),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch.adaptive(
                      value: _showBirthdayMode,
                      activeColor: const Color(0xFF9B6BDF),
                      onChanged: (value) {
                        setState(() {
                          _showBirthdayMode = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CountdownScreen extends StatelessWidget {
  const CountdownScreen({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1034),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            const Text(
              'Birthday starts in',
              style: TextStyle(color: Colors.white70, fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              '$seconds',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BirthdayModeScreen extends StatelessWidget {
  const BirthdayModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECDDFA),
      body: Stack(
        children: [
          const Positioned.fill(child: _PartyBackground()),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 56),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, color: Color(0xFF6D5A8A)),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: const Color(0xFFD3A9F5),
                              width: 2,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text('👑', style: TextStyle(fontSize: 18)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Zara's Section",
                                  style: TextStyle(
                                    color: Color(0xFF5A4A77),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 30 / 2,
                                  ),
                                ),
                              ),
                              _BadgeCount(count: 3),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const _PartyHeroIcons(),
                const SizedBox(height: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.03,
                      children: const [
                        _BirthdayTile(
                          title: 'Trivia',
                          icon: Icons.help_outline_rounded,
                          isPurple: true,
                          destination: TriviaStatementsScreen(),
                        ),
                        _BirthdayTile(
                          title: 'Spin the Wheel',
                          icon: Icons.blur_circular_rounded,
                          isPurple: false,
                          destination: SpinWheelScreen(),
                        ),
                        _BirthdayTile(
                          title: 'Games',
                          icon: Icons.sports_esports_rounded,
                          isPurple: true,
                          destination: BirthdayGamesScreen(),
                        ),
                        _BirthdayTile(
                          title: 'Rewards',
                          icon: Icons.card_giftcard_rounded,
                          isPurple: false,
                          destination: RewardsPlaceholderScreen(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          border: const Border(top: BorderSide(color: Color(0xFFE7DAF5))),
        ),
        child: BottomNavigationBar(
          currentIndex: 2,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFFF6A24D),
          unselectedItemColor: Color(0xFF7B68A6),
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_rounded),
              label: 'Rewards',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _BadgeCount extends StatelessWidget {
  const _BadgeCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFFF8E66),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PartyHeroIcons extends StatelessWidget {
  const _PartyHeroIcons();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('🎈', style: TextStyle(fontSize: 54)),
          Text('🎉', style: TextStyle(fontSize: 52)),
          Text('🪅', style: TextStyle(fontSize: 50)),
          Text('🎊', style: TextStyle(fontSize: 56)),
        ],
      ),
    );
  }
}

class _BirthdayTile extends StatelessWidget {
  const _BirthdayTile({
    required this.title,
    required this.icon,
    required this.isPurple,
    required this.destination,
  });

  final String title;
  final IconData icon;
  final bool isPurple;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    final colors = isPurple
        ? const [Color(0xFFB884F0), Color(0xFF9C65E2)]
        : const [Color(0xFFFFBE5D), Color(0xFFFF9F3F)];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(_smoothRoute(destination));
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x29000000),
                blurRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: colors.last, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BirthdaySubPageScaffold extends StatelessWidget {
  const _BirthdaySubPageScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECDDFA),
      body: Stack(
        children: [
          const Positioned.fill(child: _PartyBackground()),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF6D5A8A),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: const Color(0xFFD3A9F5),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF5A4A77),
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TriviaStatementsScreen extends StatefulWidget {
  const TriviaStatementsScreen({super.key});

  @override
  State<TriviaStatementsScreen> createState() => _TriviaStatementsScreenState();
}

class _TriviaStatementsScreenState extends State<TriviaStatementsScreen> {
  final List<String> _statements = const [
    'Zara can recognize 90s songs in under 3 seconds.',
    'She once planned a birthday in less than 24 hours and it was iconic.',
    'Her playlist titles are better than most movie names.',
    'She gives top-tier pep talks and elite snack recommendations.',
    'Her laugh is the official soundtrack of every fun hangout.',
  ];

  int _current = 0;

  void _nextStatement() {
    setState(() {
      _current = (_current + 1) % _statements.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _BirthdaySubPageScaffold(
      title: 'Trivia',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            Text(
              'Tap the card or button to see the next statement',
              style: TextStyle(
                color: const Color(0xFF5A4A77).withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _nextStatement,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 420),
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Container(
                      key: ValueKey<int>(_current),
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB884F0), Color(0xFF9C65E2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 12,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lightbulb_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _statements[_current],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA94D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _nextStatement,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text(
                  'Next statement',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _options = const [
    'Dance Move',
    'Compliment',
    'Truth',
    'Selfie Time',
    'Snack Break',
    'Sing Chorus',
    'Mini Dare',
    'Birthday Toast',
  ];

  late final AnimationController _controller;
  late Animation<double> _rotationAnimation;
  final _rng = math.Random();
  double _rotation = 0;
  String? _result;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2400),
        )..addListener(() {
          setState(() {
            _rotation = _rotationAnimation.value;
          });
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    if (_spinning) return;
    _spinning = true;

    final selectedIndex = _rng.nextInt(_options.length);
    final segment = (2 * math.pi) / _options.length;
    final target =
        _rotation +
        (6 * 2 * math.pi) -
        ((_rotation + (selectedIndex + 0.5) * segment) % (2 * math.pi));

    _rotationAnimation = Tween<double>(
      begin: _rotation,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    await _controller.forward(from: 0);

    setState(() {
      _result = _options[selectedIndex];
      _rotation = target % (2 * math.pi);
    });
    _spinning = false;
  }

  @override
  Widget build(BuildContext context) {
    return _BirthdaySubPageScaffold(
      title: 'Spin the Wheel',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: _rotation,
                      child: SizedBox(
                        width: 290,
                        height: 290,
                        child: CustomPaint(
                          painter: _WheelPainter(options: _options),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: const Color(0xFF5E4A78),
                        size: 54,
                      ),
                    ),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _result == null
                  ? const SizedBox(height: 58)
                  : Container(
                      key: ValueKey<String>(_result!),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'It landed on: $_result',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF5A4A77),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA94D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _spin,
                icon: const Icon(Icons.casino_rounded),
                label: Text(
                  _spinning ? 'Spinning...' : 'Spin',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter({required this.options});

  final List<String> options;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final segmentAngle = (2 * math.pi) / options.length;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final colors = <Color>[
      const Color(0xFFB884F0),
      const Color(0xFFFFB75F),
      const Color(0xFF9B6BDF),
      const Color(0xFFFFA245),
    ];

    for (int i = 0; i < options.length; i++) {
      final start = -math.pi / 2 + (i * segmentAngle);
      final paint = Paint()..color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        segmentAngle,
        true,
        paint,
      );

      final textAngle = start + (segmentAngle / 2);
      final textOffset = Offset(
        center.dx + (radius * 0.62) * math.cos(textAngle),
        center.dy + (radius * 0.62) * math.sin(textAngle),
      );
      textPainter.text = TextSpan(
        text: options[i],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      );
      textPainter.layout(maxWidth: 80);

      canvas.save();
      canvas.translate(textOffset.dx, textOffset.dy);
      canvas.rotate(textAngle + math.pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawCircle(center, radius - 3, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) {
    return oldDelegate.options != options;
  }
}

class BirthdayGamesScreen extends StatelessWidget {
  const BirthdayGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <({String name, IconData icon, Widget screen})>[
      (
        name: 'Buzzfeed Quiz',
        icon: Icons.psychology_rounded,
        screen: const BuzzfeedQuizScreen(),
      ),
      (
        name: 'Wordle',
        icon: Icons.grid_view_rounded,
        screen: const WordleScreen(),
      ),
      (
        name: 'Connections',
        icon: Icons.hub_rounded,
        screen: const ConnectionsScreen(),
      ),
      (
        name: 'Wavelength',
        icon: Icons.waves_rounded,
        screen: const WavelengthScreen(),
      ),
    ];

    return _BirthdaySubPageScaffold(
      title: 'Games',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: GridView.builder(
          itemCount: games.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) {
            final game = games[index];
            return _BirthdayTile(
              title: game.name,
              icon: game.icon,
              isPurple: index.isEven,
              destination: game.screen,
            );
          },
        ),
      ),
    );
  }
}

class RewardsPlaceholderScreen extends StatelessWidget {
  const RewardsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BirthdaySubPageScaffold(
      title: 'Rewards',
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Rewards are coming soon ✨',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5A4A77),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _PartyBackground extends StatefulWidget {
  const _PartyBackground();

  @override
  State<_PartyBackground> createState() => _PartyBackgroundState();
}

class _PartyBackgroundState extends State<_PartyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ConfettiBackgroundPainter(progress: _controller.value),
        );
      },
    );
  }
}

class _ConfettiBackgroundPainter extends CustomPainter {
  _ConfettiBackgroundPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final colors = [
      const Color(0x55B47EE9),
      const Color(0x55FFB85A),
      const Color(0x55A66AE5),
      const Color(0x55E1C7FD),
    ];

    for (int i = 0; i < 130; i++) {
      paint.color = colors[i % colors.length];
      final t = (i * 0.131 + progress) % 1;
      final x =
          (size.width * ((i * 73) % 100) / 100) +
          7 * math.sin((progress * 2 * math.pi) + i);
      final y = size.height * t;
      final radius = 1.7 + (i % 3) * 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    final streamPaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = const Color(0x77A864DA);

    for (int i = 0; i < 16; i++) {
      final startX = (size.width / 15) * i;
      final path = Path()..moveTo(startX, size.height * 0.12 + (i % 4) * 55);
      for (int j = 1; j <= 3; j++) {
        path.relativeQuadraticBezierTo(
          16,
          (j % 2 == 0 ? -10 : 12),
          32,
          (j % 2 == 0 ? -2 : 8),
        );
      }
      canvas.drawPath(path, streamPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class GameHubScreen extends StatelessWidget {
  const GameHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <({String emoji, String name, String desc, Widget screen})>[
      (
        emoji: '🧠',
        name: 'Buzzfeed Quiz',
        desc: 'Fun personality quiz',
        screen: const BuzzfeedQuizScreen(),
      ),
      (
        emoji: '🟩',
        name: 'Wordle',
        desc: 'Guess the word in 6 tries',
        screen: const WordleScreen(),
      ),
      (
        emoji: '🔗',
        name: 'Connections',
        desc: 'Find related groups',
        screen: const ConnectionsScreen(),
      ),
      (
        emoji: '🌊',
        name: 'Wavelength',
        desc: 'Place concepts on a spectrum',
        screen: const WavelengthScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Someone's 25th Birthday Games")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(_smoothRoute(game.screen));
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(game.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(
                      game.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      game.desc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
