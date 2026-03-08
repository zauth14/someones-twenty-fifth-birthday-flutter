import 'dart:math';
import 'package:flutter/material.dart';

/// Centralized game content for both Birthday and Normal modes.
/// Birthday content is personalized and hand-picked.
/// Normal content draws randomly from large pools each session.
///
/// To edit content for a specific mode, find the relevant section below.

class GameData {
  static final _rng = Random();

  // ═══════════════════════════════════════════════════════════
  // ██  WORDLE  ██
  // ═══════════════════════════════════════════════════════════

  /// Birthday mode: personalized 5-letter words (edit these!)
  static const List<String> birthdayWords = [
    'PARTY', 'HAPPY', 'SWEET', 'DANCE', 'SHINE',
    'SMILE', 'TOAST', 'CHARM', 'LIGHT', 'GAMES',
  ];

  /// Normal mode: large word bank (randomly picked each game)
  static const List<String> normalWordPool = [
    'BRAIN', 'HEART', 'LAUGH', 'DREAM', 'MAGIC', 'PEACE', 'FLAME', 'CHILL',
    'FROST', 'QUICK', 'THINK', 'BREAK', 'LEMON', 'MELON', 'STORM', 'CLOUD',
    'SPARK', 'TOWER', 'HOUSE', 'PLANT', 'MUSIC', 'TRACK', 'SOUND', 'VIDEO',
    'IMAGE', 'COLOR', 'SHAPE', 'LEARN', 'TEACH', 'STUDY', 'BRAVE', 'SWAMP',
    'BEAST', 'JUICE', 'LUNCH', 'GRAIN', 'CLIMB', 'STEEL', 'GRACE', 'NOBLE',
    'CRISP', 'BLOOM', 'ARISE', 'BLAZE', 'CRANE', 'DWELL', 'FEAST', 'GLEAM',
    'HAVEN', 'IVORY', 'JOLLY', 'KNEEL', 'LUNAR', 'MAPLE', 'OCEAN', 'PRIDE',
    'QUEST', 'ROVER', 'STARE', 'TREND', 'ULTRA', 'VIGOR', 'WHIRL', 'YIELD',
    'HONEY', 'OLIVE', 'PEARL', 'SCOUT', 'BEACH', 'FRESH', 'LUCKY', 'RIVER',
    'STONE', 'DRIFT', 'FLINT', 'CARGO', 'SIREN', 'EMBER', 'MANGO', 'SOLAR',
    'VAPOR', 'OMEGA', 'PLAZA', 'REIGN', 'AMBER', 'CEDAR', 'PETAL', 'TORCH',
    'ORBIT', 'PIXEL', 'VERSE', 'CORAL', 'VIVID', 'PRISM', 'OASIS', 'ROAST',
  ];

  static String getWordleWord(bool isBirthdayMode) {
    final pool = isBirthdayMode ? birthdayWords : normalWordPool;
    return pool[_rng.nextInt(pool.length)];
  }

  // ═══════════════════════════════════════════════════════════
  // ██  WAVELENGTH / SPECTRUM  ██
  // ═══════════════════════════════════════════════════════════

  /// Birthday mode: hand-picked spectrum prompts (edit these!)
  static const List<Map<String, dynamic>> birthdayWavelengthPrompts = [
    {'left': 'Hot', 'right': 'Cold', 'hint': 'Temperature', 'target': 0.2},
    {'left': 'Love', 'right': 'Hate', 'hint': 'Emotion', 'target': 0.8},
    {'left': 'Morning', 'right': 'Night', 'hint': 'Time of Day', 'target': 0.3},
    {'left': 'Fast', 'right': 'Slow', 'hint': 'Speed', 'target': 0.1},
    {'left': 'Happy', 'right': 'Sad', 'hint': 'Mood', 'target': 0.4},
  ];

