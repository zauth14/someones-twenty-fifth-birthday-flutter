/// App configuration — birthday honoree + admin access control.
///
/// Birthday mode rules:
///   • Siddhant on March 30  → auto-enabled, expiry timer shown
///   • Admins (any day)      → toggle visible for preview/testing
///   • Everyone else         → normal mode only
class UserConfig {
  // ── Birthday Honoree ──
  static const String birthdayPersonName = 'Siddhant';
  static const String birthdayPersonEmail = 'asmatkaurtaunque@gmail.com'; // UPDATE
  static const String birthdayDate = '2001-03-08';

  // ── Admin emails (can preview birthday mode anytime) ──
  static const List<String> adminEmails = [
    'siddhant@example.com', // UPDATE — birthday person
    'asmatkaurtaunque@gmail.com', // UPDATE — your email
  ];

  // ── Birthday UI text ──
  static const String birthdayGreeting = 'Happy 25th Birthday, Siddhant! 🎉';
  static const String birthdaySubtitle = 'This special day is all about you!';

  // ── App metadata ──
  static const String appName = 'GameHub';
  static const String appVersion = '1.0.0';

  // ── Helpers ──

  static bool isAdmin(String? email) {
    if (email == null) return false;
    return adminEmails.contains(email.toLowerCase().trim());
  }

  static bool isBirthdayPerson(String? email) {
    if (email == null) return false;
    return email.toLowerCase().trim() == birthdayPersonEmail.toLowerCase();
  }

  /// True only on March 30 (any year).
  static bool isBirthdayToday() {
    final now = DateTime.now();
    final bd = DateTime.parse(birthdayDate);
    return now.month == bd.month && now.day == bd.day;
  }

  /// Duration until end-of-day (23:59:59) on birthday. Null if not birthday.
  static Duration? birthdayTimeRemaining() {
    if (!isBirthdayToday()) return null;
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return endOfDay.difference(now);
  }

  /// Duration until the next birthday.
  static Duration timeUntilBirthday() {
    final now = DateTime.now();
    final bd = DateTime.parse(birthdayDate);
    var next = DateTime(now.year, bd.month, bd.day);
    if (!next.isAfter(now)) next = DateTime(now.year + 1, bd.month, bd.day);
    return next.difference(now);
  }

  static int getAge() {
    final now = DateTime.now();
    final bd = DateTime.parse(birthdayDate);
    int age = now.year - bd.year;
    if (now.month < bd.month || (now.month == bd.month && now.day < bd.day)) {
      age--;
    }
    return age;
  }
}
