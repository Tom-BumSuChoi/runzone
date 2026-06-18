import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/assets/run_zone_icon_asset.dart';
import '../core/design_system/widgets/button/run_zone_icon_outline_button.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneIconOutlineButton, path: '[Design System]/Button')
Widget buildIconOutlineButtonUseCase(BuildContext context) {
  final icon = context.knobs.object.dropdown<RunZoneIconAsset>(
    label: 'Icon',
    options: RunZoneIconAsset.values,
    initialOption: RunZoneIconAsset.minus,
  );

  return RunZoneIconOutlineButton(
    icon: icon,
    onPressed: () {},
  );
}
