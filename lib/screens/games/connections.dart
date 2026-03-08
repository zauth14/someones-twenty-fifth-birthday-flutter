import 'package:flutter/material.dart';
import 'dart:math';

class ConnectionsScreen extends StatefulWidget {
  final bool isBirthdayMode;

  const ConnectionsScreen({super.key, this.isBirthdayMode = false});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  // Each puzzle has exactly 4 groups of 4 words = 16 words
  final List<Map<String, dynamic>> puzzles = [
    {
      'groups': [
        {
          'name': 'Fruits',
          'items': ['APPLE', 'BANANA', 'CHERRY', 'GRAPE'],
          'color': const Color(0xFFFBC02D),
        },
        {
          'name': 'Planets',
          'items': ['MARS', 'VENUS', 'SATURN', 'PLUTO'],
          'color': const Color(0xFF66BB6A),
        },
        {
          'name': 'Colors',
          'items': ['SCARLET', 'INDIGO', 'AMBER', 'IVORY'],
          'color': const Color(0xFF42A5F5),
        },
        {
          'name': 'Card Games',
          'items': ['POKER', 'BRIDGE', 'HEARTS', 'SPADES'],
          'color': const Color(0xFFAB47BC),
        },
      ],
    },
    {
      'groups': [
        {
          'name': 'Dog Breeds',
          'items': ['POODLE', 'BEAGLE', 'HUSKY', 'CORGI'],
          'color': const Color(0xFFFBC02D),
        },
        {
          'name': 'Instruments',
          'items': ['PIANO', 'VIOLIN', 'DRUMS', 'FLUTE'],
          'color': const Color(0xFF66BB6A),
        },
        {
          'name': 'Weather',
          'items': ['STORM', 'BREEZE', 'FROST', 'HAIL'],
          'color': const Color(0xFF42A5F5),
        },
        {
          'name': 'Dances',
          'items': ['WALTZ', 'SALSA', 'TANGO', 'SWING'],
          'color': const Color(0xFFAB47BC),
        },
      ],
    },
    {
      'groups': [
        {
          'name': 'Gems',
          'items': ['RUBY', 'PEARL', 'OPAL', 'TOPAZ'],
          'color': const Color(0xFFFBC02D),
        },
        {
          'name': 'Trees',
          'items': ['MAPLE', 'CEDAR', 'BIRCH', 'WILLOW'],
          'color': const Color(0xFF66BB6A),
        },
        {
          'name': 'Pasta',
          'items': ['PENNE', 'ORZO', 'ROTINI', 'ZITI'],
          'color': const Color(0xFF42A5F5),
        },
        {
          'name': 'Fabrics',
          'items': ['SILK', 'DENIM', 'LINEN', 'SUEDE'],
          'color': const Color(0xFFAB47BC),
        },
      ],
    },
  ];

