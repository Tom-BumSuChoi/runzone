import 'package:flutter/material.dart';

final class RunZoneTitleLabel extends StatelessWidget {
  const RunZoneTitleLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headlineSmall);
  }
}
