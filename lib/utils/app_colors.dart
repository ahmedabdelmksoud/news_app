import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Colors.blue;
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF42A5F5);

  // Accent Colors
  static const Color accent = Colors.yellow;
  static const Color accentDark = Color(0xFFFBC02D);

  // Background Colors
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDarkDark = Color(0xFF121212);
  static const Color backgroundDark = Color(0xFF424242);
  static const Color backgroundDarkCard = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textDark = Colors.black;
  static const Color textLight = Colors.white;
  static const Color textGrey600 = Color(0xFF757575);
  static const Color textGrey400 = Color(0xFFBDBDBD);

  // Status Colors
  static const Color errorRed = Colors.red;
  static const Color successGreen = Colors.green;
  static const Color warningOrange = Colors.orange;

  // Border & Divider
  static const Color borderGrey300 = Color(0xFFE0E0E0);
  static const Color borderGrey800 = Color(0xFF424242);

  // Transparent
  static const Color transparent = Colors.transparent;

  // Methods for dynamic colors based on theme
  static Color getBackgroundColor(bool isDark) {
    return isDark ? backgroundDarkDark : backgroundLight;
  }

  static Color getCardColor(bool isDark) {
    return isDark ? backgroundDarkCard : backgroundLight;
  }

  static Color getTextColor(bool isDark) {
    return isDark ? textLight : textDark;
  }

  static Color getSecondaryTextColor(bool isDark) {
    return isDark ? textGrey400 : textGrey600;
  }

  static Color getBorderColor(bool isDark) {
    return isDark ? borderGrey800 : borderGrey300;
  }

  static Color getFillColor(bool isDark) {
    return isDark ? Color(0xFF303030) : Color(0xFFF5F5F5);
  }

  // AppBar
  static const Color appBarBackgroundLight = primary;
  static Color appBarBackgroundDark(bool isDark) {
    return isDark ? primaryDark : primary;
  }

  static const Color appBarTextLight = textLight;

  // Favorite/Heart
  static const Color favoriteRed = Colors.red;
  static const Color favoriteEmpty = Color(0xFFBDBDBD);
}
