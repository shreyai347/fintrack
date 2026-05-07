import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

abstract final class AppTheme {
  static ThemeData lightTheme(ColorScheme? dynamicScheme) {
    final scheme = dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: AppColors.primarySeed,
          brightness: Brightness.light,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: AppColors.cardLight,
        onSurface: AppColors.textPrimaryLight,
        primary: AppColors.accentLight,
        onPrimary: Colors.white,
        secondary: AppColors.accentLight,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldLight,
      cardColor: AppColors.cardLight,
      dividerColor: AppColors.dividerLight,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.borderLight, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.borderLight, width: 0.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.borderLight, width: 0.5),
        ),
      ),
    );
  }

  static ThemeData darkTheme(ColorScheme? dynamicScheme) {
    final scheme = dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: AppColors.primarySeed,
          brightness: Brightness.dark,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: AppColors.cardDark,
        onSurface: AppColors.textPrimaryDark,
        primary: AppColors.accentDark,
        onPrimary: Colors.white,
        secondary: AppColors.accentDark,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldDark,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.dividerDark,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.borderDark, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.borderDark, width: 0.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.borderDark, width: 0.5),
        ),
      ),
    );
  }
}
