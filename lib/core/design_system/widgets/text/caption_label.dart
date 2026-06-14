import 'package:flutter/material.dart';

final class RunZoneCaptionLabel extends StatelessWidget {
  const RunZoneCaptionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(text, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurface));
  }
}
