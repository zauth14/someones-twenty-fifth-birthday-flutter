import 'package:firebase_auth/firebase_auth.dart';
import '../config/user_config.dart';

/// Firebase-backed authentication service.
///
/// Handles sign-up, login, logout, and role queries (admin / birthday person).
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Current user shortcuts ──
  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  static bool get isLoggedIn => currentUser != null;
  static String? get email => currentUser?.email;
  static String? get displayName => currentUser?.displayName;

  // ── Role checks (based on email in UserConfig) ──
  static bool get isAdmin => UserConfig.isAdmin(email);
  static bool get isBirthdayPerson => UserConfig.isBirthdayPerson(email);

  /// Whether this user should see birthday mode right now.
  static bool get shouldShowBirthdayMode =>
      (isBirthdayPerson && UserConfig.isBirthdayToday()) || isAdmin;

  /// Whether birthday mode should auto-enable (no toggle — it's on).
  static bool get autoBirthdayMode =>
      isBirthdayPerson && UserConfig.isBirthdayToday();

  // ── Auth operations ──

  static Future<AuthResult> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await cred.user?.updateDisplayName(displayName.trim());
      await cred.user?.reload(); // ensure displayName sticks
      return AuthResult(success: true, message: 'Welcome, $displayName!');
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: _friendlyError(e.code));
    } catch (e) {
      return AuthResult(success: false, message: 'Something went wrong.');
    }
  }

  static Future<AuthResult> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final name = _auth.currentUser?.displayName ?? 'there';
      return AuthResult(success: true, message: 'Welcome back, $name!');
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: _friendlyError(e.code));
    } catch (e) {
      return AuthResult(success: false, message: 'Something went wrong.');
    }
  }

  static Future<void> logout() => _auth.signOut();

  // ── Error mapping ──

  static String _friendlyError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'That email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Something went wrong. ($code)';
    }
  }
}

/// Simple result wrapper.
class AuthResult {
  final bool success;
  final String message;
  AuthResult({required this.success, required this.message});
}
