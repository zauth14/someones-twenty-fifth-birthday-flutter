# 🚀 Launch Checklist - March 28 Target

## Pre-Development

- [x] Architecture planned
- [x] Wireframes created
- [x] Color schemes defined
- [ ] App name finalized
- [ ] Hard-coded user data configured
- [ ] Privacy policy written and hosted

---

## Week 1: Foundation (Mar 8-14)

### Day 1-2: Setup & Authentication
- [ ] Add required dependencies (shared_preferences, google_fonts, intl)
- [ ] Create theme constants (birthday + normal mode)
- [ ] Build login screen
- [ ] Implement local authentication
- [ ] Add login state persistence

### Day 3-4: Navigation & Mode Selector
- [ ] Build mode selector screen with toggle
- [ ] Implement birthday detection logic
- [ ] Create smooth page transitions
- [ ] Add mode toggle (birthday ↔ normal)
- [ ] Build game hub screens (both modes)

### Day 5-7: Birthday Mode Styling
- [ ] Create purple/orange gradient backgrounds
- [ ] Add confetti animation for birthday mode
- [ ] Implement sparkle particle effects
- [ ] Style all birthday mode cards
- [ ] Add custom fonts

---

## Week 2: Games Implementation (Mar 15-21)

### Day 8-9: Quiz Game
- [ ] Create question data models
- [ ] Build quiz UI (normal mode)
- [ ] Implement quiz logic (scoring, progression)
- [ ] Add personalized questions (birthday mode)
- [ ] Create results screen with animations
- [ ] Add quiz data for both modes

### Day 10-11: Word Puzzle
- [ ] Build 5x6 grid UI
- [ ] Implement keyboard
- [ ] Add word validation logic
- [ ] Create color feedback system (orange/purple for birthday)
- [ ] Add word list (general + birthday-specific)
- [ ] Implement game state management
- [ ] Add winning/losing animations

### Day 12-13: Wavelength Game
- [ ] Create spectrum slider UI
- [ ] Build prompt card
- [ ] Implement drag-to-guess interaction
- [ ] Add scoring logic (proximity-based)
- [ ] Create personalized prompts (birthday mode)
- [ ] Add visual feedback (glow, sparkles)

### Day 14: Links/Category Game
- [ ] Build 4x4 grid layout
- [ ] Implement item selection
- [ ] Add group validation logic
- [ ] Create shake animation for errors
- [ ] Add celebration for correct groups
- [ ] Design personalized categories (birthday mode)
- [ ] Add difficulty progression

---

## Week 3: Polish & Store Prep (Mar 22-27)

### Day 15-16: UI/UX Polish
- [ ] Add loading states
- [ ] Implement error handling
- [ ] Add haptic feedback (iOS)
- [ ] Polish all animations
- [ ] Add sound effects (optional)
- [ ] Optimize performance
- [ ] Test on multiple screen sizes

### Day 17-18: Store Assets
- [ ] Design app icon (1024x1024)
- [ ] Create iOS screenshots (6.5", 5.5")
- [ ] Create Android screenshots (Phone, 7" Tablet, 10" Tablet)
- [ ] Write app description (compelling, keyword-rich)
- [ ] Create feature graphic (Android)
- [ ] Write release notes
- [ ] Prepare promotional text

### Day 19-20: Testing & Fixes
- [ ] Test on iOS 14, 15, 16, 17
- [ ] Test on Android 8, 9, 10, 11, 12, 13, 14
- [ ] Fix all critical bugs
- [ ] Test login/logout flow
- [ ] Test birthday mode switching
- [ ] Verify all games work correctly
- [ ] Check memory leaks
- [ ] Test offline functionality

### Day 21: Privacy Policy & Compliance
- [ ] Write privacy policy (use template)
- [ ] Host privacy policy (GitHub Pages or website)
- [ ] Add privacy policy link to app
- [ ] Configure app permissions correctly
- [ ] Add "Sign in with Apple" (iOS) or remove other OAuth
- [ ] Set age rating correctly
- [ ] Review content guidelines

### Day 22: Build & Submit
- [ ] Build iOS release (.ipa)
- [ ] Build Android release (.aab)
- [ ] Test release builds
- [ ] Submit to App Store Connect
- [ ] Submit to Google Play Console
- [ ] Fill out all metadata
- [ ] Upload screenshots
- [ ] Set pricing (Free)
- [ ] Submit for review

---

## App Store Connect Checklist (iOS)

### App Information
- [ ] App name (max 30 characters)
- [ ] Subtitle (optional, max 30 characters)
- [ ] Category (Games > Puzzle or Entertainment)
- [ ] Age rating (complete questionnaire)
- [ ] Privacy policy URL

