import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
final class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.accent,
    required this.accentInk,
    required this.surface,
    required this.secondarySurface,
    required this.line,
    required this.secondaryLine,
    required this.dimText,
  });

  final Color accent;
  final Color accentInk;
  final Color surface;
  final Color secondarySurface;
  final Color line;
  final Color secondaryLine;
  final Color dimText;

  static const dark = AppSemanticColors(
    accent: AppColors.accent,
    accentInk: AppColors.accentInk,
    surface: AppColors.surface,
    secondarySurface: AppColors.secondarySurface,
    line: AppColors.line,
    secondaryLine: AppColors.secondaryLine,
    dimText: AppColors.dimText,
  );

  static const light = AppSemanticColors(
    accent: AppColors.lightAccent,
    accentInk: AppColors.lightAccentInk,
    surface: AppColors.lightSurface,
    secondarySurface: AppColors.lightSecondarySurface,
    line: AppColors.lightLine,
    secondaryLine: AppColors.lightSecondaryLine,
    dimText: AppColors.lightDimText,
  );

  static AppSemanticColors of(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>();
    assert(colors != null, 'AppSemanticColors is not registered. Add it to ThemeData.extensions.');
    return colors ?? dark;
  }

  @override
  AppSemanticColors copyWith({
    Color? accent,
    Color? accentInk,
    Color? surface,
    Color? secondarySurface,
    Color? line,
    Color? secondaryLine,
    Color? dimText,
  }) {
    return AppSemanticColors(
      accent: accent ?? this.accent,
      accentInk: accentInk ?? this.accentInk,
      surface: surface ?? this.surface,
      secondarySurface: secondarySurface ?? this.secondarySurface,
      line: line ?? this.line,
      secondaryLine: secondaryLine ?? this.secondaryLine,
      dimText: dimText ?? this.dimText,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accentInk: Color.lerp(accentInk, other.accentInk, t) ?? accentInk,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      secondarySurface: Color.lerp(secondarySurface, other.secondarySurface, t) ?? secondarySurface,
      line: Color.lerp(line, other.line, t) ?? line,
      secondaryLine: Color.lerp(secondaryLine, other.secondaryLine, t) ?? secondaryLine,
      dimText: Color.lerp(dimText, other.dimText, t) ?? dimText,
    );
  }
}
