import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_spacing.dart';

final class RunZoneCard extends StatelessWidget {
  const RunZoneCard({required this.child, this.padding = AppSpacing.cardInsets, super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline),
        borderRadius: AppRadius.mediumBorder,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
