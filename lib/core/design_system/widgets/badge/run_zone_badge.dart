import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../label/run_zone_label_medium_label.dart';

final class RunZoneBadge extends StatelessWidget {
  const RunZoneBadge(this.label, {this.isHighlighted = false, super.key});

  final String label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHighlighted ? colorScheme.primary : Colors.transparent,
        border: Border.all(color: isHighlighted ? Colors.transparent : colorScheme.outlineVariant),
        borderRadius: AppRadius.badgeBorder,
      ),
      child: Padding(
        padding: AppSpacing.badgeInsets,
        child: RunZoneLabelMediumLabel(
          label,
          color: isHighlighted ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
