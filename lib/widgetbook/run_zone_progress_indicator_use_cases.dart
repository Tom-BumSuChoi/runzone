import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/progress/run_zone_progress_indicator.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneProgressIndicator, path: '[Design System]/Progress')
Widget buildProgressIndicatorUseCase(BuildContext context) {
  final totalSteps = context.knobs.int.slider(label: 'Total Steps', initialValue: 2, min: 1, max: 5);
  final currentStep = context.knobs.int.slider(label: 'Current Step', initialValue: 1, min: 1, max: 5);

  return RunZoneProgressIndicator(
    totalSteps: totalSteps,
    currentStep: currentStep.clamp(1, totalSteps),
  );
}
