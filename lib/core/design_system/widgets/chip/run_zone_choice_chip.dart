import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../../app_typography.dart';

final class RunZoneChoiceChip extends StatelessWidget {
  const RunZoneChoiceChip({super.key, required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final foreground = isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    final border = isSelected ? Colors.transparent : colorScheme.outlineVariant;

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: border),
          borderRadius: AppRadius.chipBorder,
        ),
        child: Padding(
          padding: AppSpacing.chipInsets,
          child: Text(
            label,
            style: AppTypography.eyebrow.copyWith(
              color: foreground,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
