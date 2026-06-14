import 'package:flutter/material.dart';

import '../app_radius.dart';
import '../app_sizing.dart';
import '../app_spacing.dart';
import '../app_typography.dart';

final class RunZoneStepper extends StatelessWidget {
  const RunZoneStepper({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    super.key,
  });

  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.stepperGap,
      children: [
        _button(context, Icons.remove, onDecrement),
        SizedBox(
          width: AppSizing.stepperValueWidth,
          child: Text('$value', textAlign: TextAlign.center, style: AppTypography.stepperValue),
        ),
        _button(context, Icons.add, onIncrement),
      ],
    );
  }

  Widget _button(BuildContext context, IconData icon, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizing.stepperButton,
        height: AppSizing.stepperButton,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: AppRadius.smallBorder,
        ),
        child: Icon(icon, size: AppSpacing.iconSmall),
      ),
    );
  }
}
