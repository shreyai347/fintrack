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
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.scaffoldLight,
        foregroundColor: AppColors.textPrimaryLight,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),
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
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: scheme.onInverseSurface,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.25,
          letterSpacing: 0.15,
        ),
        actionTextColor: scheme.inversePrimary,
        dismissDirection: DismissDirection.down,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
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
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.scaffoldDark,
        foregroundColor: AppColors.textPrimaryDark,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
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
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: scheme.onInverseSurface,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.25,
          letterSpacing: 0.15,
        ),
        actionTextColor: scheme.inversePrimary,
        dismissDirection: DismissDirection.down,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
      ),
    );
  }
}
