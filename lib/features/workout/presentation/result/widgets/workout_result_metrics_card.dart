import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_sizing.dart';
import '../../../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_title_medium_label.dart';

final class WorkoutResultMetricsCard extends StatelessWidget {
  const WorkoutResultMetricsCard({
    required this.distanceKm,
    required this.durationLabel,
    required this.averageBpm,
    super.key,
  });

  final double distanceKm;
  final String durationLabel;
  final int? averageBpm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RunZoneCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MetricItem(value: distanceKm.toStringAsFixed(1), label: '거리', unit: 'km'),
          _divider(colorScheme),
          _MetricItem(value: durationLabel, label: '시간'),
          _divider(colorScheme),
          _MetricItem(value: averageBpm != null ? '$averageBpm' : '--', label: '평균', unit: 'bpm'),
        ],
      ),
    );
  }

  Widget _divider(ColorScheme colorScheme) {
    return SizedBox(
      height: AppSizing.metricDividerHeight,
      child: VerticalDivider(color: colorScheme.outlineVariant, width: 1),
    );
  }
}

final class _MetricItem extends StatelessWidget {
  const _MetricItem({required this.value, required this.label, this.unit});

  final String value;
  final String label;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final unit = this.unit;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            RunZoneTitleMediumLabel(value),
            if (unit != null) RunZoneLabelMediumLabel(' $unit', color: colorScheme.onSurfaceVariant),
          ],
        ),
        RunZoneBodySmallLabel(label, color: colorScheme.onSurfaceVariant),
      ],
    );
  }
}
