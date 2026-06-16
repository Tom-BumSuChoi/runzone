import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/stepper/run_zone_stepper.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneStepper, path: '[Design System]')
Widget buildStepperUseCase(BuildContext context) {
  var value = 176;
  return StatefulBuilder(
    builder: (context, setState) {
      return RunZoneStepper(
        label: '$value',
        onDecrement: () => setState(() => value--),
        onIncrement: () => setState(() => value++),
      );
    },
  );
}
