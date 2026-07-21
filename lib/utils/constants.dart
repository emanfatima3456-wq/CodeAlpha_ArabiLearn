import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF00C9A7);
  static const Color background = Color(0xFF1A1A2E);
  static const Color cardDark = Color(0xFF16213E);
  static const Color cardLight = Color(0xFF0F3460);
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color white38 = Colors.white38;
  static const Color gold = Color(0xFFFFD700);
  static const Color error = Colors.redAccent;
  static const Color success = Color(0xFF00C9A7);
}

class AppStrings {
  static const String appName = 'ArabiLearn';
  static const String tagline = 'Learn Arabic the Smart Way';
  static const String cohereApiKey = 'YOUR_COHERE_API_KEY_HERE';
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subHeading = TextStyle(
    color: Colors.white70,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  static const TextStyle arabic = TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.8,
  );
}