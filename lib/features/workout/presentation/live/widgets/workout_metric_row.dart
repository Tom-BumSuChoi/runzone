import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/label/run_zone_display_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';

final class WorkoutMetricRow extends StatelessWidget {
  const WorkoutMetricRow({required this.elapsedTime, required this.remainingTime, required this.distance, super.key});

  final String elapsedTime;
  final String remainingTime;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _WorkoutMetric(value: elapsedTime, label: '경과'),
        ),
        const SizedBox(width: AppSpacing.chipGap),
        Expanded(
          child: _WorkoutMetric(value: remainingTime, label: '남음'),
        ),
        const SizedBox(width: AppSpacing.chipGap),
        Expanded(
          child: _WorkoutMetric(value: distance, label: 'km'),
        ),
      ],
    );
  }
}

final class _WorkoutMetric extends StatelessWidget {
  const _WorkoutMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RunZoneDisplaySmallLabel(value, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.controlLabelGap),
        RunZoneLabelSmallLabel(label, textAlign: TextAlign.center),
      ],
    );
  }
}
