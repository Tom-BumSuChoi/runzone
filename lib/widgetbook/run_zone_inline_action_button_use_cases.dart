import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/assets/run_zone_icon_asset.dart';
import '../core/design_system/widgets/button/run_zone_inline_action_button.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneInlineActionButton, path: '[Design System]/Button')
Widget buildInlineActionButtonUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: '새로고침');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return RunZoneInlineActionButton(
    icon: RunZoneIconAsset.refresh,
    label: label,
    onPressed: isEnabled ? () {} : null,
  );
}
