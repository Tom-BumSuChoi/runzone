import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/chip/run_zone_choice_chip.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneChoiceChip, path: '[Design System]/Chip')
Widget buildChoiceChipUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: '초보');
  final isSelected = context.knobs.boolean(label: 'Selected', initialValue: true);

  return RunZoneChoiceChip(label: label, isSelected: isSelected, onTap: () {});
}
