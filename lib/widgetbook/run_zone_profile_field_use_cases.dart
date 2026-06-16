import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/app_spacing.dart';
import '../core/design_system/widgets/chip/run_zone_choice_chip.dart';
import '../core/design_system/widgets/field/run_zone_profile_field.dart';
import '../core/design_system/widgets/stepper/run_zone_stepper.dart';

@widgetbook.UseCase(name: 'With Stepper', type: RunZoneProfileField, path: '[Design System]')
Widget buildProfileFieldWithStepperUseCase(BuildContext context) {
  var value = 176;
  return StatefulBuilder(
    builder: (context, setState) {
      return RunZoneProfileField(
        label: '키',
        subLabel: 'cm',
        trailing: RunZoneStepper(
          label: '$value',
          onDecrement: () => setState(() => value--),
          onIncrement: () => setState(() => value++),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'With Chips', type: RunZoneProfileField, path: '[Design System]')
Widget buildProfileFieldWithChipsUseCase(BuildContext context) {
  var isMale = true;
  return StatefulBuilder(
    builder: (context, setState) {
      return RunZoneProfileField(
        label: '성별',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.chipGap,
          children: [
            RunZoneChoiceChip(label: '남', isSelected: isMale, onTap: () => setState(() => isMale = true)),
            RunZoneChoiceChip(label: '여', isSelected: !isMale, onTap: () => setState(() => isMale = false)),
          ],
        ),
      );
    },
  );
}
