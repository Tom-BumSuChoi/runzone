import 'package:flutter/material.dart';

import '../../../core/design_system/app_color_scheme.dart';
import '../../../core/design_system/app_sizing.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/badge/run_zone_blinking_badge.dart';
import '../../../core/design_system/widgets/badge/run_zone_indicator_pill.dart';
import '../../../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../core/design_system/widgets/progress/run_zone_ring_progress.dart';
import '../../heart_rate/domain/heart_rate_zone.dart';
import '../../heart_rate/domain/heart_rate_zone_range.dart';
import 'widgets/workout_heart_rate_trend_panel.dart';
import 'widgets/workout_live_controls.dart';
import 'widgets/workout_metric_row.dart';
import 'widgets/workout_treadmill_panel.dart';

final class WorkoutLiveScreen extends StatelessWidget {
  const WorkoutLiveScreen({super.key});

  static const _heartRates = <int>[
    132,
    133,
    134,
    136,
    137,
    139,
    140,
    142,
    143,
    144,
    144,
    143,
    142,
    141,
    140,
    141,
    142,
    143,
    145,
    146,
    145,
    144,
    143,
    142,
    141,
    140,
    139,
    138,
    139,
    140,
    142,
    143,
    144,
    145,
    146,
    145,
    144,
    143,
    144,
    145,
  ];
  static const _heartRateTrendTrailingLabel = '최근 40초';
  static const _beatsPerMinute = 144;
  static const _minimumHeartRate = 90;
  static const _maximumHeartRate = 186;
  static const _heartRateZoneLabel = 'Z2 · 지구력';
  static const _targetHeartRateLabel = '목표 132–148';
  static const _treadmillSpeedKilometersPerHour = 9.8;
  static const _isTreadmillManualMode = false;
  static const _treadmillStatusLabel = 'AUTO · 속도 유지';
  static const _heartRateZoneTable = HeartRateZoneTable(
    zone1: HeartRateZoneRange(lower: 96, upper: 120),
    zone2: HeartRateZoneRange(lower: 121, upper: 148),
    zone3: HeartRateZoneRange(lower: 149, upper: 160),
    zone4: HeartRateZoneRange(lower: 161, upper: 172),
    zone5: HeartRateZoneRange(lower: 173, upper: 182),
  );
  static const _targetHeartRateZone = HeartRateZone.zone2;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: AppSpacing.screenInsets,
                child: Column(
                  children: [
                    const _WorkoutLiveHeader(),
                    AppSpacing.headerTitleGap,
                    const _WorkoutHeartRatePanel(
                      beatsPerMinute: _beatsPerMinute,
                      minimumHeartRate: _minimumHeartRate,
                      maximumHeartRate: _maximumHeartRate,
                      zoneLabel: _heartRateZoneLabel,
                      targetLabel: _targetHeartRateLabel,
                    ),
                    AppSpacing.sectionGap,
                    WorkoutTreadmillPanel(
                      speed: _treadmillSpeedKilometersPerHour,
                      isManualMode: _isTreadmillManualMode,
                      statusLabel: _treadmillStatusLabel,
                      onDecrease: () {},
                      onIncrease: () {},
                      onResetAutomaticMode: () {},
                    ),
                    AppSpacing.sectionGap,
                    WorkoutHeartRateTrendPanel(
                      heartRates: _heartRates,
                      heartRateZoneTable: _heartRateZoneTable,
                      targetHeartRateZone: _targetHeartRateZone,
                      trailingLabel: _heartRateTrendTrailingLabel,
                    ),
                    AppSpacing.sectionGap,
                    const WorkoutMetricRow(elapsedTime: '0:00', remainingTime: '40:00', distance: '0.00'),
                  ],
                ),
              ),
            ),
          ),
          WorkoutLiveControls(onLap: () {}, onPause: () {}, onStop: () {}),
        ],
      ),
    );
  }
}

final class _WorkoutLiveHeader extends StatelessWidget {
  const _WorkoutLiveHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final zoneColor = colorScheme.zoneTwo;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RunZoneIndicatorPill(label: 'Z2 유지 중', color: zoneColor),
        RunZoneBlinkingBadge(label: '연결됨', color: colorScheme.error),
      ],
    );
  }
}

final class _WorkoutHeartRatePanel extends StatelessWidget {
  const _WorkoutHeartRatePanel({
    required this.beatsPerMinute,
    required this.minimumHeartRate,
    required this.maximumHeartRate,
    required this.zoneLabel,
    required this.targetLabel,
  });

  final int beatsPerMinute;
  final int minimumHeartRate;
  final int maximumHeartRate;
  final String zoneLabel;
  final String targetLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final zoneColor = colorScheme.zoneTwo;
    final progress = (beatsPerMinute - minimumHeartRate) / (maximumHeartRate - minimumHeartRate);

    return RunZoneRingProgress(
      value: progress,
      color: zoneColor,
      size: AppSizing.workoutHeartRateRingSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RunZoneLabelSmallLabel(zoneLabel, color: zoneColor),
          RunZoneDisplayLargeLabel('$beatsPerMinute', color: zoneColor),
          RunZoneLabelMediumLabel('bpm', color: colorScheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.controlLabelGap),
          RunZoneLabelSmallLabel(targetLabel, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
