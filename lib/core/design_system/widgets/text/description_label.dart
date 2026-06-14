import 'package:flutter/material.dart';

final class RunZoneDescriptionLabel extends StatelessWidget {
  const RunZoneDescriptionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(text, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant));
  }
}
