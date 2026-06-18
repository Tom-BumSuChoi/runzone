import 'package:flutter/material.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../../core/design_system/widgets/chart/run_zone_heart_rate_trend_chart.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../heart_rate/domain/heart_rate_zone.dart';

final class WorkoutHeartRateTrendPanel extends StatelessWidget {
  const WorkoutHeartRateTrendPanel({
    required this.heartRates,
    required this.heartRateZoneTable,
    required this.targetHeartRateZone,
    required this.trailingLabel,
    super.key,
  });

  final List<int> heartRates;
  final HeartRateZoneTable heartRateZoneTable;
  final HeartRateZone targetHeartRateZone;
  final String trailingLabel;

  @override
  Widget build(BuildContext context) {
    return RunZoneCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const RunZoneLabelSmallLabel('심박 추이'), RunZoneLabelSmallLabel(trailingLabel)],
          ),
          AppSpacing.controlGroupSpacer,
          RunZoneHeartRateTrendChart(
            heartRates: heartRates,
            heartRateZoneTable: heartRateZoneTable,
            targetHeartRateZone: targetHeartRateZone,
          ),
        ],
      ),
    );
  }
}
