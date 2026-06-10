import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/run_zone_progress_indicator.dart';

@widgetbook.UseCase(name: 'Step 1 of 2', type: RunZoneProgressIndicator, path: '[Design System]')
Widget buildStepOneProgressIndicatorUseCase(BuildContext context) {
  return const Center(child: RunZoneProgressIndicator(totalSteps: 2, currentStep: 1));
}

@widgetbook.UseCase(name: 'Step 2 of 2', type: RunZoneProgressIndicator, path: '[Design System]')
Widget buildStepTwoProgressIndicatorUseCase(BuildContext context) {
  return const Center(child: RunZoneProgressIndicator(totalSteps: 2, currentStep: 2));
}
