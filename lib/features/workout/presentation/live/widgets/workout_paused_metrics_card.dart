import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_radius.dart';
import '../../../../../core/design_system/app_sizing.dart';
import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_title_medium_label.dart';

final class WorkoutPausedMetricsCard extends StatelessWidget {
  const WorkoutPausedMetricsCard({required this.elapsed, required this.distance, required this.avgBpm, super.key});

  final String elapsed;
  final String distance;
  final int? avgBpm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.mediumBorder,
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardPadding, horizontal: AppSpacing.cardPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MetricItem(value: elapsed, label: '경과'),
            SizedBox(
              height: AppSizing.metricDividerHeight,
              child: VerticalDivider(color: colorScheme.outlineVariant, width: 1),
            ),
            _MetricItem(value: distance, label: '거리', unit: 'km'),
            SizedBox(
              height: AppSizing.metricDividerHeight,
              child: VerticalDivider(color: colorScheme.outlineVariant, width: 1),
            ),
            _MetricItem(value: avgBpm != null ? '$avgBpm' : '--', label: '평균', unit: 'bpm'),
          ],
        ),
      ),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            RunZoneTitleMediumLabel(value),
            if (unit != null) ...[
              AppSpacing.inlineValueGap,
              RunZoneLabelSmallLabel(unit!, color: colorScheme.onSurfaceVariant),
            ],
          ],
        ),
        AppSpacing.metricLabelGap,
        RunZoneBodySmallLabel(label, color: colorScheme.onSurfaceVariant),
      ],
    );
  }
}
