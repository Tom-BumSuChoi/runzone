import 'package:flutter/material.dart';

import '../../app_typography.dart';

final class RunZoneNavigationLabel extends StatelessWidget {
  const RunZoneNavigationLabel(this.text, {super.key, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTypography.caption.copyWith(color: color));
  }
}
