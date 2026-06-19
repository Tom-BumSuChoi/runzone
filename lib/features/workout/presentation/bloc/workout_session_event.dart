part of 'workout_session_bloc.dart';

sealed class WorkoutSessionEvent extends Equatable {
  const WorkoutSessionEvent();

  @override
  List<Object?> get props => const [];
}

final class WorkoutSessionStarted extends WorkoutSessionEvent {
  const WorkoutSessionStarted();
}

sealed class WorkoutSessionReadyEvent extends WorkoutSessionEvent {
  const WorkoutSessionReadyEvent();
}

final class WorkoutSessionEnvironmentChanged extends WorkoutSessionReadyEvent {
  const WorkoutSessionEnvironmentChanged(this.environment);

  final WorkoutEnvironment environment;

  @override
  List<Object?> get props => [environment];
}

final class WorkoutSessionTargetZonePlanSelected extends WorkoutSessionReadyEvent {
  const WorkoutSessionTargetZonePlanSelected();
}

final class WorkoutSessionIntervalPlanSelected extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalPlanSelected();
}

final class WorkoutSessionFreePlanSelected extends WorkoutSessionReadyEvent {
  const WorkoutSessionFreePlanSelected();
}

final class WorkoutSessionTreadmillConnectionToggled extends WorkoutSessionReadyEvent {
  const WorkoutSessionTreadmillConnectionToggled();
}

final class WorkoutSessionAutoPaceToggled extends WorkoutSessionReadyEvent {
  const WorkoutSessionAutoPaceToggled();
}

final class WorkoutSessionZoneAlertToggled extends WorkoutSessionReadyEvent {
  const WorkoutSessionZoneAlertToggled();
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

final class WorkoutSessionTargetZoneDurationIncreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionTargetZoneDurationIncreased();
}

final class WorkoutSessionTargetZoneDurationDecreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionTargetZoneDurationDecreased();
}

final class WorkoutSessionTargetHeartRateZoneIncreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionTargetHeartRateZoneIncreased();
}

final class WorkoutSessionTargetHeartRateZoneDecreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionTargetHeartRateZoneDecreased();
}

final class WorkoutSessionIntervalWarmUpDurationIncreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalWarmUpDurationIncreased();
}

final class WorkoutSessionIntervalWarmUpDurationDecreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalWarmUpDurationDecreased();
}

final class WorkoutSessionIntervalHighIntensityDistanceIncreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalHighIntensityDistanceIncreased();
}

final class WorkoutSessionIntervalHighIntensityDistanceDecreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalHighIntensityDistanceDecreased();
}

final class WorkoutSessionIntervalRecoveryDurationIncreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalRecoveryDurationIncreased();
}

final class WorkoutSessionIntervalRecoveryDurationDecreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalRecoveryDurationDecreased();
}

final class WorkoutSessionIntervalRepeatCountIncreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalRepeatCountIncreased();
}

final class WorkoutSessionIntervalRepeatCountDecreased extends WorkoutSessionReadyEvent {
  const WorkoutSessionIntervalRepeatCountDecreased();
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
