# App Architecture & Implementation Plan

## App Name: GameHub (or your preferred name)

## Overview
Multi-game platform with personalized birthday mode and future multiplayer support.

---

## 📱 App Structure

### Screens Hierarchy
```
1. Splash Screen (optional)
2. Login Screen
3. Home/Mode Selector
   ├─ Birthday Mode (Purple/Orange Theme)
   │  ├─ Personalized Quiz
   │  ├─ Personalized Wordle
   │  ├─ Personalized Wavelength
   │  └─ Personalized Connections
   └─ Normal Mode (Regular Theme)
      ├─ Quiz Game
      ├─ Word Puzzle (Wordle-style)
      ├─ Wavelength Game
      └─ Link Game (Connections-style)
```

---

## 🎨 Design Specifications

### Birthday Mode Colors
- **Primary Purple**: `#8B5CF6` (violet)
- **Accent Purple**: `#A78BFA` (light purple)
- **Primary Orange**: `#F97316` (orange)
- **Accent Orange**: `#FB923C` (light orange)
- **Gradient**: Purple to Orange
- **Background**: Soft gradient or alternating sections

### Normal Mode Colors
- **Primary**: `#3B82F6` (blue)
- **Accent**: `#10B981` (green)
- **Neutral**: Grays and whites

---

## 🔐 Authentication & Data Strategy

### Phase 1 (March 28 Launch)
**Simple Local Authentication:**
- Hard-coded credentials for one user
- Store login state using `shared_preferences`
- No backend required
- Birthday info hard-coded

```dart
// Hard-coded user data
const String USER_NAME = "Your Friend's Name";
const String USER_BIRTHDAY = "2000-04-15"; // YYYY-MM-DD
const String LOGIN_PASSWORD = "birthday2025"; // Simple password
```

### Phase 2 (Future)
- Firebase Authentication
- Firestore for user profiles
- Real-time multiplayer with Firebase Realtime Database

---

## 🎮 Game Specifications

### 1. Quiz Game (BuzzFeed-style)
**Normal Mode:**
- General trivia/personality quizzes
- Multiple choice questions
- Result screen with shareable outcome

**Birthday Mode:**
- Personalized questions about shared memories
- Custom results (e.g., "You are 95% best friend!")

### 2. Word Puzzle (Wordle Clone)
**Name Change:** "Daily Word Challenge" or "5-Letter Puzzle"
**Normal Mode:**
- Standard 5-letter word guessing
- 6 attempts
- Color-coded feedback

**Birthday Mode:**
- Words related to birthday person
- Custom word list
- Purple/orange color scheme

### 3. Wavelength Game
**Normal Mode:**
- Spectrum guessing game
- Random prompts (Hot↔Cold, Love↔Hate)

**Birthday Mode:**
- Personalized prompts about birthday person's preferences
- Custom spectrums

### 4. Link Game (Connections Clone)
**Name Change:** "Category Finder" or "Group Links"
**Normal Mode:**
- Find 4 groups of 4 related items
- Color-coded difficulty

**Birthday Mode:**
- Categories about birthday person's life, interests
- Purple/orange color scheme

---

## 📊 Data Models

### User Model
```dart
class User {
  final String id;
  final String name;
  final DateTime birthday;
  final bool isBirthdayToday; // Check current date
  
  // Game progress
  final Map<String, GameProgress> gameProgress;
}
```

### Game Progress Model
```dart
class GameProgress {
  final String gameId;
  final int highScore;
  final int gamesPlayed;
  final DateTime lastPlayed;
  final Map<String, dynamic> customData; // Game-specific data
}
```

---

## 🚀 Implementation Phases

### Week 1 (Mar 8-14): Foundation
- [ ] Set up authentication screen
- [ ] Create color themes (birthday vs normal)
- [ ] Build mode selector with toggle
- [ ] Implement data persistence (shared_preferences)
- [ ] Set up navigation

### Week 2 (Mar 15-21): Games Implementation
- [ ] Polish Quiz game (both modes)
- [ ] Polish Word Puzzle game (both modes)
- [ ] Polish Wavelength game (both modes)
- [ ] Polish Link game (both modes)
- [ ] Add birthday mode personalization

### Week 3 (Mar 22-27): Polish & Store Prep
- [ ] UI/UX refinement
- [ ] Add animations/transitions
- [ ] Test on multiple devices
- [ ] Create app icons
- [ ] Write privacy policy
- [ ] Prepare store assets (screenshots, descriptions)
- [ ] Build release versions

### March 28: Submission
- [ ] Submit to App Store
- [ ] Submit to Play Store

---

## 📱 App Store Requirements Checklist

### Both Platforms
- [ ] Privacy Policy URL (required)
- [ ] App description (compelling, clear)
- [ ] Screenshots (5-8 per platform)
- [ ] App icon (1024x1024 for iOS, various for Android)
- [ ] Feature graphic (Android)
- [ ] No crashes or critical bugs
- [ ] Proper permissions handling

### iOS Specific
- [ ] Sign in with Apple (if using other OAuth providers)
- [ ] Follow Human Interface Guidelines
- [ ] Test on iOS 14+ devices
- [ ] Age rating set correctly

### Android Specific
- [ ] Follow Material Design guidelines
- [ ] Target API 34 (Android 14)
- [ ] Test on Android 8+ devices
- [ ] Content rating questionnaire

---

## 🔮 Future Enhancements (Phase 2)

### Multiplayer Co-Play Feature
**Architecture:**
```
Flutter App <-> Firebase Realtime DB <-> Flutter App
                      ↓
              Game State Sync
```

**Implementation:**
- Room creation with unique codes
- Real-time state synchronization
- Turn-based for some games, simultaneous for others
- Chat feature (optional)

**Timeline:** +2-3 weeks after initial launch

---

## 🛡️ Copyright Mitigation

### Name Changes:
- ~~Wordle~~ → **"5-Letter Challenge"** or **"Word Grid"**
- ~~Connections~~ → **"Link Four"** or **"Category Match"**
- ~~Wavelength~~ → **"Spectrum Game"** (already generic)
- ~~BuzzFeed Quiz~~ → **"Personality Quiz"** (already generic)

### Mechanical Differences:
- Add unique visual style
- Different color schemes
- Add unique features (power-ups, hints, etc.)
- Different grid sizes or rules

---

## 📦 Required Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2  # Local storage
  intl: ^0.19.0               # Date formatting
  google_fonts: ^6.1.0        # Better typography
  
  # Phase 2 (Multiplayer)
  # firebase_core: ^2.24.2
  # firebase_auth: ^4.16.0
  # cloud_firestore: ^4.14.0
  # firebase_database: ^10.4.0
```

---

## 🎯 Success Metrics (Post-Launch)

- User retention (return within 7 days)
- Game completion rates
- Birthday mode engagement
- App store ratings (target: 4.5+)
- Crash-free rate (target: 99.5%+)

---

## ⚠️ Risk Mitigation

1. **Timeline Risk**: Focus on core features, skip multiplayer for V1
2. **Copyright Risk**: Rename games, differentiate mechanics
3. **Review Risk**: Follow all guidelines, test thoroughly
4. **Technical Risk**: Keep architecture simple for V1
5. **Performance Risk**: Test on older devices (iPhone 8, Android 8)

