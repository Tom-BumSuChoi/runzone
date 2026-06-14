import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/button/run_zone_primary_button.dart';

@widgetbook.UseCase(name: 'Default', type: RunZonePrimaryButton, path: '[Design System]')
Widget buildPrimaryButtonUseCase(BuildContext context) {
  return RunZonePrimaryButton(label: '시작하기', onPressed: () {});
}
