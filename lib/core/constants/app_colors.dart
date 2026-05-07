import 'package:flutter/material.dart';

abstract final class AppColors {
  // Accent
  static const primarySeed    = Color(0xFF6D4EE8); // base violet seed
  static const accentDark     = Color(0xFFA78BFA); // violet for dark theme
  static const accentLight    = Color(0xFF6D4EE8); // deeper violet for light theme

  // Backgrounds — dark theme
  static const scaffoldDark   = Color(0xFF0E0E14);
  static const cardDark       = Color(0xFF1A1A2E);
  static const inputDark      = Color(0xFF111120);
  static const borderDark     = Color(0xFF2A2A40);
  static const dividerDark    = Color(0xFF1E1E2E);

  // Backgrounds — light theme
  static const scaffoldLight  = Color(0xFFF5F5FA);
  static const cardLight      = Color(0xFFFFFFFF);
  static const inputLight     = Color(0xFFEEEEF5);
  static const borderLight    = Color(0xFFDDDDE8);
  static const dividerLight   = Color(0xFFEAEAF2);

  // Text — dark theme
  static const textPrimaryDark = Color(0xFFF0F0F8);
  static const textMutedDark   = Color(0xFF9090A8);
  static const textHintDark    = Color(0xFF6B6B80);

  // Text — light theme
  static const textPrimaryLight = Color(0xFF1A1A2E);
  static const textMutedLight   = Color(0xFF6B6B90);
  static const textHintLight    = Color(0xFF9090B0);

  // Semantic — same across themes
  static const income   = Color(0xFF4ADE80); // dark
  static const incomeLight = Color(0xFF16A34A);
  static const expense  = Color(0xFFF87171); // dark
  static const expenseLight = Color(0xFFDC2626);
  static const error    = Color(0xFFDC2626);
  static const success  = Color(0xFF16A34A);
  static const warning  = Color(0xFFE65100);

  /// Icons / text on saturated category chips and avatars.
  static const onVivid = Color(0xFFFFFFFF);

  /// Donut chart third segment (matches design system blue).
  static const donutSegmentBlue = Color(0xFF60A5FA);

  // Budget bar thresholds (use in BudgetProgressBar widget later)
  // < 60%  → success/income color
  // 60-85% → accent color
  // > 85%  → expense/error color
}
