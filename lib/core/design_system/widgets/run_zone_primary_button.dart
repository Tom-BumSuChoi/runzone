import 'package:flutter/material.dart';

import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_typography.dart';

final class RunZonePrimaryButton extends StatelessWidget {
  const RunZonePrimaryButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(color: colorScheme.primary, borderRadius: AppRadius.smallBorder),
          child: Padding(
            padding: AppSpacing.buttonInsets,
            child: Center(
              child: Text(label, style: AppTypography.heading3.copyWith(color: colorScheme.onPrimary)),
            ),
          ),
        ),
      ),
    );
  }
}
