import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_spacing.dart';

final class RunZoneFilledCard extends StatelessWidget {
  const RunZoneFilledCard({required this.child, this.padding = AppSpacing.cardInsets, super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surfaceContainer, borderRadius: AppRadius.mediumBorder),
      child: Padding(padding: padding, child: child),
    );
  }
}
