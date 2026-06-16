import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/card/run_zone_card.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneCard, path: '[Design System]/Card')
Widget buildCardUseCase(BuildContext context) {
  final content = context.knobs.string(label: 'Content', initialValue: '카드 내용');

  return RunZoneCard(child: Text(content));
}
