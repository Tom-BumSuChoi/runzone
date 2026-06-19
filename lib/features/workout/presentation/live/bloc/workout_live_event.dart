part of 'workout_live_bloc.dart';

sealed class WorkoutLiveEvent extends Equatable {
  const WorkoutLiveEvent();

  @override
  List<Object?> get props => const [];
}

final class WorkoutLiveStarted extends WorkoutLiveEvent {
  const WorkoutLiveStarted({required this.session, required this.isAutoPaceEnabled});

  final WorkoutSession session;
  final bool isAutoPaceEnabled;

  @override
  List<Object?> get props => [session, isAutoPaceEnabled];
}

final class WorkoutLiveTreadmillSpeedDecreased extends WorkoutLiveEvent {
  const WorkoutLiveTreadmillSpeedDecreased();
}

final class WorkoutLiveTreadmillSpeedIncreased extends WorkoutLiveEvent {
  const WorkoutLiveTreadmillSpeedIncreased();
}

final class WorkoutLiveTreadmillAutomaticModeEnabled extends WorkoutLiveEvent {
  const WorkoutLiveTreadmillAutomaticModeEnabled();
}

final class WorkoutLivePaused extends WorkoutLiveEvent {
  const WorkoutLivePaused();
}

final class WorkoutLiveResumed extends WorkoutLiveEvent {
  const WorkoutLiveResumed();
}

final class WorkoutLiveEnded extends WorkoutLiveEvent {
  const WorkoutLiveEnded();
}

final class _WorkoutLiveTicked extends WorkoutLiveEvent {
  const _WorkoutLiveTicked();
}
