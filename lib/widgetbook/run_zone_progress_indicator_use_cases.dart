import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/app_color_scheme.dart';
import '../core/design_system/widgets/progress/run_zone_progress_indicator.dart';
import '../core/design_system/widgets/progress/run_zone_ring_progress.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneProgressIndicator, path: '[Design System]/Progress')
Widget buildProgressIndicatorUseCase(BuildContext context) {
  final totalSteps = context.knobs.int.slider(label: 'Total Steps', initialValue: 2, min: 1, max: 5);
  final currentStep = context.knobs.int.slider(label: 'Current Step', initialValue: 1, min: 1, max: 5);

  return RunZoneProgressIndicator(totalSteps: totalSteps, currentStep: currentStep.clamp(1, totalSteps));
}

@widgetbook.UseCase(name: 'Ring', type: RunZoneRingProgress, path: '[Design System]/Progress')
Widget buildRingProgressUseCase(BuildContext context) {
  final progress = context.knobs.double.slider(label: 'Progress', initialValue: 0.56, min: 0, max: 1);
  final size = context.knobs.double.slider(label: 'Size', initialValue: 214, min: 120, max: 320);
  final colorScheme = Theme.of(context).colorScheme;

  return RunZoneRingProgress(
    value: progress,
    color: colorScheme.zoneTwo,
    size: size,
    child: Text(
      '${(progress * 100).round()}%',
      style: Theme.of(context).textTheme.displaySmall?.copyWith(color: colorScheme.zoneTwo),
    ),
  );
}
