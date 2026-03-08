import 'package:flutter/material.dart';

class ConnectionsScreen extends StatefulWidget {
  final bool isBirthdayMode;
  
  const ConnectionsScreen({super.key, this.isBirthdayMode = false});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  final List<Map<String, dynamic>> puzzles = [
    {
      'items': [
        'APPLE',
        'BANANA',
        'CHERRY',
        'DATE',
        'ELF',
        'FOREST',
        'GRAPE',
        'HEART',
        'ICE',
        'JINGLE',
      ],
      'groups': [
        {
          'name': 'Fruits',
          'items': ['APPLE', 'BANANA', 'CHERRY', 'GRAPE'],
          'color': Colors.yellow,
        },
        {
          'name': 'Holiday Words',
          'items': ['ELF', 'JINGLE', 'HEART', 'ICE'],
          'color': Colors.red,
        },
        {
          'name': 'Things in Nature',
          'items': ['FOREST', 'DATE', 'Something', 'Something'],
          'color': Colors.green,
        },
        {
          'name': 'Rhyme with "LE"',
          'items': ['APPLE', 'JINGLE', 'SOMETHING', 'SOMETHING'],
          'color': Colors.blue,
        },
      ],
    },
  ];

  late Map<String, dynamic> currentPuzzle;
  Set<String> selectedItems = {};
  List<List<String>> solvedGroups = [];
  bool gameWon = false;
  int mistakesLeft = 4;

  @override
  void initState() {
    super.initState();
    currentPuzzle = puzzles[0];
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

  void _submit() {
    // Simplified - just show a message for now
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Great try! This is a simplified version.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔗 Connections')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mistakes left: $mistakesLeft',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: (currentPuzzle['items'] as List).length,
                itemBuilder: (context, index) {
                  final item = currentPuzzle['items'][index];
                  final isSelected = selectedItems.contains(item);

                  return GestureDetector(
                    onTap: () => _selectItem(item),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.purple.shade300
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? Colors.purple
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => selectedItems.clear()),
                  child: const Text('Deselect All'),
                ),
                ElevatedButton(
                  onPressed: selectedItems.length == 4 ? _submit : null,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
