import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizing.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static const themeMode = ThemeMode.system;

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTypography.sansKorean,
    scaffoldBackgroundColor: AppColors.gray1000,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.lime300,
      onPrimary: AppColors.gray950,
      secondary: AppColors.lime400,
      onSecondary: AppColors.gray950,
      surface: AppColors.gray900,
      onSurface: AppColors.gray100,
      surfaceContainerHighest: AppColors.gray850,
      onSurfaceVariant: AppColors.gray400,
      outline: AppColors.gray700,
      outlineVariant: AppColors.gray600,
      error: AppColors.red500,
      onError: AppColors.white,
    ),
    textTheme: _textTheme(
      text: AppColors.gray100,
      dimText: AppColors.gray400,
      mutedText: AppColors.gray500,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.gray700),
    filledButtonTheme: FilledButtonThemeData(
      style: _filledButtonStyle(
        backgroundColor: AppColors.lime300,
        foregroundColor: AppColors.gray950,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.gray900,
      modalBackgroundColor: AppColors.gray900,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.bottomSheetBorder),
    ),
  );

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.sansKorean,
    scaffoldBackgroundColor: AppColors.gray100,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lime400,
      onPrimary: AppColors.gray950,
      secondary: AppColors.lime500,
      onSecondary: AppColors.gray950,
      surface: AppColors.white,
      onSurface: AppColors.gray950,
      surfaceContainerHighest: AppColors.gray100,
      onSurfaceVariant: AppColors.gray500,
      outline: AppColors.gray400,
      outlineVariant: AppColors.gray500,
      error: AppColors.red500,
      onError: AppColors.white,
    ),
    textTheme: _textTheme(
      text: AppColors.gray950,
      dimText: AppColors.gray500,
      mutedText: AppColors.gray400,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.gray400),
    filledButtonTheme: FilledButtonThemeData(
      style: _filledButtonStyle(
        backgroundColor: AppColors.lime400,
        foregroundColor: AppColors.gray950,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.white,
      modalBackgroundColor: AppColors.white,
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
        Size(AppSizing.touchTarget, AppSizing.touchTarget),
      ),
      padding: const WidgetStatePropertyAll(AppSpacing.buttonInsets),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.smallBorder),
      ),
    );
  }
}
