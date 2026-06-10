import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
final class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.accent,
    required this.accentInk,
    required this.secondarySurface,
    required this.secondaryLine,
    required this.dimText,
  });

  final Color accent;
  final Color accentInk;
  final Color secondarySurface;
  final Color secondaryLine;
  final Color dimText;

  static const dark = AppSemanticColors(
    accent: AppColors.accent,
    accentInk: AppColors.accentInk,
    secondarySurface: AppColors.secondarySurface,
    secondaryLine: AppColors.secondaryLine,
    dimText: AppColors.dimText,
  );

  static const light = AppSemanticColors(
    accent: AppColors.lightAccent,
    accentInk: AppColors.lightAccentInk,
    secondarySurface: AppColors.lightSecondarySurface,
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
    Color? secondarySurface,
    Color? secondaryLine,
    Color? dimText,
  }) {
    return AppSemanticColors(
      accent: accent ?? this.accent,
      accentInk: accentInk ?? this.accentInk,
      secondarySurface: secondarySurface ?? this.secondarySurface,
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
      secondarySurface: Color.lerp(secondarySurface, other.secondarySurface, t) ?? secondarySurface,
      secondaryLine: Color.lerp(secondaryLine, other.secondaryLine, t) ?? secondaryLine,
      dimText: Color.lerp(dimText, other.dimText, t) ?? dimText,
    );
  }
}
