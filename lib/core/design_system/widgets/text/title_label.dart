import 'package:flutter/material.dart';

final class RunZoneTitleLabel extends StatelessWidget {
  const RunZoneTitleLabel(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color));
  }
}
