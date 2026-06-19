part of 'workout_session_bloc.dart';

sealed class WorkoutSessionEvent extends Equatable {
  const WorkoutSessionEvent();

  @override
  List<Object?> get props => const [];
}

final class WorkoutSessionStarted extends WorkoutSessionEvent {
  const WorkoutSessionStarted({required this.session, required this.isAutoPaceEnabled});

  final WorkoutSession session;
  final bool isAutoPaceEnabled;

  @override
  List<Object?> get props => [session, isAutoPaceEnabled];
}

final class WorkoutSessionTreadmillSpeedDecreased extends WorkoutSessionEvent {
  const WorkoutSessionTreadmillSpeedDecreased();
}

final class WorkoutSessionTreadmillSpeedIncreased extends WorkoutSessionEvent {
  const WorkoutSessionTreadmillSpeedIncreased();
}

final class WorkoutSessionTreadmillAutomaticModeEnabled extends WorkoutSessionEvent {
  const WorkoutSessionTreadmillAutomaticModeEnabled();
}

final class WorkoutSessionPaused extends WorkoutSessionEvent {
  const WorkoutSessionPaused();
}

final class WorkoutSessionResumed extends WorkoutSessionEvent {
  const WorkoutSessionResumed();
}

final class WorkoutSessionEnded extends WorkoutSessionEvent {
  const WorkoutSessionEnded();
}

final class _WorkoutSessionTicked extends WorkoutSessionEvent {
  const _WorkoutSessionTicked();
}
