import 'package:shared_preferences/shared_preferences.dart';
import '../config/user_config.dart';

/// Authentication service for local login
/// Phase 1: Simple local authentication with account creation
/// Phase 2: Firebase authentication
class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';
  static const String _keyStoredUsername = 'stored_username';
  static const String _keyStoredPassword = 'stored_password';
  static const String _keyDisplayName = 'display_name';
  static const String _keyAccountExists = 'account_exists';
  
  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
  
  /// Check if an account has been created
  static Future<bool> accountExists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAccountExists) ?? false;
  }
  
  /// Get logged in username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
  
  /// Create a new account (stores credentials locally)
  static Future<LoginResult> register(String username, String password, String displayName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (username.trim().isEmpty) {
      return LoginResult(success: false, message: 'Username cannot be empty');
    }
    if (password.length < 4) {
      return LoginResult(success: false, message: 'Password must be at least 4 characters');
    }
    if (displayName.trim().isEmpty) {
      return LoginResult(success: false, message: 'Display name cannot be empty');
    }
    
    final prefs = await SharedPreferences.getInstance();
    
    // Check if account already exists
    if (prefs.getBool(_keyAccountExists) == true) {
      return LoginResult(success: false, message: 'An account already exists. Please log in.');
    }
    
    // Save credentials
    await prefs.setString(_keyStoredUsername, username.toLowerCase().trim());
    await prefs.setString(_keyStoredPassword, password);
    await prefs.setString(_keyDisplayName, displayName.trim());
    await prefs.setBool(_keyAccountExists, true);
    
    // Auto-login after registration
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, displayName.trim());
    
    return LoginResult(success: true, message: 'Account created! Welcome, ${displayName.trim()}!');
  }
  
  /// Login with username and password
  static Future<LoginResult> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final prefs = await SharedPreferences.getInstance();
    
    // Check against saved account first
    final storedUsername = prefs.getString(_keyStoredUsername);
    final storedPassword = prefs.getString(_keyStoredPassword);
    final displayName = prefs.getString(_keyDisplayName);
    
    if (storedUsername != null && storedPassword != null) {
      if (username.toLowerCase().trim() == storedUsername && 
          password == storedPassword) {
        await prefs.setBool(_keyIsLoggedIn, true);
        await prefs.setString(_keyUsername, displayName ?? username);
        return LoginResult(success: true, message: 'Welcome back, ${displayName ?? username}!');
      }
    }
    
    // Also check against hard-coded values as fallback
    if (username.toLowerCase() == UserConfig.loginUsername && 
        password == UserConfig.loginPassword) {
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUsername, UserConfig.userName);
      return LoginResult(success: true, message: 'Welcome back, ${UserConfig.userName}!');
    }
    
    return LoginResult(success: false, message: 'Invalid username or password');
  }
  
  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUsername);
  }
  
  /// Clear all data (for testing)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

/// Login result model
class LoginResult {
  final bool success;
  final String message;
  
  LoginResult({required this.success, required this.message});
}
