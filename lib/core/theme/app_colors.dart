import 'package:flutter/material.dart';

/// Cyber-Fluent Design System Color Tokens
/// Strictly adhere to these colors - DO NOT hardcode colors in components
class AppColors {
  AppColors._();
  
  // Backgrounds
  static const Color backgroundPrimary = Color(0xFF121212); // Deep Charcoal
  static const Color backgroundSecondary = Color(0xFF0B0C15); // Midnight Blue
  
  // Accents
  static const Color accentPrimary = Color(0xFF00F0FF); // Electric Blue
  static const Color accentSecondary = Color(0xFFBD00FF); // Neon Purple
  static const Color textHighlight = Color(0xFFFFD700); // Cyber Yellow
  
  // Glass Effect
  static const Color glassOverlay = Color(0x0DFFFFFF); // RGBA(255, 255, 255, 0.05)
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% opacity
  static const Color textTertiary = Color(0x80FFFFFF); // 50% opacity
  
  // Semantic Colors
  static const Color success = Color(0xFF00FF88);
  static const Color error = Color(0xFFFF0055);
  static const Color warning = Color(0xFFFFD700);
  static const Color info = Color(0xFF00F0FF);
}
