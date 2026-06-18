import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_display_medium_label.dart';
import 'bloc/workout_session_bloc.dart';

final class WorkoutCountdownScreen extends StatefulWidget {
  const WorkoutCountdownScreen({super.key});

  @override
  State<WorkoutCountdownScreen> createState() => _WorkoutCountdownScreenState();
}

final class _WorkoutCountdownScreenState extends State<WorkoutCountdownScreen> {

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<WorkoutSessionBloc, WorkoutSessionState>(
      listener: (context, state) {
        if (state is WorkoutSessionRunningState) {
          context.go(AppRoutes.workoutLive);
        }
      },
      buildWhen: (_, current) => current is WorkoutSessionCountdownState,
      builder: (context, state) {
        final step = switch (state) {
          WorkoutSessionCountdownState(:final step) => step,
          _ => WorkoutSessionCountdownStep.three,
        };
        final label = step == WorkoutSessionCountdownStep.go ? '출발' : '준비';
        final countText = switch (step) {
          WorkoutSessionCountdownStep.three => '3',
          WorkoutSessionCountdownStep.two => '2',
          WorkoutSessionCountdownStep.one => '1',
          WorkoutSessionCountdownStep.go => 'GO',
        };

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  key: ValueKey(countText),
                  tween: Tween(begin: 0.5, end: 1.5),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: RunZoneDisplayLargeLabel(countText, color: colorScheme.primary),
                ),
                AppSpacing.headerTitleGap,
                RunZoneDisplayMediumLabel(label, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        );
      },
    );
  }
}