  late List<Map<String, dynamic>> currentGroups;
  late List<String> remainingWords;
  Set<String> selectedItems = {};
  List<Map<String, dynamic>> solvedGroups = [];
  int mistakesLeft = 4;
  bool gameWon = false;
  bool gameLost = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final puzzle = puzzles[Random().nextInt(puzzles.length)];
    currentGroups = List<Map<String, dynamic>>.from(
      (puzzle['groups'] as List).map((g) => Map<String, dynamic>.from(g)),
    );
    remainingWords = [];
    for (final group in currentGroups) {
      remainingWords.addAll(List<String>.from(group['items']));
    }
    remainingWords.shuffle();
    selectedItems = {};
    solvedGroups = [];
    mistakesLeft = 4;
    gameWon = false;
    gameLost = false;
  }

  void _selectItem(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else if (selectedItems.length < 4) {
        selectedItems.add(item);
      }
    });
  }

  void _deselectAll() {
    setState(() => selectedItems.clear());
  }

  void _submit() {
    if (selectedItems.length != 4) return;

    Map<String, dynamic>? matchedGroup;
    for (final group in currentGroups) {
      final groupItems = Set<String>.from(group['items'] as List);
      if (groupItems.difference(selectedItems).isEmpty &&
          selectedItems.difference(groupItems).isEmpty) {
        matchedGroup = group;
        break;
      }
    }

    setState(() {
      if (matchedGroup != null) {
        solvedGroups.add(matchedGroup);
        currentGroups.remove(matchedGroup);
        for (final word in matchedGroup['items'] as List) {
          remainingWords.remove(word);
        }
        selectedItems.clear();
        if (remainingWords.isEmpty) {
          gameWon = true;
        }
      } else {
        mistakesLeft--;
        selectedItems.clear();
        if (mistakesLeft <= 0) {
          gameLost = true;
          for (final group in currentGroups) {
            solvedGroups.add(group);
          }
          remainingWords.clear();
        }
      }
    });
  }

  // Unique icon per group (instead of colored bars)
  static const List<IconData> _groupIcons = [
    Icons.star_rounded,
    Icons.favorite_rounded,
    Icons.bolt_rounded,
    Icons.local_fire_department_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    // Dark purple/orange palette
    const bgGradientTop = Color(0xFF1A0A2E);
    const bgGradientBottom = Color(0xFF2D1B4E);
    const accentOrange = Color(0xFFFF8C42);
    const accentRose = Color(0xFFFB7185);
    const tileBase = Color(0xFF3B1F6E);
    const tileSelected = Color(0xFFFF8C42);

    return Scaffold(
      appBar: AppBar(
        title: null,
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: bgGradientTop,
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgGradientTop, bgGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              children: [
                // --- Header: selection count + lives as hearts ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Selection counter chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selectedItems.isNotEmpty
                            ? accentOrange.withOpacity(0.2)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selectedItems.isNotEmpty
                              ? accentOrange
                              : Colors.white24,
                        ),
                      ),
                      child: Text(
                        '${selectedItems.length} / 4 picked',
                        style: TextStyle(
                          color: selectedItems.isNotEmpty
                              ? accentOrange
                              : Colors.white54,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    // Hearts for lives
                    Row(
                      children: List.generate(4, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            i < mistakesLeft
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: i < mistakesLeft
                                ? accentRose
                                : Colors.white24,
                            size: 22,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // --- Solved groups: horizontal chips with icon ---
                ...solvedGroups.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final group = entry.value;
                  final icon = _groupIcons[idx % _groupIcons.length];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (group['color'] as Color).withOpacity(0.7),
                            (group['color'] as Color).withOpacity(0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (group['name'] as String).toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  (group['items'] as List).join(' · '),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // --- Word grid: hexagonal-feel tiles in a staggered wrap ---
                if (remainingWords.isNotEmpty)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final rows = (remainingWords.length / 4).ceil();
                        final gapV = 10.0;
                        final tileH =
                            ((constraints.maxHeight - (rows - 1) * gapV) / rows)
                                .clamp(50.0, 68.0);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(rows, (row) {
                            final start = row * 4;
                            final end = (start + 4).clamp(
                              0,
                              remainingWords.length,
                            );
                            final rowWords = remainingWords.sublist(start, end);
                            // Stagger odd rows slightly to the right
                            final offset = row.isOdd ? 12.0 : 0.0;

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: gapV,
                                left: offset,
                              ),
                              child: Row(
                                children: rowWords.map((word) {
                                  final isSelected = selectedItems.contains(
                                    word,
                                  );
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: GestureDetector(
                                        onTap: () => _selectItem(word),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          curve: Curves.easeOut,
                                          height: tileH,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? tileSelected
                                                : tileBase,
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.white.withOpacity(
                                                      0.6,
                                                    )
                                                  : Colors.white.withOpacity(
                                                      0.08,
                                                    ),
                                              width: isSelected ? 2.0 : 1.0,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: accentOrange
                                                          .withOpacity(0.35),
                                                      blurRadius: 12,
                                                      spreadRadius: 1,
                                                    ),
                                                  ]
                                                : [],
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Checkmark badge
                                              if (isSelected)
                                                Positioned(
                                                  top: 4,
                                                  right: 6,
                                                  child: Container(
                                                    width: 16,
                                                    height: 16,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      size: 11,
                                                      color: Color(0xFFFF8C42),
                                                    ),
                                                  ),
                                                ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                      ),
                                                  child: Text(
                                                    word,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 13,
                                                      letterSpacing: 0.5,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.white
                                                                .withOpacity(
                                                                  0.75,
                                                                ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),

                // --- Action buttons: vertical stack, unique shapes ---
                if (!gameWon && !gameLost && remainingWords.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 28),
                    child: Column(
                      children: [
                        // Submit – wide pill
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.check_circle_outline,
                              size: 20,
                            ),
                            label: const Text('Lock In'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentOrange,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.white.withOpacity(
                                0.08,
                              ),
                              disabledForegroundColor: Colors.white38,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: selectedItems.length == 4
                                ? _submit
                                : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Clear – text button
                        TextButton(
                          onPressed: _deselectAll,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white54,
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          child: const Text('Clear Selection'),
                        ),
                      ],
                    ),
                  ),

                // --- Win ---
                if (gameWon)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 28),
                    child: Column(
                      children: [
                        const Text(
                          '✨ Nailed it!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: accentOrange,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.replay_rounded),
                          label: const Text('New Puzzle'),
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
                    ),
                  ),

                // --- Lose ---
                if (gameLost)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 28),
                    child: Column(
                      children: [
                        const Text(
                          '💔 Out of lives',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: accentRose,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'The groups are shown above',
                          style: TextStyle(fontSize: 13, color: Colors.white38),
                        ),
                        const SizedBox(height: 18),
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
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
