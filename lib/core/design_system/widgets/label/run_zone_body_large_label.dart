import 'package:flutter/material.dart';

final class RunZoneBodyLargeLabel extends StatelessWidget {
  const RunZoneBodyLargeLabel(this.text, {this.color, this.textAlign, super.key});

  final String text;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      text,
      textAlign: textAlign,
      style: textTheme.bodyLarge?.copyWith(color: color ?? colorScheme.onSurfaceVariant),
    );
  }
}
