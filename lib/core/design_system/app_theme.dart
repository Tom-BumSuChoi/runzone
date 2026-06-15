import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizing.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static const _fontFamily = 'IBM Plex Sans KR';
  static const themeMode = ThemeMode.system;

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    splashFactory: NoSplash.splashFactory,
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
    textTheme: _textTheme(text: AppColors.gray100, dimText: AppColors.gray400, mutedText: AppColors.gray500),
    dividerTheme: const DividerThemeData(color: AppColors.gray700),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.lime300,
      inactiveTrackColor: AppColors.gray600,
      overlayShape: SliderComponentShape.noOverlay,
      padding: EdgeInsets.zero,
      thumbColor: AppColors.lime300,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: _filledButtonStyle(backgroundColor: AppColors.lime300, foregroundColor: AppColors.gray950),
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
    fontFamily: _fontFamily,
    splashFactory: NoSplash.splashFactory,
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
    textTheme: _textTheme(text: AppColors.gray950, dimText: AppColors.gray500, mutedText: AppColors.gray400),
    dividerTheme: const DividerThemeData(color: AppColors.gray400),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.lime400,
      inactiveTrackColor: AppColors.gray500,
      overlayShape: SliderComponentShape.noOverlay,
      padding: EdgeInsets.zero,
      thumbColor: AppColors.lime400,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: _filledButtonStyle(backgroundColor: AppColors.lime400, foregroundColor: AppColors.gray950),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.white,
      modalBackgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.bottomSheetBorder),
    ),
  );

  static TextTheme _textTheme({required Color text, required Color dimText, required Color mutedText}) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 64,
        fontWeight: FontWeight.w600,
        height: 0.9,
        color: text,
      ),
      displayMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 52,
        fontWeight: FontWeight.w800,
        height: 1,
        color: text,
      ),
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1,
        color: text,
      ),
      headlineLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: text,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: text,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: text,
      ),
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.1,
        color: text,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: text,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: text,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: dimText,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: text,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: dimText,
      ),
      labelLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: text,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: mutedText,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: mutedText,
      ),
    );
  }

  static ButtonStyle _filledButtonStyle({required Color backgroundColor, required Color foregroundColor}) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
      foregroundColor: WidgetStatePropertyAll(foregroundColor),
      minimumSize: const WidgetStatePropertyAll(Size(AppSizing.touchTarget, AppSizing.touchTarget)),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      padding: const WidgetStatePropertyAll(AppSpacing.buttonInsets),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: AppRadius.smallBorder)),
      splashFactory: NoSplash.splashFactory,
    );
  }
}
