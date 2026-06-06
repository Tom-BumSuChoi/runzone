import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static const themeMode = ThemeMode.system;

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTypography.sansKorean,
    scaffoldBackgroundColor: AppColors.pageBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.accentInk,
      secondary: AppColors.secondaryAccent,
      onSecondary: AppColors.accentInk,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      error: AppColors.zone5,
      onError: AppColors.white,
    ),
    textTheme: _textTheme(
      text: AppColors.text,
      dimText: AppColors.dimText,
      mutedText: AppColors.mutedText,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.line),
    filledButtonTheme: FilledButtonThemeData(
      style: _filledButtonStyle(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.accentInk,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      modalBackgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.bottomSheetBorder),
    ),
  );

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.sansKorean,
    scaffoldBackgroundColor: AppColors.lightPageBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightAccent,
      onPrimary: AppColors.lightAccentInk,
      secondary: AppColors.lightSecondaryAccent,
      onSecondary: AppColors.lightAccentInk,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
      error: AppColors.zone5,
      onError: AppColors.white,
    ),
    textTheme: _textTheme(
      text: AppColors.lightText,
      dimText: AppColors.lightDimText,
      mutedText: AppColors.lightMutedText,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.lightLine),
    filledButtonTheme: FilledButtonThemeData(
      style: _filledButtonStyle(
        backgroundColor: AppColors.lightAccent,
        foregroundColor: AppColors.lightAccentInk,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      modalBackgroundColor: AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.bottomSheetBorder),
    ),
  );

  static TextTheme _textTheme({
    required Color text,
    required Color dimText,
    required Color mutedText,
  }) {
    return TextTheme(
      displayLarge: AppTypography.display.copyWith(color: text),
      headlineLarge: AppTypography.heading1.copyWith(color: text),
      headlineMedium: AppTypography.heading2.copyWith(color: text),
      headlineSmall: AppTypography.heading3.copyWith(color: text),
      bodyMedium: AppTypography.body.copyWith(color: text),
      bodySmall: AppTypography.small.copyWith(color: dimText),
      labelMedium: AppTypography.metadataTag.copyWith(color: mutedText),
      labelSmall: AppTypography.caption.copyWith(color: mutedText),
    );
  }

  static ButtonStyle _filledButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
      foregroundColor: WidgetStatePropertyAll(foregroundColor),
      minimumSize: const WidgetStatePropertyAll(
        Size(AppSpacing.touchTarget, AppSpacing.touchTarget),
      ),
      padding: const WidgetStatePropertyAll(AppSpacing.buttonInsets),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.smallBorder),
      ),
    );
  }
}
