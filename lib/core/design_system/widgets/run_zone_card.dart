import 'package:flutter/material.dart';

import '../app_radius.dart';
import '../app_semantic_colors.dart';
import '../app_spacing.dart';

final class RunZoneCard extends StatelessWidget {
  const RunZoneCard({required this.child, this.padding = AppSpacing.cardInsets, super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.line),
        borderRadius: AppRadius.mediumBorder,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
