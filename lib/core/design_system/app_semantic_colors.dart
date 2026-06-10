import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
final class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({required this.progressFill, required this.progressTrack});

  final Color progressFill;
  final Color progressTrack;

  static const dark = AppSemanticColors(progressFill: AppColors.accent, progressTrack: AppColors.secondaryLine);
  static const light = AppSemanticColors(
    progressFill: AppColors.lightAccent,
    progressTrack: AppColors.lightSecondaryLine,
  );

  static AppSemanticColors of(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>();
    assert(colors != null, 'AppSemanticColors is not registered. Add it to ThemeData.extensions.');
    return colors ?? dark;
  }

  @override
  AppSemanticColors copyWith({Color? progressFill, Color? progressTrack}) {
    return AppSemanticColors(
      progressFill: progressFill ?? this.progressFill,
      progressTrack: progressTrack ?? this.progressTrack,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      progressFill: Color.lerp(progressFill, other.progressFill, t) ?? progressFill,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t) ?? progressTrack,
    );
  }
}
