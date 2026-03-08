# 📐 Wireframes & UI Specifications

## Color Palette

### Birthday Mode
```
Primary Purple:   #8B5CF6 ████ (Violet)
Light Purple:     #A78BFA ████ (Lavender)
Dark Purple:      #7C3AED ████ (Deep Violet)

Primary Orange:   #F97316 ████ (Orange)
Light Orange:     #FB923C ████ (Peach)
Dark Orange:      #EA580C ████ (Deep Orange)

Background:       #1F1B29 ████ (Dark Purple-Gray)
Card BG:          #2D2438 ████ (Slightly lighter)
Text:             #FFFFFF ████ (White)
Accent Text:      #FCD34D ████ (Warm Yellow)
```

### Normal Mode
```
Primary Blue:     #3B82F6 ████
Primary Green:    #10B981 ████
Background:       #F3F4F6 ████ (Light Gray)
Card BG:          #FFFFFF ████
Text:             #111827 ████ (Almost Black)
Accent:           #6366F1 ████ (Indigo)
```

---

## Screen Wireframes

### 1. Login Screen
```
┌─────────────────────────────┐
│                             │
│         🎮 GameHub          │
│                             │
│    ┌───────────────────┐   │
│    │   [App Icon/Logo] │   │
│    └───────────────────┘   │
│                             │
│    Welcome Back!            │
│                             │
│    ┌─────────────────────┐ │
│    │ 👤 Username         │ │
│    └─────────────────────┘ │
│                             │
│    ┌─────────────────────┐ │
│    │ 🔒 Password         │ │
│    └─────────────────────┘ │
│                             │
│         [Login Button]      │
│                             │
│    For [Friend's Name] ✨   │
│                             │
└─────────────────────────────┘

Design Notes:
- Gradient background (purple-orange for birthday vibes)
- Smooth fade-in animation
- Minimal, clean design
- Hard-coded credentials (Phase 1)
```

---

### 2. Mode Selector / Home Screen
```
┌─────────────────────────────────────┐
│  👤 [User]          [Mode Toggle] ⚙️│
├─────────────────────────────────────┤
│                                     │
│    🎉 IT'S YOUR BIRTHDAY! 🎉        │  ← If birthday
│         (Animated Banner)           │
│                                     │
│  ┌───────────────────────────────┐ │
│  │                               │ │
│  │   🎂 BIRTHDAY MODE 🎂         │ │
│  │                               │ │
│  │   Special games just for you! │ │
│  │                               │ │
│  │   [Tap to Enter →]            │ │
│  │                               │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │                               │ │
│  │   🎮 NORMAL MODE 🎮           │ │
│  │                               │ │
│  │   Play classic games          │ │
│  │                               │ │
│  │   [Tap to Enter →]            │ │
│  │                               │ │
│  └───────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘

Design Notes:
- Two large, tappable cards
- Birthday Mode: Purple→Orange gradient
- Normal Mode: Blue→Green gradient
- Confetti animation on birthday
- Toggle in top right switches permanently
```

---

### 3. Birthday Mode - Game Hub
```
┌─────────────────────────────────────┐
│  ← Back              Birthday Mode  │
├─────────────────────────────────────┤
│                                     │
│  Happy 25th Birthday, [Name]! 🎉    │
│                                     │
│  ┌─────────────┐  ┌─────────────┐  │
│  │             │  │             │  │
│  │   💭 Quiz   │  │  🔤 Word    │  │
│  │             │  │   Puzzle    │  │
│  │  Personal   │  │             │  │
│  │  Questions  │  │  5 Letters  │  │
│  │             │  │             │  │
│  └─────────────┘  └─────────────┘  │
│                                     │
│  ┌─────────────┐  ┌─────────────┐  │
│  │             │  │             │  │
│  │ 〰️ Spectrum │  │  🔗 Links   │  │
│  │             │  │             │  │
│  │   Guess     │  │  Find the   │  │
│  │  The Vibe   │  │  Groups     │  │
│  │             │  │             │  │
│  └─────────────┘  └─────────────┘  │
│                                     │
│  [All personalized just for you! ✨]│
│                                     │
└─────────────────────────────────────┘

Color Scheme:
- Background: Dark purple gradient
- Cards: Purple/Orange alternating
- Text: White/Yellow
- Icons: Animated, glowing effect
```

---