  /// Normal mode: large pool of spectrum prompts (5 randomly picked each game)
  static const List<Map<String, dynamic>> normalWavelengthPool = [
    {'left': 'Sweet', 'right': 'Sour', 'hint': 'Taste', 'target': 0.35},
    {'left': 'Loud', 'right': 'Quiet', 'hint': 'Volume', 'target': 0.7},
    {'left': 'Young', 'right': 'Old', 'hint': 'Age', 'target': 0.5},
    {'left': 'Rich', 'right': 'Poor', 'hint': 'Wealth', 'target': 0.25},
    {'left': 'Brave', 'right': 'Scared', 'hint': 'Courage', 'target': 0.15},
    {'left': 'Smart', 'right': 'Foolish', 'hint': 'Wisdom', 'target': 0.8},
    {'left': 'Tall', 'right': 'Short', 'hint': 'Height', 'target': 0.6},
    {'left': 'Strong', 'right': 'Weak', 'hint': 'Strength', 'target': 0.2},
    {'left': 'Early', 'right': 'Late', 'hint': 'Punctuality', 'target': 0.45},
    {'left': 'Simple', 'right': 'Complex', 'hint': 'Difficulty', 'target': 0.75},
    {'left': 'Calm', 'right': 'Chaotic', 'hint': 'Energy', 'target': 0.55},
    {'left': 'Modern', 'right': 'Classic', 'hint': 'Style', 'target': 0.3},
    {'left': 'Spicy', 'right': 'Mild', 'hint': 'Flavor', 'target': 0.1},
    {'left': 'Urban', 'right': 'Rural', 'hint': 'Lifestyle', 'target': 0.65},
    {'left': 'Funny', 'right': 'Serious', 'hint': 'Humor', 'target': 0.4},
    {'left': 'Creative', 'right': 'Logical', 'hint': 'Thinking', 'target': 0.85},
    {'left': 'Energetic', 'right': 'Relaxed', 'hint': 'Vibe', 'target': 0.22},
    {'left': 'Leader', 'right': 'Follower', 'hint': 'Role', 'target': 0.38},
    {'left': 'Sunny', 'right': 'Rainy', 'hint': 'Weather', 'target': 0.72},
    {'left': 'Introvert', 'right': 'Extrovert', 'hint': 'Personality', 'target': 0.58},
  ];

  static List<Map<String, dynamic>> getWavelengthPrompts(bool isBirthdayMode) {
    if (isBirthdayMode) return List.from(birthdayWavelengthPrompts);
    final shuffled = List<Map<String, dynamic>>.from(normalWavelengthPool)..shuffle(_rng);
    return shuffled.take(5).toList();
  }

  // ═══════════════════════════════════════════════════════════
  // ██  CONNECTIONS / CATEGORY MATCH  ██
  // ═══════════════════════════════════════════════════════════

  static const List<Color> _groupColors = [
    Color(0xFFFBC02D), Color(0xFF66BB6A), Color(0xFF42A5F5), Color(0xFFAB47BC),
  ];

