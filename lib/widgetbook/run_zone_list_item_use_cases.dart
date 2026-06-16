import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/app_spacing.dart';
import '../core/design_system/widgets/chip/run_zone_choice_chip.dart';
import '../core/design_system/widgets/list/run_zone_list_item.dart';
import '../core/design_system/widgets/stepper/run_zone_stepper.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneListItem, path: '[Design System]/List')
Widget buildListItemUseCase(BuildContext context) {
  var stepperValue = 176;
  var isMale = true;

  return StatefulBuilder(
    builder: (context, setState) {
      final title = context.knobs.string(label: 'Title', initialValue: '키');
      final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'cm');
      final trailingType = context.knobs.object.dropdown(
        label: 'Trailing',
        options: ['Stepper', 'Chips'],
        initialOption: 'Stepper',
      );
      final trailing = trailingType == 'Chips'
          ? Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.chipGap,
              children: [
                RunZoneChoiceChip(label: '남', isSelected: isMale, onTap: () => setState(() => isMale = true)),
                RunZoneChoiceChip(label: '여', isSelected: !isMale, onTap: () => setState(() => isMale = false)),
              ],
            )
          : RunZoneStepper(
              label: '$stepperValue',
              onDecrement: () => setState(() => stepperValue--),
              onIncrement: () => setState(() => stepperValue++),
            );

      return RunZoneListItem(
        title: title,
        subtitle: subtitle.isEmpty ? null : subtitle,
        trailing: trailing,
      );
    },
  );
}
