import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/app_color_scheme.dart';
import '../core/design_system/widgets/slider/labeled_slider.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneLabeledSlider, path: '[Design System]/Slider')
Widget buildLabeledSliderUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Z1 → Z2');
  final unitLabel = context.knobs.string(label: 'Unit', initialValue: 'bpm');
  final minimum = context.knobs.double.slider(label: 'Minimum', initialValue: 95, min: 60, max: 200);
  final maximum = context.knobs.double.slider(label: 'Maximum', initialValue: 143, min: 60, max: 220);
  final colorScheme = Theme.of(context).colorScheme;

  var value = 131.0;

  return StatefulBuilder(
    builder: (context, setState) {
      final clampedValue = value.clamp(minimum, maximum);
      return RunZoneLabeledSlider(
        label: label,
        valueLabel: clampedValue.round().toString(),
        unitLabel: unitLabel,
        value: clampedValue,
        minimum: minimum,
        maximum: maximum,
        leadingColor: colorScheme.zoneOne,
        trailingColor: colorScheme.zoneTwo,
        onChanged: (nextValue) => setState(() => value = nextValue),
      );
    },
  );
}
