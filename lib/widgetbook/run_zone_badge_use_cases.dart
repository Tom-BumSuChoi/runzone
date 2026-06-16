import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/badge/run_zone_badge.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneBadge, path: '[Design System]/Badge')
Widget buildBadgeUseCase(BuildContext context) {
  return RunZoneBadge(
    context.knobs.string(label: 'Label', initialValue: '없음'),
    isHighlighted: context.knobs.boolean(label: 'Highlighted'),
  );
}
