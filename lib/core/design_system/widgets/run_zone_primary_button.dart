import 'package:flutter/material.dart';
import 'package:runzone/core/design_system/app_semantic_colors.dart';

import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_typography.dart';

final class RunZonePrimaryButton extends StatelessWidget {
  const RunZonePrimaryButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.of(context);

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.accent, borderRadius: AppRadius.smallBorder),
          child: Padding(
            padding: AppSpacing.buttonInsets,
            child: Center(
              child: Text(label, style: AppTypography.heading3.copyWith(color: colors.accentInk)),
            ),
          ),
        ),
      ),
    );
  }
}
