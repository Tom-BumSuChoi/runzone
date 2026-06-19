import 'package:flutter/material.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/badge/run_zone_text_pill.dart';
import '../../../../core/design_system/widgets/label/run_zone_headline_medium_label.dart';
import '../../../heart_rate/presentation/heart_rate_zone_display.dart';
import 'bloc/workout_live_bloc.dart';
import 'widgets/workout_paused_icon_ring.dart';
import 'widgets/workout_paused_metrics_card.dart';
import 'widgets/workout_paused_treadmill_hint.dart';

final class WorkoutPausedScreen extends StatelessWidget {
  const WorkoutPausedScreen({required this.state, super.key});

  final WorkoutLivePaused state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final session = state.session;

    final elapsedText = _formatDuration(session.elapsed);
    final distanceText = (session.totalDistanceMeters / 1000).toStringAsFixed(1);
    final measurements = session.heartRateMeasurements;
    final avgBpm = measurements.isEmpty
        ? null
        : (measurements.map((m) => m.beatsPerMinute).reduce((a, b) => a + b) / measurements.length).round();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: AppSpacing.screenInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const WorkoutPausedIconRing(),
                AppSpacing.headerTitleGap,
                RunZoneHeadlineMediumLabel('잠시 멈췄어요'),
                AppSpacing.headlineTagGap,
                RunZoneTextPill('${session.targetHeartRateZone.label} · 일시정지'),
                AppSpacing.sectionGap,
                WorkoutPausedMetricsCard(elapsed: elapsedText, distance: distanceText, avgBpm: avgBpm),
                AppSpacing.footerHintGap,
                const WorkoutPausedTreadmillHint(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
