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

  @override
  void initState() {
    super.initState();
    _showBirthdayMode = UserConfig.isBirthdayToday();
  }

  void _toggleMode() {
    setState(() {
      _showBirthdayMode = !_showBirthdayMode;
    });
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await AuthService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showBirthdayMode
          ? AppTheme.birthdayBackground
          : AppTheme.normalBackground,
      body: Column(
        children: [
          // Top bar
          Container(
            color: _showBirthdayMode
                ? Colors.transparent
                : AppTheme.normalBackground,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logout Button
                    _buildPillButton(
                      child: IconButton(
                        icon: Icon(
                          Icons.logout,
                          size: 20,
                          color: _showBirthdayMode
                              ? Colors.white70
                              : Colors.black54,
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

                    // Mode Toggle
                    _buildPillButton(
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
                                _showBirthdayMode ? '🎂 Birthday' : '🎮 Normal',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _showBirthdayMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 22,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  gradient: _showBirthdayMode
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
                                  alignment: _showBirthdayMode
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

          // Main Content
          Expanded(
            child: _showBirthdayMode
                ? const BirthdayModeScreen()
                : const GameHubScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildPillButton({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: _showBirthdayMode
            ? Colors.white.withOpacity(0.15)
            : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _showBirthdayMode
              ? Colors.white.withOpacity(0.25)
              : Colors.grey.shade200,
        ),
        boxShadow: _showBirthdayMode
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
