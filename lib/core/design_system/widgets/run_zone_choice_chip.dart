import 'package:flutter/material.dart';
import 'package:runzone/core/design_system/app_semantic_colors.dart';

import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_typography.dart';

final class RunZoneChoiceChip extends StatelessWidget {
  const RunZoneChoiceChip({super.key, required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.of(context);
    final background = isSelected ? colors.accent : colors.secondarySurface;
    final foreground = isSelected ? colors.accentInk : colors.dimText;
    final border = isSelected ? Colors.transparent : colors.secondaryLine;

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
