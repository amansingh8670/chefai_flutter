import 'package:flutter/material.dart';

class AppColors {

  // =========================================================
  // BRAND COLORS
  // =========================================================

  static const Color primaryOrange = Color(0xFFF97316);

  static const Color accentTeal = Color(0xFF14B8A6);

  // =========================================================
  // LIGHT THEME
  // =========================================================

  // BACKGROUNDS
  static const Color backgroundLight = Color(0xFFFAFAFA);

  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color cardBgLight = Color(0xFFFFFFFF);

  // TEXT
  static const Color textPrimaryLight = Color(0xFF1F2937);

  static const Color textSecondaryLight = Color(0xFF6B7280);

  static const Color textMutedLight = Color(0xFF9CA3AF);

  // DIVIDERS / BORDERS
  static const Color dividerLight = Color(0xFFE5E7EB);

  // STATUS
  static const Color successLight = Color(0xFF059669);

  static const Color dangerLight = Color(0xFFE53935);

  // =========================================================
  // DARK THEME
  // =========================================================

  // BACKGROUNDS
  static const Color backgroundDark = Color(0xFF0F1419);

  static const Color surfaceDark = Color(0xFF1A1F2E);

  static const Color cardBgDark = Color(0xFF1A1F2E);

  // TEXT
  static const Color textPrimaryDark = Color(0xFFF9FAFB);

  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  static const Color textMutedDark = Color(0xFF6B7280);

  // DIVIDERS / BORDERS
  static const Color dividerDark = Color(0xFF2D3748);

  // STATUS
  static const Color successDark = Color(0xFF10B981);

  static const Color dangerDark = Color(0xFFFF6B6B);

  // =========================================================
  // SEMANTIC HELPERS
  // =========================================================

  // PRIMARY TEXT
  static Color getTextPrimary(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? textPrimaryDark
        : textPrimaryLight;
  }

  // SECONDARY TEXT
  static Color getTextSecondary(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? textSecondaryDark
        : textSecondaryLight;
  }

  // MUTED TEXT
  static Color getTextMuted(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? textMutedDark
        : textMutedLight;
  }

  // BACKGROUND
  static Color getBackground(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? backgroundDark
        : backgroundLight;
  }

  // SURFACE
  static Color getSurface(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? surfaceDark
        : surfaceLight;
  }

  // CARD BG
  static Color getCardBg(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? cardBgDark
        : cardBgLight;
  }

  // DIVIDER
  static Color getDivider(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? dividerDark
        : dividerLight;
  }

  // SUCCESS
  static Color getSuccess(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? successDark
        : successLight;
  }

  // DANGER
  static Color getDanger(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? dangerDark
        : dangerLight;
  }

  // =========================================================
  // SEMANTIC APP COLORS
  // =========================================================

  // SECTION HEADINGS / ANALYTICS / LABELS
  static Color getAccentTeal(ThemeMode mode) {
    return accentTeal;
  }

  // CTA / ACTIVE / BUTTONS
  static Color getPrimaryOrange(ThemeMode mode) {
    return primaryOrange;
  }

 // ORANGE ACCENT (alias for compatibility)
  static Color getAccentOrange(ThemeMode mode) {
    return primaryOrange;
  }
  
  // GRAPH COLORS
  static Color getGraphPrimary(ThemeMode mode) {
    return accentTeal;
  }

  // ACTIVE TAB BG
  static Color getActiveTab(ThemeMode mode) {
    return primaryOrange;
  }

  // INACTIVE TAB TEXT
  static Color getInactiveTabText(ThemeMode mode) {
    return mode == ThemeMode.dark
        ? textSecondaryDark
        : textSecondaryLight;
  }

  // =========================================================
  // SHADOWS
  // =========================================================

  static Color getShadow(ThemeMode mode) {
    return Colors.black.withValues(
      alpha: mode == ThemeMode.dark ? 0.30 : 0.08,
    );
  }
}