import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_spacing.dart';
import '../app_radius.dart';

final class RunZoneCard extends StatelessWidget {
  const RunZoneCard({
    required this.child,
    this.padding = AppSpacing.cardInsets,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: AppRadius.mediumBorder,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
