part of 'workout_setup_cubit.dart';

enum WorkoutEnvironment { indoor, outdoor }

sealed class WorkoutPlan extends Equatable {
  const WorkoutPlan();
}

final class TargetZoneWorkoutPlan extends WorkoutPlan {
  static const initial = TargetZoneWorkoutPlan(
    durationGoal: WorkoutDurationGoal(minutes: WorkoutDurationGoal.initialMinutes),
    targetHeartRateZone: HeartRateZone.zone2,
  );

  const TargetZoneWorkoutPlan({required this.durationGoal, required this.targetHeartRateZone});

  final WorkoutDurationGoal durationGoal;
  final HeartRateZone targetHeartRateZone;

  @override
  List<Object?> get props => [durationGoal, targetHeartRateZone];
}

final class IntervalWorkoutPlan extends WorkoutPlan {
  static const initial = IntervalWorkoutPlan(
    warmUpDuration: Duration(minutes: 5),
    highIntensityDistanceMeters: 400,
    recoveryDuration: Duration(seconds: 90),
    repeatCount: 6,
  );

  const IntervalWorkoutPlan({
    required this.warmUpDuration,
    required this.highIntensityDistanceMeters,
    required this.recoveryDuration,
    required this.repeatCount,
  });

  final Duration warmUpDuration;
  final int highIntensityDistanceMeters;
  final Duration recoveryDuration;
  final int repeatCount;

  @override
  List<Object?> get props => [warmUpDuration, highIntensityDistanceMeters, recoveryDuration, repeatCount];
}

final class FreeWorkoutPlan extends WorkoutPlan {
  static const initial = FreeWorkoutPlan();

  const FreeWorkoutPlan();

  @override
  List<Object?> get props => [];
}

final class WorkoutSetupState extends Equatable {
  const WorkoutSetupState({
    required this.environment,
    this.plan = TargetZoneWorkoutPlan.initial,
    this.isHeartRateDeviceConnected = true,
    this.isTreadmillConnected = false,
    this.isAutoPaceEnabled = true,
    this.isZoneAlertEnabled = true,
  });

  factory WorkoutSetupState.initial() {
    return const WorkoutSetupState(environment: WorkoutEnvironment.indoor);
  }

  final WorkoutEnvironment environment;
  final WorkoutPlan plan;
  final bool isHeartRateDeviceConnected;
  final bool isTreadmillConnected;
  final bool isAutoPaceEnabled;
  final bool isZoneAlertEnabled;

  bool get canStart {
    return isHeartRateDeviceConnected && (environment == WorkoutEnvironment.outdoor || isTreadmillConnected);
  }

  WorkoutSetupState copyWith({
    WorkoutEnvironment? environment,
    WorkoutPlan? plan,
    bool? isHeartRateDeviceConnected,
    bool? isTreadmillConnected,
    bool? isAutoPaceEnabled,
    bool? isZoneAlertEnabled,
  }) {
    return WorkoutSetupState(
      environment: environment ?? this.environment,
      plan: plan ?? this.plan,
      isHeartRateDeviceConnected: isHeartRateDeviceConnected ?? this.isHeartRateDeviceConnected,
      isTreadmillConnected: isTreadmillConnected ?? this.isTreadmillConnected,
      isAutoPaceEnabled: isAutoPaceEnabled ?? this.isAutoPaceEnabled,
      isZoneAlertEnabled: isZoneAlertEnabled ?? this.isZoneAlertEnabled,
    );
  }

  @override
  List<Object?> get props => [
    environment,
    plan,
    isHeartRateDeviceConnected,
    isTreadmillConnected,
    isAutoPaceEnabled,
    isZoneAlertEnabled,
  ];
}
