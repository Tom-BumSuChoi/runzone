import 'package:flutter/material.dart';

import '../../app_typography.dart';

final class RunZoneSectionLabel extends StatelessWidget {
  const RunZoneSectionLabel(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(text, style: AppTypography.eyebrow.copyWith(color: color ?? colorScheme.onSurfaceVariant));
  }
}
