import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../label/run_zone_label_small_label.dart';

final class RunZoneTextPill extends StatelessWidget {
  const RunZoneTextPill(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.pillBorder,
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: AppSpacing.chipInsets,
        child: RunZoneLabelSmallLabel(label, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
