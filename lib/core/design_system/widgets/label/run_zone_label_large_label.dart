import 'package:flutter/material.dart';

final class RunZoneLabelLargeLabel extends StatelessWidget {
  const RunZoneLabelLargeLabel(this.text, {this.color, this.textAlign, super.key});

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
      style: textTheme.labelLarge?.copyWith(color: color ?? colorScheme.onSurface),
    );
  }
}