### Version Information
- [ ] Screenshots (6.5" required, 5.5" required)
- [ ] Promotional text (170 characters)
- [ ] Description (4000 characters max)
- [ ] Keywords (100 characters, comma-separated)
- [ ] Support URL
- [ ] Marketing URL (optional)

### Build
- [ ] Upload .ipa via Xcode or Transporter
- [ ] Wait for processing
- [ ] Select build for this version

### Pricing & Availability
- [ ] Free app
- [ ] All territories

### App Review Information
- [ ] Contact information
- [ ] Demo account credentials (username/password for review)
- [ ] Notes for reviewer (explain birthday mode, hard-coded login)

---

## Google Play Console Checklist (Android)

### Store Listing
- [ ] App name (max 50 characters)
- [ ] Short description (80 characters)
- [ ] Full description (4000 characters)
- [ ] App icon (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshots (min 2, max 8 per device type)
- [ ] Category (Games > Puzzle or Entertainment)
- [ ] Content rating (complete questionnaire)

### App Content
- [ ] Privacy policy URL
- [ ] Ads declaration (Do you have ads? No)
- [ ] Target audience (Ages 13+)
- [ ] Store presence (All countries)

### App Releases
- [ ] Upload .aab (Android App Bundle)
- [ ] Release name (v1.0.0)
- [ ] Release notes (What's new)
- [ ] Production track

### Pricing & Distribution
- [ ] Free app
- [ ] All countries
- [ ] Contains ads: No
- [ ] In-app purchases: No
- [ ] Content guidelines confirmed

---

## Privacy Policy Template

```markdown
# Privacy Policy for [App Name]

Last updated: [Date]

## Information Collection and Use
This app does not collect, store, or transmit any personal information. 
All game progress is stored locally on your device only.

## Login Information
The app uses a simple local authentication system. No credentials are 
sent to external servers.

## Children's Privacy
This app does not knowingly collect information from children.

## Changes to Privacy Policy
We may update this policy from time to time. Changes will be posted here.

## Contact Us
If you have questions, contact us at: [your-email@example.com]
```

Host this on:
- GitHub Pages (free, easy)
- Your own website
- Paste.ee or similar (quick option)

---

## Demo Account for Reviewers

**Username:** `demo` or `reviewer`  
**Password:** `review2025` or something simple

**Notes for Reviewer:**
```
This app features:
1. Simple login (hard-coded for one user)
2. Birthday Mode - Personalized games (purple/orange theme)
3. Normal Mode - Standard game variants

To test:
- Login with provided credentials
- Toggle between modes using top-right button
- Try all 4 games in each mode
- Birthday Mode shows personalized content
```

---

## Launch Day Checklist (March 28)

- [ ] Final build uploaded
- [ ] All metadata reviewed
- [ ] Screenshots look good
- [ ] Privacy policy live and linked
- [ ] Demo account credentials provided
- [ ] Review notes clear and helpful
- [ ] Pricing set to Free
- [ ] Submitted to both stores
- [ ] Confirmation emails received

---

## Post-Submission

### Expected Timeline
- **Google Play**: 1-3 days (often within hours)
- **Apple App Store**: 1-3 days (usually 24-48 hours)

### If Rejected
- Read rejection reason carefully
- Fix issues promptly
- Resubmit within 24 hours
- Respond to reviewer questions quickly

### After Approval
- [ ] Announce on social media
- [ ] Share with friends/family
- [ ] Monitor crash reports
- [ ] Respond to reviews
- [ ] Plan V1.1 updates (multiplayer!)

---

## Phase 2 (Post-Launch) - Multiplayer

### Future Enhancements
- [ ] Firebase setup
- [ ] Room creation/joining
- [ ] Real-time state sync
- [ ] Turn-based game logic
- [ ] Friend system
- [ ] Leaderboards
- [ ] Push notifications
- [ ] Multiple user support

**Estimated Timeline:** 3-4 weeks after launch

---

## Emergency Contacts

- **Apple Developer Support**: developer.apple.com/contact
- **Google Play Support**: support.google.com/googleplay/android-developer
- **Flutter Issues**: github.com/flutter/flutter/issues

---

## Success Criteria

✅ **Must Have (V1.0):**
- Login works
- Both modes accessible
- All 4 games playable
- No crashes
- Passes both store reviews

🎯 **Nice to Have (V1.0):**
- Smooth animations
- Sound effects
- Haptic feedback
- Polished UI

🚀 **Phase 2:**
- Multiplayer co-play
- Multiple users
- Cloud sync
- Social features

