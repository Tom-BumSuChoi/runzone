import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import 'bloc/workout_live_bloc.dart';
import 'workout_countdown_screen.dart';
import 'workout_paused_screen.dart';
import 'workout_running_screen.dart';

final class WorkoutLiveScreen extends StatelessWidget {
  const WorkoutLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutLiveBloc, WorkoutLiveState>(
      listenWhen: (previous, current) => current is WorkoutLiveFinished,
      listener: (context, state) {
        if (state is WorkoutLiveFinished) {
          context.pushReplacement(AppRoutes.workoutFeedback, extra: state.session);
        }
      },
      builder: (context, state) => switch (state) {
        WorkoutLiveCountingDown() => WorkoutCountdownScreen(state: state),
        WorkoutLiveRunning() => WorkoutRunningScreen(state: state),
        WorkoutLivePaused() => WorkoutPausedScreen(state: state),
        WorkoutLiveFinished() => const SizedBox.shrink(),
      },
    );
  }
}
