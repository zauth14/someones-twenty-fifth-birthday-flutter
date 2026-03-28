import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'config/user_config.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const BirthdayApp());
}

class BirthdayApp extends StatelessWidget {
  const BirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: UserConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getBirthdayTheme(),
      home: const WelcomeScreen(),
    );
  }
}
