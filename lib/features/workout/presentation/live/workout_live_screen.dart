import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/workout_live_bloc.dart';
import 'workout_countdown_screen.dart';
import 'workout_paused_screen.dart';
import 'workout_running_screen.dart';

final class WorkoutLiveScreen extends StatelessWidget {
  const WorkoutLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutLiveBloc, WorkoutLiveState>(
      builder: (context, state) => switch (state) {
        WorkoutLiveCountingDown() => WorkoutCountdownScreen(state: state),
        WorkoutLiveRunning() => WorkoutRunningScreen(state: state),
        WorkoutLivePaused() => WorkoutPausedScreen(state: state),
      },
    );
  }
}
