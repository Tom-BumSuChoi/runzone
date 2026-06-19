import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_spacing.dart';
import 'bloc/workout_live_bloc.dart';
import 'widgets/workout_live_controls.dart';
import 'widgets/workout_metric_row.dart';

final class WorkoutPausedScreen extends StatelessWidget {
  const WorkoutPausedScreen({required this.state, super.key});

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

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
