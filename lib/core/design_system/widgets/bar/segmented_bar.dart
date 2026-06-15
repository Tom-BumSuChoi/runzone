import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';
import '../../app_spacing.dart';
import '../label/run_zone_label_small_label.dart';

final class RunZoneSegmentedBar extends StatelessWidget {
  const RunZoneSegmentedBar({required this.segments, super.key});

  final List<RunZoneSegmentData> segments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizing.heartRateZoneBarHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: AppSpacing.zoneSegmentGap,
        children: [
          for (final segment in segments)
            Expanded(
              child: _RunZoneSegmentedBarItem(
                label: segment.label,
                color: segment.color,
                heightFactor: segment.heightFactor,
              ),
            ),
        ],
      ),
    );
  }
}

final class RunZoneSegmentData {
  const RunZoneSegmentData({required this.label, required this.color, required this.heightFactor});

  final String label;
  final Color color;
  final double heightFactor;
}

final class _RunZoneSegmentedBarItem extends StatelessWidget {
  const _RunZoneSegmentedBarItem({required this.label, required this.color, required this.heightFactor});

  final String label;
  final Color color;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: heightFactor,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color, borderRadius: AppRadius.zoneSegmentTopBorder),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        AppSpacing.titleDescriptionGap,
        RunZoneLabelSmallLabel(label, color: colorScheme.onSurfaceVariant),
      ],
    );
  }
}
