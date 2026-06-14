import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/app_color_scheme.dart';
import '../core/design_system/widgets/bar/segmented_bar.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneSegmentedBar, path: '[Design System]')
Widget buildHeartRateZoneBarUseCase(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return RunZoneSegmentedBar(
    segments: [
      RunZoneSegmentData(label: 'Z1', color: colorScheme.zoneOne, heightFactor: 0.29),
      RunZoneSegmentData(label: 'Z2', color: colorScheme.zoneTwo, heightFactor: 0.42),
      RunZoneSegmentData(label: 'Z3', color: colorScheme.zoneThree, heightFactor: 0.56),
      RunZoneSegmentData(label: 'Z4', color: colorScheme.zoneFour, heightFactor: 0.69),
      RunZoneSegmentData(label: 'Z5', color: colorScheme.zoneFive, heightFactor: 1),
    ],
  );
}