### 4. Normal Mode - Game Hub
```
┌─────────────────────────────────────┐
│  ← Back               Normal Mode   │
├─────────────────────────────────────┤
│                                     │
│        Choose Your Game 🎮          │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  💭 Personality Quiz         │  │
│  │  Discover something new!     │  │
│  │                        [Play]│  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  🔤 5-Letter Challenge       │  │
│  │  Guess the word in 6 tries   │  │
│  │                        [Play]│  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  〰️ Spectrum Game            │  │
│  │  Find the sweet spot         │  │
│  │                        [Play]│  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  🔗 Category Match           │  │
│  │  Group items by theme        │  │
│  │                        [Play]│  │
│  └──────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘

Color Scheme:
- Background: Light gray/white
- Cards: White with colored accents
- Shadows: Subtle, material design
```

---

### 5. Quiz Game Screen (Birthday Mode)
```
┌─────────────────────────────────────┐
│  ← Back          Question 3/10    ❤️│
├─────────────────────────────────────┤
│                                     │
│  🎂 Personalized Birthday Quiz 🎂   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │  Remember when we went to   │   │
│  │  that concert together?     │   │
│  │  What was your favorite     │   │
│  │  song that night?           │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  A) Song Title 1              │  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  B) Song Title 2              │  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  C) Song Title 3              │  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  D) Song Title 4              │  │
│  └──────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘

Birthday Mode Styling:
- Purple/Orange gradient background
- Glowing borders on cards
- Animated emojis
- Personal photos (optional)
```

---

### 6. Word Puzzle Screen (Birthday Mode)
```
┌─────────────────────────────────────┐
│  ← Back      5-Letter Puzzle      ❓│
├─────────────────────────────────────┤
│                                     │
│         Guess the word!             │
│    (Hint: Special to your birthday) │
│                                     │
│       ┌───┬───┬───┬───┬───┐        │
│   1   │ H │ E │ A │ R │ T │  ← Submitted │
│       └───┴───┴───┴───┴───┘        │
│        🟧 🟪 ⬜ ⬜ 🟧               │
│                                     │
│       ┌───┬───┬───┬───┬───┐        │
│   2   │ P │ A │ R │ T │ Y │  ← Submitted │
│       └───┴───┴───┴───┴───┘        │
│        ⬜ 🟧 ⬜ 🟪 🟧               │
│                                     │
│       ┌───┬───┬───┬───┬───┐        │
│   3   │ _ │ _ │ _ │ _ │ _ │  ← Current │
│       └───┴───┴───┴───┴───┘        │
│                                     │
│       ┌───┬───┬───┬───┬───┐        │
│   4   │   │   │   │   │   │        │
│       └───┴───┴───┴───┴───┘        │
│                                     │
│       ┌───┬───┬───┬───┬───┐        │
│   5   │   │   │   │   │   │        │
│       └───┴───┴───┴───┴───┘        │
│                                     │
│       ┌───┬───┬───┬───┬───┐        │
│   6   │   │   │   │   │   │        │
│       └───┴───┴───┴───┴───┘        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Q W E R T Y U I O P        │   │
│  │   A S D F G H J K L         │   │
│  │    Z X C V B N M ← ✓        │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘

Color Legend (Birthday Mode):
- 🟧 Orange: Correct letter, correct position
- 🟪 Purple: Correct letter, wrong position
- ⬜ Gray: Letter not in word
```

---

### 7. Wavelength Screen (Birthday Mode)
```
┌─────────────────────────────────────┐
│  ← Back          Spectrum Game    🎯│
├─────────────────────────────────────┤
│                                     │
│      Round 3/5  •  Score: 45        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │  [Name]'s favorite season?  │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│       Hates ◄──────────► Loves      │
│                                     │
│   ┌─────────────────────────────┐  │
│   │╭╌╌╌╌╌╌╌╌╌╌╌┊╌╌╌╌╌╌╌╌╌╌╌╌╮│  │
│   │┊           ┊    👆       ┊│  │
│   │╰╌╌╌╌╌╌╌╌╌╌╌┊╌╌╌╌╌╌╌╌╌╌╌╌╯│  │
│   └─────────────┴───────────────┘  │
│        Winter  │   Summer           │
│                ▼                    │
│           (Drag to guess)           │
│                                     │
│        [Submit Guess]               │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Hint: Think about beach     │   │
│  │  days and sunshine! ☀️       │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘

Birthday Mode Features:
- Purple-to-Orange gradient spectrum bar
- Personalized prompts about birthday person
- Glowing cursor/marker
- Sparkle effects on submit
```

---

