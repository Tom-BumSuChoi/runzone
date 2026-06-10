import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/run_zone_choice_chip.dart';

@widgetbook.UseCase(name: 'Selected', type: RunZoneChoiceChip, path: '[Design System]')
Widget buildSelectedChoiceChipUseCase(BuildContext context) {
  return Center(
    child: RunZoneChoiceChip(label: '초보', isSelected: true, onTap: () {}),
  );
}

@widgetbook.UseCase(name: 'Unselected', type: RunZoneChoiceChip, path: '[Design System]')
Widget buildUnselectedChoiceChipUseCase(BuildContext context) {
  return Center(
    child: RunZoneChoiceChip(label: '입문', isSelected: false, onTap: () {}),
  );
}
