import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {

  // =========================================================
  // LIGHT THEME
  // =========================================================

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryOrange,
      secondary: AppColors.accentTeal,
      error: AppColors.dangerLight,
      surface: AppColors.surfaceLight,
    ),

    // =====================================================
    // APP BAR
    // =====================================================

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimaryLight,
    ),

    // =====================================================
    // ICONS
    // =====================================================

    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryLight,
    ),

    // =====================================================
    // CARD THEME
    // =====================================================

    cardTheme: CardThemeData(
      color: AppColors.cardBgLight,
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // =====================================================
    // DIVIDERS
    // =====================================================

    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
    ),

    // =====================================================
    // PAGE TRANSITIONS
    // =====================================================

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android:
            FadeUpwardsPageTransitionsBuilder(),

        TargetPlatform.iOS:
            CupertinoPageTransitionsBuilder(),
      },
    ),

    // =====================================================
    // ELEVATED BUTTONS
    // =====================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,

        foregroundColor: Colors.white,

        elevation: 0,

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // =====================================================
    // TEXT THEME
    // =====================================================

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.bold,
      ),

      bodyLarge: TextStyle(
        color: AppColors.textPrimaryLight,
      ),

      bodyMedium: TextStyle(
        color: AppColors.textSecondaryLight,
      ),
    ),
  );

  // =========================================================
  // DARK THEME
  // =========================================================

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.backgroundDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryOrange,
      secondary: AppColors.accentTeal,
      error: AppColors.dangerDark,
      surface: AppColors.surfaceDark,
    ),

    // =====================================================
    // APP BAR
    // =====================================================

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
    ),

    // =====================================================
    // ICONS
    // =====================================================

    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryDark,
    ),

    // =====================================================
    // CARD THEME
    // =====================================================

    cardTheme: CardThemeData(
      color: AppColors.cardBgDark,
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // =====================================================
    // DIVIDERS
    // =====================================================

    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
    ),

    // =====================================================
    // PAGE TRANSITIONS
    // =====================================================

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android:
            FadeUpwardsPageTransitionsBuilder(),

        TargetPlatform.iOS:
            CupertinoPageTransitionsBuilder(),
      },
    ),

    // =====================================================
    // ELEVATED BUTTONS
    // =====================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,

        foregroundColor: Colors.white,

        elevation: 0,

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // =====================================================
    // TEXT THEME
    // =====================================================

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.bold,
      ),

      bodyLarge: TextStyle(
        color: AppColors.textPrimaryDark,
      ),

      bodyMedium: TextStyle(
        color: AppColors.textSecondaryDark,
      ),
    ),
  );
}