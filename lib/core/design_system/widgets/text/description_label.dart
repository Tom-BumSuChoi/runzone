import 'package:flutter/material.dart';

final class RunZoneDescriptionLabel extends StatelessWidget {
  const RunZoneDescriptionLabel(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(text, style: textTheme.bodyMedium?.copyWith(color: color ?? colorScheme.onSurfaceVariant));
  }
}
