import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/control/run_zone_segmented_control.dart';

enum _SegmentedControlSampleValue { indoor, outdoor }

@widgetbook.UseCase(name: 'Default', type: RunZoneSegmentedControl, path: '[Design System]')
Widget buildSegmentedControlUseCase(BuildContext context) {
  var selectedValue = _SegmentedControlSampleValue.indoor;

  return StatefulBuilder(
    builder: (context, setState) {
      return RunZoneSegmentedControl<_SegmentedControlSampleValue>(
        selectedValue: selectedValue,
        onChanged: (value) => setState(() => selectedValue = value),
        options: const [
          RunZoneSegmentedControlOption(value: _SegmentedControlSampleValue.indoor, label: '실내 · 러닝머신'),
          RunZoneSegmentedControlOption(value: _SegmentedControlSampleValue.outdoor, label: '야외 · GPS'),
        ],
      );
    },
  );
}
