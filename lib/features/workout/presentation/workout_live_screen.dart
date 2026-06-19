import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_color_scheme.dart';
import '../../../core/design_system/app_sizing.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/badge/run_zone_blinking_badge.dart';
import '../../../core/design_system/widgets/badge/run_zone_indicator_pill.dart';
import '../../../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../core/design_system/widgets/progress/run_zone_ring_progress.dart';
import '../../heart_rate/domain/heart_rate_measurement.dart';
import '../../heart_rate/domain/heart_rate_zone.dart';
import '../../heart_rate/domain/heart_rate_zone_range.dart';
import 'bloc/workout_session_bloc.dart';
import 'widgets/workout_heart_rate_trend_panel.dart';
import 'widgets/workout_live_controls.dart';
import 'widgets/workout_metric_row.dart';
import 'widgets/workout_treadmill_panel.dart';

final class WorkoutLiveScreen extends StatelessWidget {
  const WorkoutLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<WorkoutSessionBloc, WorkoutSessionState>(
      builder: (context, state) {
        final heartRateZoneTable = state.heartRateZoneTable;
        final beatsPerMinute = state.latestHeartRateMeasurement?.beatsPerMinute;
        final heartRateZone = state.latestHeartRateZone;
        final targetHeartRateZone = state is SessionBackedWorkoutSessionState
            ? state.targetHeartRateZone
            : HeartRateZone.zone2;
        final isInTargetZone = state.isInTargetHeartRateZone;
        final elapsed = state.elapsed;
        final treadmillSpeedKilometersPerHour = state.treadmillSpeedKilometersPerHour;
        final isTreadmillManualMode = state.isTreadmillManualMode;

        final zoneColor = _zoneColor(colorScheme, heartRateZone ?? targetHeartRateZone);
        final zoneLabel = _zoneLabel(heartRateZone ?? targetHeartRateZone);
        final targetRange = _targetRange(heartRateZoneTable, targetHeartRateZone);
        final targetLabel = '목표 ${targetRange.lower}–${targetRange.upper}';
        final treadmillStatusLabel = isTreadmillManualMode == true ? '수동 조작' : 'AUTO · 속도 유지';

        final List<HeartRateMeasurement> heartRateMeasurements = state is SessionBackedWorkoutSessionState
            ? state.heartRateMeasurements
            : const <HeartRateMeasurement>[];

        final elapsedText = _formatDuration(elapsed);

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
                        _WorkoutLiveHeader(
                          zoneLabel: isInTargetZone == true
                              ? '${_zoneShortLabel(targetHeartRateZone)} 유지 중'
                              : '${_zoneShortLabel(heartRateZone ?? targetHeartRateZone)} 이동 중',
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
                                context.read<WorkoutSessionBloc>().add(const WorkoutSessionTreadmillSpeedDecreased()),
                            onIncrease: () =>
                                context.read<WorkoutSessionBloc>().add(const WorkoutSessionTreadmillSpeedIncreased()),
                            onResetAutomaticMode: () => context.read<WorkoutSessionBloc>().add(
                              const WorkoutSessionTreadmillAutomaticModeEnabled(),
                            ),
                          ),
                          AppSpacing.sectionGap,
                        ],
                        WorkoutHeartRateTrendPanel(
                          heartRateMeasurements: heartRateMeasurements,
                          heartRateZoneTable: heartRateZoneTable,
                          targetHeartRateZone: targetHeartRateZone,
                        ),
                        AppSpacing.sectionGap,
                        WorkoutMetricRow(elapsedTime: elapsedText, remainingTime: '40:00', distance: '0.00'),
                      ],
                    ),
                  ),
                ),
              ),
              WorkoutLiveControls(
                onLap: () {},
                onPause: () => context.read<WorkoutSessionBloc>().add(const WorkoutSessionPaused()),
                onStop: () => context.read<WorkoutSessionBloc>().add(const WorkoutSessionEnded()),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String _zoneShortLabel(HeartRateZone zone) {
    return switch (zone) {
      HeartRateZone.zone1 => 'Z1',
      HeartRateZone.zone2 => 'Z2',
      HeartRateZone.zone3 => 'Z3',
      HeartRateZone.zone4 => 'Z4',
      HeartRateZone.zone5 => 'Z5',
    };
  }

  static String _zoneLabel(HeartRateZone zone) {
    return switch (zone) {
      HeartRateZone.zone1 => 'Z1 · 워밍업',
      HeartRateZone.zone2 => 'Z2 · 지구력',
      HeartRateZone.zone3 => 'Z3 · 유산소',
      HeartRateZone.zone4 => 'Z4 · 역치',
      HeartRateZone.zone5 => 'Z5 · 최대',
    };
  }

  static Color _zoneColor(ColorScheme colorScheme, HeartRateZone zone) {
    return switch (zone) {
      HeartRateZone.zone1 => colorScheme.zoneOne,
      HeartRateZone.zone2 => colorScheme.zoneTwo,
      HeartRateZone.zone3 => colorScheme.zoneThree,
      HeartRateZone.zone4 => colorScheme.zoneFour,
      HeartRateZone.zone5 => colorScheme.zoneFive,
    };
  }

  static HeartRateZoneRange _targetRange(HeartRateZoneTable table, HeartRateZone zone) {
    return switch (zone) {
      HeartRateZone.zone1 => table.zone1,
      HeartRateZone.zone2 => table.zone2,
      HeartRateZone.zone3 => table.zone3,
      HeartRateZone.zone4 => table.zone4,
      HeartRateZone.zone5 => table.zone5,
    };
  }
}

final class _WorkoutLiveHeader extends StatelessWidget {
  const _WorkoutLiveHeader({required this.zoneLabel, required this.zoneColor});

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
