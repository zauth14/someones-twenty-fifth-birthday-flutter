import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../config/user_config.dart';
import '../services/auth_service.dart';
import 'birthday_mode.dart';
import 'game_hub.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showBirthdayMode = false;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  bool get _isAdmin => AuthService.isAdmin;
  bool get _isBirthdayPerson => AuthService.isBirthdayPerson;
  bool get _isBirthdayToday => UserConfig.isBirthdayToday();

  /// Can this user see the birthday mode toggle?
  bool get _canToggle => _isAdmin && !(_isBirthdayPerson && _isBirthdayToday);

  @override
  void initState() {
    super.initState();

    // Auto-enable for birthday person on their birthday
    if (_isBirthdayPerson && _isBirthdayToday) {
      _showBirthdayMode = true;
    }

    _startTimer();
  }

  void _startTimer() {
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    if (!mounted) return;
    setState(() {
      if (_isBirthdayToday) {
        _remaining = UserConfig.birthdayTimeRemaining() ?? Duration.zero;
      } else {
        _remaining = UserConfig.timeUntilBirthday();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleMode() {
    if (!_canToggle) return;
    setState(() => _showBirthdayMode = !_showBirthdayMode);
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await AuthService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final isBDay = _showBirthdayMode;

    return Scaffold(
      backgroundColor: isBDay
          ? AppTheme.birthdayBackground
          : AppTheme.normalBackground,
      body: Column(
        children: [
          // ── Top bar ──
          Container(
            color: isBDay ? Colors.transparent : AppTheme.normalBackground,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Logout
                    _Pill(
                      dark: isBDay,
                      child: IconButton(
                        icon: Icon(
                          Icons.logout,
                          size: 20,
                          color: isBDay ? Colors.white70 : Colors.black54,
                        ),
                        onPressed: _handleLogout,
                        tooltip: 'Logout',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ),

                    const Spacer(),



                    // Mode toggle (admins only, not birthday person on their day)
                    if (_canToggle)
                      _Pill(
                        dark: isBDay,
                        child: GestureDetector(
                          onTap: _toggleMode,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isBDay ? '🎂' : '🎮',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 40,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    gradient: isBDay
                                        ? const LinearGradient(
                                            colors: [
                                              AppTheme.birthdayPurplePrimary,
                                              AppTheme.birthdayOrangePrimary,
                                            ],
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              AppTheme.normalBluePrimary,
                                              AppTheme.normalGreenPrimary,
                                            ],
                                          ),
                                  ),
                                  child: AnimatedAlign(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    alignment: isBDay
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ── Countdown banner (non-admin, non-birthday, within 7 days) ──
          if (!_isAdmin &&
              !_isBirthdayPerson &&
              !_isBirthdayToday &&
              _remaining.inDays <= 7 &&
              _remaining.inDays > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.birthdayPurplePrimary.withOpacity(0.9),
                    AppTheme.birthdayOrangePrimary.withOpacity(0.9),
                  ],
                ),
              ),
              child: Text(
                '🎂 ${UserConfig.birthdayPersonName}\'s birthday in ${_remaining.inDays} days!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // ── Content ──
          Expanded(
            child: isBDay ? const BirthdayModeScreen() : const GameHubScreen(),
          ),
        ],
      ),
    );
  }
}

/// Reusable pill-shaped container for top bar items.
class _Pill extends StatelessWidget {
  final bool dark;
  final Widget child;
  const _Pill({required this.dark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? Colors.white.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: dark ? Colors.white.withOpacity(0.25) : Colors.grey.shade200,
        ),
        boxShadow: dark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: child,
    );
  }
}
