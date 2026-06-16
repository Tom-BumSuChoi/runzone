import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/app_color_scheme.dart';
import '../core/design_system/widgets/bar/segmented_bar.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneSegmentedBar, path: '[Design System]/Bar')
Widget buildHeartRateZoneBarUseCase(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  final z1 = context.knobs.double.slider(label: 'Z1 Height', initialValue: 0.29, min: 0, max: 1);
  final z2 = context.knobs.double.slider(label: 'Z2 Height', initialValue: 0.42, min: 0, max: 1);
  final z3 = context.knobs.double.slider(label: 'Z3 Height', initialValue: 0.56, min: 0, max: 1);
  final z4 = context.knobs.double.slider(label: 'Z4 Height', initialValue: 0.69, min: 0, max: 1);
  final z5 = context.knobs.double.slider(label: 'Z5 Height', initialValue: 1.0, min: 0, max: 1);

  return RunZoneSegmentedBar(
    segments: [
      RunZoneSegmentData(label: 'Z1', color: colorScheme.zoneOne, heightFactor: z1),
      RunZoneSegmentData(label: 'Z2', color: colorScheme.zoneTwo, heightFactor: z2),
      RunZoneSegmentData(label: 'Z3', color: colorScheme.zoneThree, heightFactor: z3),
      RunZoneSegmentData(label: 'Z4', color: colorScheme.zoneFour, heightFactor: z4),
      RunZoneSegmentData(label: 'Z5', color: colorScheme.zoneFive, heightFactor: z5),
    ],
  );
}
