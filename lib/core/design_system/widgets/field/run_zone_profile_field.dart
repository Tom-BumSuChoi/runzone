import 'package:flutter/material.dart';

import '../../app_sizing.dart';

final class RunZoneProfileField extends StatelessWidget {
  const RunZoneProfileField({required this.label, required this.trailing, this.subLabel, super.key});

  final String label;
  final String? subLabel;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: AppSizing.rowHeight,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: textTheme.bodyMedium),
              if (subLabel != null) Text(subLabel!, style: textTheme.bodySmall),
            ],
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}
