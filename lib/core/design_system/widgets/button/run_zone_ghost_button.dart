import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';
import '../../app_spacing.dart';
import '../label/run_zone_label_large_label.dart';

final class RunZoneGhostButton extends StatelessWidget {
  const RunZoneGhostButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurfaceVariant,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          minimumSize: const Size(AppSizing.touchTarget, AppSizing.touchTarget),
          padding: AppSpacing.buttonInsets,
          side: BorderSide(color: colorScheme.outlineVariant),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.smallBorder),
        ),
        child: RunZoneLabelLargeLabel(label, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
