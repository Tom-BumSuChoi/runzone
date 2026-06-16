import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/button/run_zone_primary_button.dart';

@widgetbook.UseCase(name: 'Default', type: RunZonePrimaryButton, path: '[Design System]/Button')
Widget buildPrimaryButtonUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: '시작하기');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return RunZonePrimaryButton(
    label: label,
    onPressed: isEnabled ? () {} : null,
  );
}
