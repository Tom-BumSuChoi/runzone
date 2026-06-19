import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_sizing.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/badge/run_zone_blinking_badge.dart';
import '../../../../core/design_system/widgets/badge/run_zone_indicator_pill.dart';
import '../../../../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../core/design_system/widgets/progress/run_zone_ring_progress.dart';
import '../../../heart_rate/presentation/heart_rate_zone_display.dart';
import 'bloc/workout_live_bloc.dart';
import 'widgets/workout_heart_rate_trend_panel.dart';
import 'widgets/workout_live_controls.dart';
import 'widgets/workout_metric_row.dart';
import 'widgets/workout_treadmill_panel.dart';

final class WorkoutRunningScreen extends StatelessWidget {
  const WorkoutRunningScreen({required this.state, super.key});

  final WorkoutLiveRunning state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final heartRateZoneTable = state.session.heartRateZoneTable;
    final beatsPerMinute = state.latestHeartRateMeasurement?.beatsPerMinute;
    final heartRateZone = state.latestHeartRateZone;
    final targetHeartRateZone = state.session.targetHeartRateZone;
    final isInTargetZone = state.isInTargetHeartRateZone;
    final treadmillSpeedKilometersPerHour = state.treadmillSpeedKilometersPerHour;
    final isTreadmillManualMode = state.isTreadmillManualMode;

    final activeZone = heartRateZone ?? targetHeartRateZone;
    final zoneColor = activeZone.color(colorScheme);
    final zoneLabel = activeZone.label;
    final targetRange = heartRateZoneTable.range(targetHeartRateZone);
    final targetLabel = '목표 ${targetRange.lower}–${targetRange.upper}';
    final treadmillStatusLabel = isTreadmillManualMode == true ? '수동 조작' : 'AUTO · 속도 유지';

    final elapsedText = _formatDuration(state.elapsedDisplayDuration);
    final remainingDuration = state.remainingDisplayDuration;
    final remainingText = remainingDuration == null ? '--:--' : _formatDuration(remainingDuration);
    final distanceText = (state.session.totalDistanceMeters / 1000).toStringAsFixed(2);

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
                    _WorkoutRunningHeader(
                      zoneLabel: isInTargetZone == true
                          ? '${targetHeartRateZone.shortLabel} 유지 중'
                          : '${activeZone.shortLabel} 이동 중',
                      zoneColor: zoneColor,
                    ),
                    AppSpacing.headerTitleGap,
                    _WorkoutHeartRatePanel(
                      beatsPerMinute: beatsPerMinute ?? 0,
                      minimumHeartRate: heartRateZoneTable.zone1.lower,
                      maximumHeartRate: heartRateZoneTable.zone5.upper,
                      zoneLabel: zoneLabel,
                      targetLabel: targetLabel,
                      zoneColor: zoneColor,
                    ),
                    AppSpacing.sectionGap,
                    if (treadmillSpeedKilometersPerHour != null && isTreadmillManualMode != null) ...[
                      WorkoutTreadmillPanel(
                        speed: treadmillSpeedKilometersPerHour,
                        isManualMode: isTreadmillManualMode,
                        statusLabel: treadmillStatusLabel,
                        onDecrease: () =>
                            context.read<WorkoutLiveBloc>().add(const WorkoutLiveTreadmillSpeedDecreased()),
                        onIncrease: () =>
                            context.read<WorkoutLiveBloc>().add(const WorkoutLiveTreadmillSpeedIncreased()),
                        onResetAutomaticMode: () =>
                            context.read<WorkoutLiveBloc>().add(const WorkoutLiveTreadmillAutomaticModeEnabled()),
                      ),
                      AppSpacing.sectionGap,
                    ],
                    WorkoutHeartRateTrendPanel(
                      heartRateMeasurements: state.session.heartRateMeasurements,
                      heartRateZoneTable: heartRateZoneTable,
                      targetHeartRateZone: targetHeartRateZone,
                    ),
                    AppSpacing.sectionGap,
                    WorkoutMetricRow(elapsedTime: elapsedText, remainingTime: remainingText, distance: distanceText),
                  ],
                ),
              ),
            ),
          ),
          WorkoutLiveControls(
            onLap: () {},
            onPause: () => context.read<WorkoutLiveBloc>().add(const WorkoutLivePauseButtonTapped()),
            onStop: () => context.read<WorkoutLiveBloc>().add(const WorkoutLiveEnded()),
          ),
        ],
      ),
    );
  }
}

final class _WorkoutRunningHeader extends StatelessWidget {
  const _WorkoutRunningHeader({required this.zoneLabel, required this.zoneColor});

  final String zoneLabel;
  final Color zoneColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RunZoneIndicatorPill(label: zoneLabel, color: zoneColor),
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
    required this.zoneColor,
  });

  final int beatsPerMinute;
  final int minimumHeartRate;
  final int maximumHeartRate;
  final String zoneLabel;
  final String targetLabel;
  final Color zoneColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = maximumHeartRate > minimumHeartRate
        ? (beatsPerMinute - minimumHeartRate) / (maximumHeartRate - minimumHeartRate)
        : 0.0;

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

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
