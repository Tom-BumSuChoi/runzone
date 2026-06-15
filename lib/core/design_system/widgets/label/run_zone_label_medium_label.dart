import 'package:flutter/material.dart';

final class RunZoneLabelMediumLabel extends StatelessWidget {
  const RunZoneLabelMediumLabel(this.text, {this.color, this.fontWeight, this.textAlign, super.key});

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      text,
      textAlign: textAlign,
      style: textTheme.labelMedium?.copyWith(color: color ?? colorScheme.onSurfaceVariant, fontWeight: fontWeight),
    );
  }
}
