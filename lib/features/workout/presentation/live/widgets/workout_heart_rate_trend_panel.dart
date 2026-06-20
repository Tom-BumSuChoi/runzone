import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../../../core/design_system/widgets/chart/run_zone_heart_rate_trend_chart.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../heart_rate/domain/heart_rate_measurement.dart';
import '../../../../heart_rate/domain/heart_rate_zone.dart';

final class WorkoutHeartRateTrendPanel extends StatelessWidget {
  const WorkoutHeartRateTrendPanel({
    required this.heartRateMeasurements,
    required this.heartRateZoneTable,
    required this.targetHeartRateZone,
    super.key,
  });

  static const _heartRateTrendSampleCount = 60;
  static const _heartRateTrendTrailingLabel = '최근 $_heartRateTrendSampleCount초';

  final List<HeartRateMeasurement> heartRateMeasurements;
  final HeartRateZoneTable heartRateZoneTable;
  final HeartRateZone targetHeartRateZone;

  @override
  Widget build(BuildContext context) {
    return RunZoneCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const RunZoneLabelSmallLabel('심박 추이'), RunZoneLabelSmallLabel(_heartRateTrendTrailingLabel)],
          ),
          AppSpacing.controlGroupSpacer,
          RunZoneHeartRateTrendChart(
            heartRates: _recentHeartRates(),
            heartRateZoneTable: heartRateZoneTable,
            targetHeartRateZone: targetHeartRateZone,
          ),
        ],
      ),
    );
  }

  List<int?> _recentHeartRates() {
    final heartRates = List<int?>.filled(_heartRateTrendSampleCount, null);
    if (heartRateMeasurements.isEmpty) {
      return heartRates;
    }

    final recentMeasurements = heartRateMeasurements.length <= _heartRateTrendSampleCount
        ? heartRateMeasurements
        : heartRateMeasurements.sublist(heartRateMeasurements.length - _heartRateTrendSampleCount);
    final startIndex = _heartRateTrendSampleCount - recentMeasurements.length;
    for (var index = 0; index < recentMeasurements.length; index += 1) {
      heartRates[startIndex + index] = recentMeasurements[index].beatsPerMinute;
    }
    return heartRates;
  }
}
