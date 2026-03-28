import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Song Data ────────────────────────────────────────────────────────────────

class _Song {
  final String emoji;
  final String title;
  final String artist;
  final String note;
  final String lyrics;
  final Color c1;
  final Color c2;

  const _Song({
    required this.emoji,
    required this.title,
    required this.artist,
    required this.note,
    required this.lyrics,
    required this.c1,
    required this.c2,
  });
}

const _songs = [
  _Song(
    emoji: '🌙',
    title: 'Golden Hour',
    artist: 'JVKE',
    note: 'this one\'s basically about you, sorry not sorry',
    lyrics:
        'I don\'t know how to tell you this\n'
        'But I\'m kind of into you\n'
        'And I\'m terrified\n'
        'Your eyes are like the sunrise\n'
        'Your touch is like the golden hour\n'
        'And I don\'t want to let go\n'
        'Even when the sun goes down',
    c1: Color(0xFF92400E),
    c2: Color(0xFF78350F),
  ),
  _Song(
    emoji: '💛',
    title: 'Yellow',
    artist: 'Coldplay',
    note: 'because everything about you shines',
    lyrics:
        'Look at the stars\n'
        'Look how they shine for you\n'
        'And everything you do\n'
        'Yeah, they were all yellow\n\n'
        'I came along\n'
        'I wrote a song for you\n'
        'And all the things you do\n'
        'And it was called "Yellow"',
    c1: Color(0xFF92400E),
    c2: Color(0xFFD97706),
  ),
  _Song(
    emoji: '🌊',
    title: 'Oceans (Where Feet May Fail)',
    artist: 'Hillsong United',
    note: 'the courage you carry quietly',
    lyrics:
        'You call me out upon the waters\n'
        'The great unknown, where feet may fail\n'
        'And there I find You in the mystery\n'
        'In oceans deep, my faith will stand\n\n'
        'Spirit, lead me where my trust is without borders\n'
        'Let me walk upon the waters\n'
        'Wherever You would call me',
    c1: Color(0xFF1E3A8A),
    c2: Color(0xFF1E40AF),
  ),
  _Song(
    emoji: '🌹',
    title: 'Make You Feel My Love',
    artist: 'Adele',
    note: 'I mean it, every word',
    lyrics:
        'When the rain is blowing in your face\n'
        'And the whole world is on your case\n'
        'I could offer you a warm embrace\n'
        'To make you feel my love\n\n'
        'I know you haven\'t made your mind up yet\n'
        'But I would never do you wrong\n'
        'I\'ve known it from the moment that we met\n'
        'No doubt in my mind where you belong',
    c1: Color(0xFF7C3AED),
    c2: Color(0xFF5B21B6),
  ),
  _Song(
    emoji: '✨',
    title: 'Lucky',
    artist: 'Jason Mraz & Colbie Caillat',
    note: 'even from 5845 miles away',
    lyrics:
        'Do you hear me? I\'m talking to you\n'
        'Across the water, across the deep blue ocean\n'
        'Under the open sky\n'
        'Oh my, baby, I\'m trying\n\n'
        'Lucky I\'m in love with my best friend\n'
        'Lucky to have been where I have been\n'
        'Lucky to be coming home again',
    c1: Color(0xFF065F46),
    c2: Color(0xFF047857),
  ),
];

// ─── Lyrics Screen ────────────────────────────────────────────────────────────

class LyricsScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const LyricsScreen({super.key, this.isBirthdayMode = false});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lightboxCtrl;

  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _lightboxCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void dispose() {
    _lightboxCtrl.dispose();
    super.dispose();
  }

  Future<void> _openCard(int i) async {
    setState(() => _selectedIndex = i);
    await _lightboxCtrl.forward();
  }

  Future<void> _closeCard() async {
    await _lightboxCtrl.reverse();
    if (!mounted) return;
    setState(() => _selectedIndex = -1);
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF1A0A2E);
    const bgBottom = Color(0xFF2D1B4E);

    return Scaffold(
      backgroundColor: bgTop,
      appBar: AppBar(
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
          child: Stack(
            children: [
              // ── Background: title + cards ──
              _buildCardsLayer(),

              // ── Lightbox overlay ──
              AnimatedBuilder(
                animation: _lightboxCtrl,
                builder: (_, __) {
                  if (_lightboxCtrl.value == 0) return const SizedBox.shrink();

                  final v = CurvedAnimation(
                    parent: _lightboxCtrl,
                    curve: Curves.easeOutCubic,
                  ).value;

                  return GestureDetector(
                    onTap: _closeCard, // tap backdrop to close
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10 * v,
                        sigmaY: 10 * v,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.65 * v),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {}, // prevent backdrop tap from firing
                            child: Opacity(
                              opacity: v.clamp(0.0, 1.0),
                              child: Transform.scale(
                                scale: 0.88 + 0.12 * v,
                                child: _selectedIndex != -1
                                    ? _buildLightboxPanel(
                                        _songs[_selectedIndex],
                                        context,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardsLayer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 560;
        final hPad = isDesktop ? 28.0 : 16.0;
        final gap = isDesktop ? 12.0 : 10.0;
        final availableW = constraints.maxWidth - hPad * 2;
        final cardW = isDesktop
            ? (availableW - gap * (_songs.length - 1)) / _songs.length
            : 140.0;
        final cardH = isDesktop
            ? (constraints.maxHeight * 0.42).clamp(180.0, 280.0)
            : 190.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
              child: Column(
                children: [
                  Text(
                    '🎵',
                    style: TextStyle(fontSize: isDesktop ? 40 : 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Songs for You',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isDesktop ? 26 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.2,
                      shadows: const [
                        Shadow(color: Color(0x80FF8C42), blurRadius: 22),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'tap a card to reveal the lyrics',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isDesktop ? 28 : 20),

            // Cards row
            if (isDesktop)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Row(
                  children: List.generate(_songs.length, (i) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: i < _songs.length - 1 ? gap : 0,
                        ),
                        child: SizedBox(
                          height: cardH,
                          child: _SmallCard(
                            song: _songs[i],
                            onTap: () => _openCard(i),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            else
              SizedBox(
                height: cardH,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  itemCount: _songs.length,
                  separatorBuilder: (_, __) => SizedBox(width: gap),
                  itemBuilder: (_, i) => SizedBox(
                    width: cardW,
                    child: _SmallCard(
                      song: _songs[i],
                      onTap: () => _openCard(i),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLightboxPanel(_Song song, BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDesktop = sw >= 560;
    final panelW = isDesktop ? (sw * 0.52).clamp(400.0, 580.0) : sw - 40.0;
    final panelMaxH = sh * 0.75;

    return Container(
      width: panelW,
      constraints: BoxConstraints(maxHeight: panelMaxH),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            song.c1.withOpacity(0.92),
            song.c2.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: song.c1.withOpacity(0.5),
            blurRadius: 60,
            spreadRadius: -8,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 12, 0),
            child: Row(
              children: [
                Text(song.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: GoogleFonts.poppins(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        song.artist,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button
                GestureDetector(
                  onTap: _closeCard,
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
            child: Divider(
              color: Colors.white.withOpacity(0.15),
              height: 1,
            ),
          ),

          // Scrollable lyrics content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal note
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '"${song.note}"',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.78),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Lyrics
                  Text(
                    song.lyrics,
                    style: GoogleFonts.poppins(
                      fontSize: isDesktop ? 15 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.92),
                      height: 2.0,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Small Card (in the row) ──────────────────────────────────────────────────

class _SmallCard extends StatefulWidget {
  final _Song song;
  final VoidCallback onTap;

  const _SmallCard({required this.song, required this.onTap});

  @override
  State<_SmallCard> createState() => _SmallCardState();
}

class _SmallCardState extends State<_SmallCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _pressed;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: active ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.song.c1, widget.song.c2],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: active
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
                width: active ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.song.c1.withOpacity(active ? 0.55 : 0.3),
                  blurRadius: active ? 28 : 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.song.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const Spacer(),
                  Text(
                    widget.song.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'tap  ♪',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 0.4,
                      ),
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
