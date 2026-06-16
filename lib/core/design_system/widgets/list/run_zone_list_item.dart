import 'package:flutter/material.dart';

import '../../app_sizing.dart';
import '../label/run_zone_body_medium_label.dart';
import '../label/run_zone_body_small_label.dart';

final class RunZoneListItem extends StatelessWidget {
  const RunZoneListItem({required this.title, required this.trailing, this.subtitle, super.key});

  final String title;
  final String? subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSizing.rowHeight),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RunZoneBodyMediumLabel(title),
                if (subtitle case final subtitle?) RunZoneBodySmallLabel(subtitle),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