### 8. Links/Category Game (Birthday Mode)
```
┌─────────────────────────────────────┐
│  ← Back        Category Match     🔗│
├─────────────────────────────────────┤
│                                     │
│   Find 4 groups of 4 related items  │
│          Mistakes: ⭐⭐⭐⭐          │
│                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │  PIZZA │ │ BURGERS│ │  TACOS │  │  ← Tap
│  └────────┘ └────────┘ └────────┘  │  to select
│                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │ SUSHI  │ │  PARIS │ │ LONDON │  │
│  └────────┘ └────────┘ └────────┘  │
│                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │  ROME  │ │  TOKYO │ │ HIKING │  │
│  └────────┘ └────────┘ └────────┘  │
│                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │SWIMMING│ │ RUNNING│ │ YOGA   │  │
│  └────────┘ └────────┘ └────────┘  │
│                                     │
│  ┌────────┐                         │
│  │BIKING  │                         │
│  └────────┘                         │
│                                     │
│         [Submit Group]              │
│         [Shuffle] [Deselect]        │
│                                     │
│  Categories found:                  │
│  🟧 [Name]'s Favorite Foods         │
│                                     │
└─────────────────────────────────────┘

Birthday Mode:
- Categories about birthday person's life
- Purple/Orange color coding
- Personalized items
- Celebration animation when group found
```

---

### 9. Results/Completion Screen
```
┌─────────────────────────────────────┐
│                                     │
│         🎉 Amazing! 🎉              │
│                                     │
│    You scored: 85/100               │
│                                     │
│  ┌─────────────────────────────┐   │
│  │         ⭐⭐⭐⭐⭐           │   │
│  │                             │   │
│  │    You're a true friend!    │   │
│  │                             │   │
│  │  "You know [Name] better    │   │
│  │   than anyone else!"        │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  [Play Again]                │  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  [Back to Games]             │  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  [Share Screenshot] 📸       │  │
│  └──────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘

Birthday Mode:
- Confetti animation
- Purple/Orange theme
- Personalized messages
- Fireworks on high score
```

---

## Navigation Flow

```
Login Screen
    ↓
Mode Selector
    ├── Birthday Mode Hub
    │       ├── Personalized Quiz → Results
    │       ├── Birthday Word Puzzle → Results
    │       ├── Personal Wavelength → Results
    │       └── Personal Links → Results
    │
    └── Normal Mode Hub
            ├── Quiz → Results
            ├── Word Puzzle → Results
            ├── Wavelength → Results
            └── Links → Results
```

---

## Animation Specifications

### Page Transitions
- **Duration**: 520ms
- **Curve**: easeOutCubic
- **Type**: Fade + Slide (6% horizontal offset)

### Birthday Mode Special Animations
- **Confetti**: On mode entry, game completion
- **Sparkles**: Random floating particles
- **Glow**: Pulsing borders on cards
- **Emojis**: Subtle bounce/rotate

### Button Interactions
- **Tap**: Scale down to 0.95, bounce back
- **Hover** (web): Lift with shadow
- **Disabled**: Fade to 50% opacity

### Game-Specific Animations
- **Word Puzzle**: Flip animation for tiles
- **Wavelength**: Smooth slider drag
- **Links**: Shake on wrong answer, celebrate on correct
- **Quiz**: Fade between questions

---

## Responsive Design

### Phone (Portrait)
- Single column layout
- Full-width cards
- Bottom navigation
- Larger touch targets (min 48x48)

### Tablet (Landscape)
- Two-column layout for game hubs
- Side-by-side cards
- More whitespace

### Web (Desktop)
- Center content, max width 1200px
- Hover states enabled
- Keyboard navigation support

---

## Accessibility

- **Contrast Ratios**: WCAG AA compliant
  - Birthday Mode: White text on purple (4.5:1+)
  - Normal Mode: Dark text on white (7:1+)
- **Font Sizes**: Min 14px, scale up to 20px for headings
- **Touch Targets**: Min 48x48 logical pixels
- **Screen Readers**: Semantic labels on all interactive elements
- **Color Blind**: Don't rely solely on color (use icons + text)

---

## Platform-Specific Adjustments

### iOS
- Use San Francisco font (default)
- Cupertino-style back button (< Back)
- Modal bottom sheets for actions
- Haptic feedback on interactions

### Android
- Use Roboto font (default)
- Material Design components
- FAB for primary actions (optional)
- Ripple effects on taps

### Web
- Use Google Fonts (Poppins/Inter)
- Mouse hover states
- Keyboard focus indicators
- Responsive breakpoints

