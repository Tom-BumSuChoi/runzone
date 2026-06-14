import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/slider/labeled_slider.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneLabeledSlider, path: '[Design System]')
Widget buildLabeledSliderUseCase(BuildContext context) {
  var value = 131.0;

  return StatefulBuilder(
    builder: (context, setState) {
      return RunZoneLabeledSlider(
        label: 'Z1 → Z2',
        valueLabel: value.round().toString(),
        unitLabel: 'bpm',
        value: value,
        minimum: 95,
        maximum: 143,
        leadingColor: const Color(0xFF2F80ED),
        trailingColor: const Color(0xFF27AE60),
        onChanged: (nextValue) => setState(() => value = nextValue),
      );
    },
  );
}
