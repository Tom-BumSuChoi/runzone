import 'package:flutter/material.dart';

import '../../app_sizing.dart';
import '../label/run_zone_body_medium_label.dart';
import '../label/run_zone_body_small_label.dart';

final class RunZoneProfileField extends StatelessWidget {
  const RunZoneProfileField({required this.label, required this.trailing, this.subLabel, super.key});

  final String label;
  final String? subLabel;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizing.rowHeight,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RunZoneBodyMediumLabel(label),
              if (subLabel != null) RunZoneBodySmallLabel(subLabel!),
            ],
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}
