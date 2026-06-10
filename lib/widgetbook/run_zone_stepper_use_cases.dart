import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/run_zone_stepper.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneStepper, path: '[Design System]')
Widget buildStepperUseCase(BuildContext context) {
  var value = 176;
  return Center(
    child: StatefulBuilder(
      builder: (context, setState) {
        return RunZoneStepper(
          value: value,
          onDecrement: () => setState(() => value--),
          onIncrement: () => setState(() => value++),
        );
      },
    ),
  );
}
