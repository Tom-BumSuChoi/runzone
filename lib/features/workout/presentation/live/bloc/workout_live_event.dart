part of 'workout_live_bloc.dart';

sealed class WorkoutLiveEvent extends Equatable {
  const WorkoutLiveEvent();

  @override
  List<Object?> get props => const [];
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

final class WorkoutLivePauseButtonTapped extends WorkoutLiveEvent {
  const WorkoutLivePauseButtonTapped();
}

final class WorkoutLiveResumed extends WorkoutLiveEvent {
  const WorkoutLiveResumed();
}

final class WorkoutLiveEnded extends WorkoutLiveEvent {
  const WorkoutLiveEnded();
}

final class _WorkoutLiveCountdownTicked extends WorkoutLiveEvent {
  const _WorkoutLiveCountdownTicked();
}

final class _WorkoutLiveTicked extends WorkoutLiveEvent {
  const _WorkoutLiveTicked();
}
