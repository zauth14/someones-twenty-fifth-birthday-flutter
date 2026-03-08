/// Hard-coded user configuration
/// TODO: Replace with your friend's actual information
class UserConfig {
  // User Information
  static const String userName = "Siddhant"; // Change to your friend's name
  static const String userBirthday = "2001-03-30"; // YYYY-MM-DD format
  
  // Login Credentials (simple auth for Phase 1)
  static const String loginUsername = "siddhant"; // Lowercase username
  static const String loginPassword = "birthday25"; // Simple password
  
  // Birthday Mode Personalization
  static const String birthdayGreeting = "Happy 25th Birthday, Siddhant! 🎉";
  static const String birthdaySubtitle = "This special day is all about you!";
  
  // App Configuration
  static const String appName = "GameHub";
  static const String appVersion = "1.0.0";
  
  /// Check if today is the user's birthday
  static bool isBirthdayToday() {
    final now = DateTime.now();
    final birthday = DateTime.parse(userBirthday);
    
    return now.month == birthday.month && now.day == birthday.day;
  }
  
  /// Get age based on birthday
  static int getAge() {
    final now = DateTime.now();
    final birthday = DateTime.parse(userBirthday);
    
    int age = now.year - birthday.year;
    if (now.month < birthday.month || 
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    
    return age;
  }
}
