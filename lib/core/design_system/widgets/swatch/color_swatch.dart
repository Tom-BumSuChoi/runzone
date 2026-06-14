import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';

final class RunZoneColorSwatch extends StatelessWidget {
  const RunZoneColorSwatch({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: AppRadius.colorSwatchBorder),
      child: const SizedBox.square(dimension: AppSizing.colorSwatch),
    );
  }
}
