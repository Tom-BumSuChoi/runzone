import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_typography.dart';

final class RunZoneChoiceChip extends StatelessWidget {
  const RunZoneChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: AppTypography.eyebrow.copyWith(
          color: selected ? AppColors.lightAccentInk : AppColors.lightDimText,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: selected,
      onSelected: enabled ? onSelected : null,
      showCheckmark: false,
      backgroundColor: AppColors.lightSecondarySurface,
      selectedColor: AppColors.lightAccent,
      side: BorderSide(color: selected ? Colors.transparent : AppColors.lightLine),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chipBorder,
      ),
      padding: AppSpacing.chipInsets,
      labelPadding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
