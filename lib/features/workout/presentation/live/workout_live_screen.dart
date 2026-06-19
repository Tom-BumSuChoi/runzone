import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_color_scheme.dart';
import '../../../../core/design_system/app_sizing.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/badge/run_zone_blinking_badge.dart';
import '../../../../core/design_system/widgets/badge/run_zone_indicator_pill.dart';
import '../../../../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../core/design_system/widgets/progress/run_zone_ring_progress.dart';
import '../../../heart_rate/domain/heart_rate_zone.dart';
import '../../../heart_rate/domain/heart_rate_zone_range.dart';
import 'bloc/workout_live_bloc.dart';
import 'workout_countdown_screen.dart';
import 'widgets/workout_heart_rate_trend_panel.dart';
import 'widgets/workout_live_controls.dart';
import 'widgets/workout_metric_row.dart';
import 'widgets/workout_treadmill_panel.dart';

final class WorkoutLiveScreen extends StatelessWidget {
  const WorkoutLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutLiveBloc, WorkoutLiveState>(
      builder: (context, state) => switch (state) {
        WorkoutLiveCountingDown() => WorkoutCountdownScreen(state: state),
        WorkoutLiveRunning() => _RunningScaffold(state: state),
        WorkoutLivePaused() => _PausedScaffold(state: state),
      },
    );
  }
}

final class _RunningScaffold extends StatelessWidget {
  const _RunningScaffold({required this.state});

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

    final zoneColor = _zoneColor(colorScheme, heartRateZone ?? targetHeartRateZone);
    final zoneLabel = _zoneLabel(heartRateZone ?? targetHeartRateZone);
    final targetRange = _targetRange(heartRateZoneTable, targetHeartRateZone);
    final targetLabel = '목표 ${targetRange.lower}–${targetRange.upper}';
    final treadmillStatusLabel = isTreadmillManualMode == true ? '수동 조작' : 'AUTO · 속도 유지';

    final elapsedText = _formatDuration(state.session.elapsed);
    final remainingDuration = state.session.remainingDuration;
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
                    if (treadmillSpeedKilometersPerHour != null &&
                        isTreadmillManualMode != null) ...[
                      WorkoutTreadmillPanel(
                        speed: treadmillSpeedKilometersPerHour,
                        isManualMode: isTreadmillManualMode,
                        statusLabel: treadmillStatusLabel,
                        onDecrease: () => context
                            .read<WorkoutLiveBloc>()
                            .add(const WorkoutLiveTreadmillSpeedDecreased()),
                        onIncrease: () => context
                            .read<WorkoutLiveBloc>()
                            .add(const WorkoutLiveTreadmillSpeedIncreased()),
                        onResetAutomaticMode: () => context
                            .read<WorkoutLiveBloc>()
                            .add(const WorkoutLiveTreadmillAutomaticModeEnabled()),
                      ),
                      AppSpacing.sectionGap,
                    ],
                    WorkoutHeartRateTrendPanel(
                      heartRateMeasurements: state.session.heartRateMeasurements,
                      heartRateZoneTable: heartRateZoneTable,
                      targetHeartRateZone: targetHeartRateZone,
                    ),
                    AppSpacing.sectionGap,
                    WorkoutMetricRow(
                      elapsedTime: elapsedText,
                      remainingTime: remainingText,
                      distance: distanceText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          WorkoutLiveControls(
            onLap: () {},
            onPause: () =>
                context.read<WorkoutLiveBloc>().add(const WorkoutLivePauseButtonTapped()),
            onStop: () => context.read<WorkoutLiveBloc>().add(const WorkoutLiveEnded()),
          ),
        ],
      ),
    );
  }
}

final class _PausedScaffold extends StatelessWidget {
  const _PausedScaffold({required this.state});

  final WorkoutLivePaused state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final elapsedText = _formatDuration(state.session.elapsed);
    final remainingDuration = state.session.remainingDuration;
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
                    AppSpacing.sectionGap,
                    WorkoutMetricRow(
                      elapsedTime: elapsedText,
                      remainingTime: remainingText,
                      distance: distanceText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          WorkoutLiveControls(
            onLap: () {},
            onPause: () => context.read<WorkoutLiveBloc>().add(const WorkoutLiveResumed()),
            onStop: () => context.read<WorkoutLiveBloc>().add(const WorkoutLiveEnded()),
          ),
        ],
      ),
    );
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

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

String _zoneShortLabel(HeartRateZone zone) {
  return switch (zone) {
    HeartRateZone.zone1 => 'Z1',
    HeartRateZone.zone2 => 'Z2',
    HeartRateZone.zone3 => 'Z3',
    HeartRateZone.zone4 => 'Z4',
    HeartRateZone.zone5 => 'Z5',
  };
}

String _zoneLabel(HeartRateZone zone) {
  return switch (zone) {
    HeartRateZone.zone1 => 'Z1 · 워밍업',
    HeartRateZone.zone2 => 'Z2 · 지구력',
    HeartRateZone.zone3 => 'Z3 · 유산소',
    HeartRateZone.zone4 => 'Z4 · 역치',
    HeartRateZone.zone5 => 'Z5 · 최대',
  };
}

Color _zoneColor(ColorScheme colorScheme, HeartRateZone zone) {
  return switch (zone) {
    HeartRateZone.zone1 => colorScheme.zoneOne,
    HeartRateZone.zone2 => colorScheme.zoneTwo,
    HeartRateZone.zone3 => colorScheme.zoneThree,
    HeartRateZone.zone4 => colorScheme.zoneFour,
    HeartRateZone.zone5 => colorScheme.zoneFive,
  };
}

HeartRateZoneRange _targetRange(HeartRateZoneTable table, HeartRateZone zone) {
  return switch (zone) {
    HeartRateZone.zone1 => table.zone1,
    HeartRateZone.zone2 => table.zone2,
    HeartRateZone.zone3 => table.zone3,
    HeartRateZone.zone4 => table.zone4,
    HeartRateZone.zone5 => table.zone5,
  };
}
