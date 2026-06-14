import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/app_color_scheme.dart';
import '../core/design_system/widgets/slider/labeled_slider.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneLabeledSlider, path: '[Design System]')
Widget buildLabeledSliderUseCase(BuildContext context) {
  var value = 131.0;
  final colorScheme = Theme.of(context).colorScheme;

  return StatefulBuilder(
    builder: (context, setState) {
      return RunZoneLabeledSlider(
        label: 'Z1 → Z2',
        valueLabel: value.round().toString(),
        unitLabel: 'bpm',
        value: value,
        minimum: 95,
        maximum: 143,
        leadingColor: colorScheme.zoneOne,
        trailingColor: colorScheme.zoneTwo,
        onChanged: (nextValue) => setState(() => value = nextValue),
      );
    },
  );
}
