import 'package:flutter/material.dart';
import 'package:runzone/core/design_system/app_radius.dart';
import 'package:runzone/core/design_system/app_semantic_colors.dart';
import 'package:runzone/core/design_system/app_sizing.dart';
import 'package:runzone/core/design_system/app_spacing.dart';

final class RunZoneProgressIndicator extends StatelessWidget {
  const RunZoneProgressIndicator({required this.totalSteps, required this.currentStep, super.key})
    : assert(totalSteps > 0),
      assert(currentStep >= 1 && currentStep <= totalSteps);

  final int totalSteps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.of(context);
    final segments = <Widget>[];

    for (var i = 0; i < totalSteps; i++) {
      final color = i < currentStep ? colors.accent : colors.secondaryLine;
      segments.add(_Segment(color: color));
    }

    return Row(spacing: AppSpacing.tight, children: segments);
  }
}

final class _Segment extends StatelessWidget {
  const _Segment({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: AppSizing.progressSegmentHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, borderRadius: AppRadius.progressBorder),
        ),
      ),
    );
  }
}
