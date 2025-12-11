import 'package:flutter/material.dart';

/// Cyber-Fluent Typography System
/// Headers: Orbitron (Futuristic)
/// Body: Inter (Clean, via Google Fonts)
/// Code: JetBrains Mono
class AppTypography {
  AppTypography._();
  
  // Heading Styles (Orbitron - Uppercase, Wide spacing)
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.4,
  );
  
  static const TextStyle h4 = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.4,
  );
  
  // Body Text Styles (Inter via Google Fonts)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
  );
  
  // Code Text (JetBrains Mono)
  static const TextStyle code = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.6,
  );
  
  // Button Text
  static const TextStyle button = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );
  
  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.3,
  );
}