  /// Birthday mode: hand-picked connection puzzles (edit these!)
  static List<List<Map<String, dynamic>>> get birthdayConnectionsPuzzles => [
    [
      {'name': 'Fruits', 'items': ['APPLE', 'BANANA', 'CHERRY', 'GRAPE'], 'color': _groupColors[0]},
      {'name': 'Planets', 'items': ['MARS', 'VENUS', 'SATURN', 'PLUTO'], 'color': _groupColors[1]},
      {'name': 'Colors', 'items': ['SCARLET', 'INDIGO', 'AMBER', 'IVORY'], 'color': _groupColors[2]},
      {'name': 'Card Games', 'items': ['POKER', 'BRIDGE', 'HEARTS', 'SPADES'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Dog Breeds', 'items': ['POODLE', 'BEAGLE', 'HUSKY', 'CORGI'], 'color': _groupColors[0]},
      {'name': 'Instruments', 'items': ['PIANO', 'VIOLIN', 'DRUMS', 'FLUTE'], 'color': _groupColors[1]},
      {'name': 'Weather', 'items': ['STORM', 'BREEZE', 'FROST', 'HAIL'], 'color': _groupColors[2]},
      {'name': 'Dances', 'items': ['WALTZ', 'SALSA', 'TANGO', 'SWING'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Gems', 'items': ['RUBY', 'PEARL', 'OPAL', 'TOPAZ'], 'color': _groupColors[0]},
      {'name': 'Trees', 'items': ['MAPLE', 'CEDAR', 'BIRCH', 'WILLOW'], 'color': _groupColors[1]},
      {'name': 'Pasta', 'items': ['PENNE', 'ORZO', 'ROTINI', 'ZITI'], 'color': _groupColors[2]},
      {'name': 'Fabrics', 'items': ['SILK', 'DENIM', 'LINEN', 'SUEDE'], 'color': _groupColors[3]},
    ],
  ];

  /// Normal mode: large pool of connection groups (4 randomly assembled each game)
  static List<List<Map<String, dynamic>>> get normalConnectionsPool => [
    [
      {'name': 'Fish', 'items': ['TROUT', 'BASS', 'SALMON', 'TUNA'], 'color': _groupColors[0]},
      {'name': 'Currencies', 'items': ['DOLLAR', 'EURO', 'POUND', 'YEN'], 'color': _groupColors[1]},
      {'name': 'Planets', 'items': ['EARTH', 'MARS', 'VENUS', 'PLUTO'], 'color': _groupColors[2]},
      {'name': 'Breads', 'items': ['BAGEL', 'NAAN', 'TOAST', 'WAFFLE'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Flowers', 'items': ['DAISY', 'TULIP', 'ORCHID', 'LILY'], 'color': _groupColors[0]},
      {'name': 'Metals', 'items': ['STEEL', 'IRON', 'BRASS', 'COPPER'], 'color': _groupColors[1]},
      {'name': 'Birds', 'items': ['EAGLE', 'ROBIN', 'CRANE', 'DOVE'], 'color': _groupColors[2]},
      {'name': 'Cheese', 'items': ['BRIE', 'GOUDA', 'CHEDDAR', 'FETA'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Spices', 'items': ['CUMIN', 'BASIL', 'THYME', 'SAGE'], 'color': _groupColors[0]},
      {'name': 'Oceans', 'items': ['PACIFIC', 'ARCTIC', 'INDIAN', 'ATLANTIC'], 'color': _groupColors[1]},
      {'name': 'Shoes', 'items': ['BOOTS', 'HEELS', 'FLATS', 'CLOGS'], 'color': _groupColors[2]},
      {'name': 'Shapes', 'items': ['CIRCLE', 'SQUARE', 'OVAL', 'CUBE'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Citrus', 'items': ['ORANGE', 'LEMON', 'LIME', 'GRAPE'], 'color': _groupColors[0]},
      {'name': 'Fabrics', 'items': ['COTTON', 'SILK', 'WOOL', 'SATIN'], 'color': _groupColors[1]},
      {'name': 'Nuts', 'items': ['ALMOND', 'PECAN', 'WALNUT', 'CASHEW'], 'color': _groupColors[2]},
      {'name': 'Dances', 'items': ['POLKA', 'RUMBA', 'MAMBO', 'FOXTROT'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Reptiles', 'items': ['GECKO', 'COBRA', 'IGUANA', 'VIPER'], 'color': _groupColors[0]},
      {'name': 'Rivers', 'items': ['NILE', 'THAMES', 'SEINE', 'GANGES'], 'color': _groupColors[1]},
      {'name': 'Gemstones', 'items': ['JADE', 'ONYX', 'TOPAZ', 'OPAL'], 'color': _groupColors[2]},
      {'name': 'Soups', 'items': ['RAMEN', 'BISQUE', 'BROTH', 'GUMBO'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Tools', 'items': ['DRILL', 'SAW', 'WRENCH', 'HAMMER'], 'color': _groupColors[0]},
      {'name': 'Sports', 'items': ['TENNIS', 'RUGBY', 'HOCKEY', 'GOLF'], 'color': _groupColors[1]},
      {'name': 'Desserts', 'items': ['FUDGE', 'TART', 'MOUSSE', 'CREPE'], 'color': _groupColors[2]},
      {'name': 'Vehicles', 'items': ['SEDAN', 'TRUCK', 'COUPE', 'VAN'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Hats', 'items': ['BERET', 'FEDORA', 'BEANIE', 'TURBAN'], 'color': _groupColors[0]},
      {'name': 'Berries', 'items': ['CHERRY', 'ACAI', 'MANGO', 'GUAVA'], 'color': _groupColors[1]},
      {'name': 'Insects', 'items': ['ANT', 'MOTH', 'BEETLE', 'WASP'], 'color': _groupColors[2]},
      {'name': 'Drinks', 'items': ['MOCHA', 'LATTE', 'CIDER', 'COCOA'], 'color': _groupColors[3]},
    ],
    [
      {'name': 'Countries', 'items': ['CHILE', 'JAPAN', 'EGYPT', 'NEPAL'], 'color': _groupColors[0]},
      {'name': 'Seasons', 'items': ['SPRING', 'SUMMER', 'AUTUMN', 'WINTER'], 'color': _groupColors[1]},
      {'name': 'Emotions', 'items': ['JOY', 'ANGER', 'FEAR', 'PRIDE'], 'color': _groupColors[2]},
      {'name': 'Textiles', 'items': ['DENIM', 'LINEN', 'SUEDE', 'TWEED'], 'color': _groupColors[3]},
    ],
  ];

  static List<Map<String, dynamic>> getConnectionsPuzzle(bool isBirthdayMode) {
    final pool = isBirthdayMode ? birthdayConnectionsPuzzles : normalConnectionsPool;
    return List<Map<String, dynamic>>.from(
      pool[_rng.nextInt(pool.length)].map((g) => Map<String, dynamic>.from(g)),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ██  10 THINGS (BUZZFEED-STYLE CARD FLIPPER)  ██
  // ═══════════════════════════════════════════════════════════

  /// Birthday mode: personalized praise cards (edit these!)
  static const List<String> birthdayPraises = [
    'You always make everyone laugh!',
    'Your curiosity is inspiring.',
    'You\u2019re a loyal friend.',
    'You have great taste in music.',
    'You\u2019re always up for an adventure.',
    'You give the best advice.',
    'You\u2019re incredibly thoughtful.',
    'You light up every room.',
    'You\u2019re a problem solver.',
    'You make life more fun!',
  ];

  /// Normal mode: large compliment pool (10 randomly picked each game)
  static const List<String> normalPraisePool = [
    'You radiate positive energy!',
    'Your smile is contagious.',
    'People love being around you.',
    'You have an amazing sense of humor.',
    'You\u2019re braver than you think.',
    'Your kindness makes a real difference.',
    'You bring out the best in others.',
    'You have impeccable taste.',
    'Your creativity knows no bounds.',
    'You handle pressure like a pro.',
    'You inspire people without even trying.',
    'You make the world a little brighter.',
    'Your energy is absolutely magnetic.',
    'You\u2019re the friend everyone deserves.',
    'You never give up, and it shows.',
    'You have a heart of gold.',
    'Your determination is inspiring.',
    'You make hard things look easy.',
    'People trust you for a reason.',
    'You\u2019re one in a million.',
    'Your ideas are always brilliant.',
    'You lift people up effortlessly.',
    'You\u2019re cooler than you realize.',
    'You have the best comebacks.',
    'Your warmth makes people feel safe.',
  ];

  static List<String> getPraises(bool isBirthdayMode) {
    if (isBirthdayMode) return List.from(birthdayPraises);
    final shuffled = List<String>.from(normalPraisePool)..shuffle(_rng);
    return shuffled.take(10).toList();
  }

  // ═══════════════════════════════════════════════════════════
  // ██  QUIZ TIME (PERSONALITY QUIZZES)  ██
  // ═══════════════════════════════════════════════════════════

  /// Birthday mode: hand-picked quizzes (edit these!)
  static const List<Map<String, dynamic>> birthdayQuizzes = [
    {
      'title': 'Which Dessert Are You?',
      'emoji': '🍰',
      'questions': [
        {'q': 'Pick a weekend vibe:', 'options': ['Beach day', 'Movie marathon', 'Road trip', 'Cooking at home']},
        {'q': 'Choose a color palette:', 'options': ['Sunset orange', 'Ocean blue', 'Forest green', 'Berry pink']},
        {'q': 'Your go-to drink:', 'options': ['Iced coffee', 'Smoothie', 'Hot chocolate', 'Sparkling water']},
        {'q': 'Pick a superpower:', 'options': ['Time travel', 'Invisibility', 'Flying', 'Mind reading']},
      ],
      'results': [
        'You\'re a classic Tiramisu — layered, elegant, and unforgettable!',
        'You\'re a warm Brownie — rich, comforting, and loved by everyone!',
        'You\'re a colorful Macaron — unique, trendy, and full of surprises!',
        'You\'re a refreshing Sorbet — vibrant, light, and always uplifting!',
      ],
    },
    {
      'title': 'What\'s Your Party Anthem?',
      'emoji': '🎶',
      'questions': [
        {'q': 'Pick a dance move:', 'options': ['The Spin', 'The Shimmy', 'The Dip', 'Free-style chaos']},
        {'q': 'Your ideal party size:', 'options': ['Just my crew (5-8)', 'Medium bash (20-30)', 'Huge blowout (50+)', 'One-on-one hangout']},
        {'q': 'What are you doing at a party?', 'options': ['Dancing non-stop', 'By the snack table', 'Telling stories', 'Taking photos']},
        {'q': 'Choose a party theme:', 'options': ['Retro disco', 'Garden party', 'Masquerade', 'Neon glow']},
      ],
      'results': [
        'Your anthem is "Dancing Queen" — you own every dance floor!',
        'Your anthem is "Good as Hell" — confident and unstoppable!',
        'Your anthem is "Mr. Brightside" — you bring the energy!',
        'Your anthem is "Levitating" — smooth, groovy, and magnetic!',
      ],
    },
    {
      'title': 'What Kind of Friend Are You?',
      'emoji': '💛',
      'questions': [
        {'q': 'A friend calls at 2 AM — you:', 'options': ['Answer immediately', 'Text "you ok?"', 'Call back in the morning', 'Show up at their door']},
        {'q': 'Your friend group role:', 'options': ['The planner', 'The hype person', 'The therapist', 'The wildcard']},
        {'q': 'Pick a friendship activity:', 'options': ['Brunch', 'Karaoke night', 'Deep talks on a drive', 'Spontaneous adventure']},
        {'q': 'Your love language with friends:', 'options': ['Words of affirmation', 'Quality time', 'Acts of service', 'Gifts & surprises']},
      ],
      'results': [
        'You\'re The Rock — reliable, strong, and always there!',
        'You\'re The Hype Machine — you lift everyone\'s spirits!',
        'You\'re The Sage — wise, caring, and everyone\'s safe space!',
        'You\'re The Spark — spontaneous, fun, and full of life!',
      ],
    },
  ];

  /// Normal mode: large quiz pool (3 randomly picked each session)
  static const List<Map<String, dynamic>> normalQuizPool = [
    {
      'title': 'What City Should You Live In?',
      'emoji': '🌆',
      'questions': [
        {'q': 'Pick a morning routine:', 'options': ['Coffee & a book', 'Gym session', 'Sleep in', 'Walk in the park']},
        {'q': 'Your ideal Friday night:', 'options': ['Rooftop bar', 'Board game night', 'Concert', 'Netflix & chill']},
        {'q': 'Pick a cuisine:', 'options': ['Japanese', 'Italian', 'Mexican', 'Indian']},
        {'q': 'Your travel style:', 'options': ['Planned itinerary', 'Go with the flow', 'Luxury resort', 'Backpacking']},
      ],
      'results': [
        'Tokyo — buzzing, futuristic, and endlessly fascinating!',
        'Copenhagen — cozy, stylish, and thoughtfully designed!',
        'Buenos Aires — passionate, vibrant, and full of flavor!',
        'Melbourne — creative, laid-back, and effortlessly cool!',
      ],
    },
    {
      'title': 'What Season Matches Your Soul?',
      'emoji': '🍂',
      'questions': [
        {'q': 'Pick a comfort item:', 'options': ['Blanket', 'Sunglasses', 'Rain boots', 'A good playlist']},
        {'q': 'Ideal way to spend Sunday:', 'options': ['Cozy indoors', 'Beach or pool', 'Farmers market', 'Hiking']},
        {'q': 'Pick a scent:', 'options': ['Cinnamon', 'Coconut', 'Fresh rain', 'Pine trees']},
        {'q': 'Preferred time of day:', 'options': ['Golden hour', 'High noon', 'Early morning', 'Late night']},
      ],
      'results': [
        'Autumn — warm, reflective, and full of golden moments!',
        'Summer — bright, energetic, and always a good time!',
        'Spring — fresh, hopeful, and blooming with possibility!',
        'Winter — cozy, deep, and beautifully quiet!',
      ],
    },
    {
      'title': 'What\u2019s Your Hidden Talent?',
      'emoji': '✨',
      'questions': [
        {'q': 'In a group project, you:', 'options': ['Take charge', 'Come up with ideas', 'Do the research', 'Make everyone laugh']},
        {'q': 'Pick a hobby:', 'options': ['Painting', 'Cooking', 'Writing', 'Sports']},
        {'q': 'People come to you for:', 'options': ['Advice', 'Fun', 'Comfort', 'Honesty']},
        {'q': 'Your secret strength:', 'options': ['Patience', 'Creativity', 'Empathy', 'Determination']},
      ],
      'results': [
        'Leadership — you rally people and make things happen!',
        'Storytelling — you captivate people with your words!',
        'Healing — your presence alone makes people feel better!',
        'Humor — you turn any moment into something memorable!',
      ],
    },
    {
      'title': 'Which Fictional World Do You Belong In?',
      'emoji': '🏰',
      'questions': [
        {'q': 'Pick a mode of transport:', 'options': ['Flying carpet', 'Spaceship', 'Horse & carriage', 'Teleportation']},
        {'q': 'Ideal sidekick:', 'options': ['A wise owl', 'A robot', 'A talking sword', 'A loyal dog']},
        {'q': 'Your quest would be:', 'options': ['Finding treasure', 'Saving a kingdom', 'Exploring the unknown', 'Solving a mystery']},
        {'q': 'Pick a power:', 'options': ['Magic spells', 'Super speed', 'Shapeshifting', 'Time control']},
      ],
      'results': [
        'A magical realm — you thrive in wonder and enchantment!',
        'A sci-fi galaxy — you\'re built for innovation and adventure!',
        'A medieval kingdom — honor, bravery, and epic quests suit you!',
        'A detective noir — mystery and intrigue fuel your soul!',
      ],
    },
    {
      'title': 'What\u2019s Your Comfort Food?',
      'emoji': '🍕',
      'questions': [
        {'q': 'Pick a mood:', 'options': ['Cozy', 'Adventurous', 'Nostalgic', 'Celebratory']},
        {'q': 'Your go-to snack:', 'options': ['Chips', 'Fruit', 'Chocolate', 'Cheese']},
        {'q': 'Ideal meal setting:', 'options': ['Picnic outside', 'Fancy restaurant', 'Couch at home', 'Campfire']},
        {'q': 'Pick a drink pairing:', 'options': ['Lemonade', 'Wine', 'Milkshake', 'Hot tea']},
      ],
      'results': [
        'Mac & Cheese — classic, warm, and universally loved!',
        'Pizza — versatile, exciting, and always a crowd-pleaser!',
        'Ramen — complex, comforting, and deeply satisfying!',
        'Pancakes — sweet, nostalgic, and pure happiness!',
      ],
    },
    {
      'title': 'What Kind of Traveler Are You?',
      'emoji': '✈️',
      'questions': [
        {'q': 'Packing style:', 'options': ['Overpacker', 'Carry-on only', 'Last minute toss', 'Organized lists']},
        {'q': 'Ideal destination:', 'options': ['Tropical island', 'Historic city', 'Mountain retreat', 'Road trip']},
        {'q': 'On vacation you:', 'options': ['Try every local food', 'Visit all the landmarks', 'Relax by the pool', 'Go on adventures']},
        {'q': 'Travel buddy:', 'options': ['Best friend', 'Solo', 'Big group', 'Partner']},
      ],
      'results': [
        'The Foodie Explorer — every trip revolves around taste!',
        'The Culture Buff — museums, history, and hidden gems!',
        'The Zen Seeker — you travel to recharge your soul!',
        'The Thrill Chaser — zip lines, dives, and no regrets!',
      ],
    },
  ];

  static List<Map<String, dynamic>> getQuizzes(bool isBirthdayMode) {
    if (isBirthdayMode) return List.from(birthdayQuizzes);
    final shuffled = List<Map<String, dynamic>>.from(normalQuizPool)..shuffle(_rng);
    return shuffled.take(3).toList();
  }
}
