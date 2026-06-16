import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/swatch/color_swatch.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneColorSwatch, path: '[Design System]/Swatch')
Widget buildColorSwatchUseCase(BuildContext context) {
  return const RunZoneColorSwatch(color: Color(0xFF27AE60));
}
