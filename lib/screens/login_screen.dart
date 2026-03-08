import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../config/user_config.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isCreateAccount = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ── Handlers ──

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      setState(() => _errorMessage = result.message);
    }
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.register(
      _emailController.text,
      _passwordController.text,
      _displayNameController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      setState(() => _errorMessage = result.message);
    }
  }

  void _toggleMode() {
    setState(() {
      _isCreateAccount = !_isCreateAccount;
      _errorMessage = null;
      _formKey.currentState?.reset();
    });
  }

  // ── Shared field decoration ──

  InputDecoration _fieldDecor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.birthdayGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Logo
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.celebration,
                            size: 60,
                            color: AppTheme.birthdayOrangePrimary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        Text(
                          UserConfig.appName,
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isCreateAccount ? 'Create Account' : 'Welcome Back!',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Form card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Display name (create only)
                              if (_isCreateAccount) ...[
                                TextFormField(
                                  controller: _displayNameController,
                                  style: const TextStyle(color: Colors.white),
                                  textCapitalization: TextCapitalization.words,
                                  decoration: _fieldDecor(
                                    'Display Name',
                                    Icons.badge,
                                  ),
                                  validator: (v) {
                                    if (_isCreateAccount &&
                                        (v == null || v.trim().isEmpty)) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Email
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                decoration: _fieldDecor('Email', Icons.email),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!v.contains('@') || !v.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Password
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecor('Password', Icons.lock)
                                    .copyWith(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                      ),
                                    ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (_isCreateAccount && v.length < 6) {
                                    return 'At least 6 characters';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => _isCreateAccount
                                    ? _handleCreateAccount()
                                    : _handleLogin(),
                              ),

                              // Error
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.error.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppTheme.error.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

                              // Submit button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : (_isCreateAccount
                                            ? _handleCreateAccount
                                            : _handleLogin),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppTheme.birthdayOrangePrimary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          _isCreateAccount
                                              ? 'Create Account'
                                              : 'Login',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Toggle
                        GestureDetector(
                          onTap: _toggleMode,
                          child: Text.rich(
                            TextSpan(
                              text: _isCreateAccount
                                  ? 'Already have an account? '
                                  : "Don't have an account? ",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: _isCreateAccount
                                      ? 'Login'
                                      : 'Create one',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Text(
                          'Made with ❤️ for ${UserConfig.birthdayPersonName}',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
