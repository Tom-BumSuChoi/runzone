import 'package:equatable/equatable.dart';

import 'heart_rate_zone.dart';
import 'workout_duration_goal.dart';

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
  static const Duration warmUpDurationStep = Duration(minutes: 1);
  static const int highIntensityDistanceStepMeters = 100;
  static const Duration recoveryDurationStep = Duration(seconds: 15);
  static const int repeatCountStep = 1;

  static const Duration minimumWarmUpDuration = Duration.zero;
  static const int minimumHighIntensityDistanceMeters = highIntensityDistanceStepMeters;
  static const Duration minimumRecoveryDuration = recoveryDurationStep;
  static const int minimumRepeatCount = repeatCountStep;

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

  IntervalWorkoutPlan increaseWarmUpDuration() {
    return copyWith(warmUpDuration: warmUpDuration + warmUpDurationStep);
  }

  IntervalWorkoutPlan decreaseWarmUpDuration() {
    final nextDuration = warmUpDuration - warmUpDurationStep;

    return copyWith(warmUpDuration: nextDuration < minimumWarmUpDuration ? minimumWarmUpDuration : nextDuration);
  }

  IntervalWorkoutPlan increaseHighIntensityDistance() {
    return copyWith(highIntensityDistanceMeters: highIntensityDistanceMeters + highIntensityDistanceStepMeters);
  }

  IntervalWorkoutPlan decreaseHighIntensityDistance() {
    final nextDistanceMeters = highIntensityDistanceMeters - highIntensityDistanceStepMeters;

    return copyWith(
      highIntensityDistanceMeters: nextDistanceMeters < minimumHighIntensityDistanceMeters
          ? minimumHighIntensityDistanceMeters
          : nextDistanceMeters,
    );
  }

  IntervalWorkoutPlan increaseRecoveryDuration() {
    return copyWith(recoveryDuration: recoveryDuration + recoveryDurationStep);
  }

  IntervalWorkoutPlan decreaseRecoveryDuration() {
    final nextDuration = recoveryDuration - recoveryDurationStep;

    return copyWith(recoveryDuration: nextDuration < minimumRecoveryDuration ? minimumRecoveryDuration : nextDuration);
  }

  IntervalWorkoutPlan increaseRepeatCount() {
    return copyWith(repeatCount: repeatCount + repeatCountStep);
  }

  IntervalWorkoutPlan decreaseRepeatCount() {
    final nextRepeatCount = repeatCount - repeatCountStep;

    return copyWith(repeatCount: nextRepeatCount < minimumRepeatCount ? minimumRepeatCount : nextRepeatCount);
  }

  IntervalWorkoutPlan copyWith({
    Duration? warmUpDuration,
    int? highIntensityDistanceMeters,
    Duration? recoveryDuration,
    int? repeatCount,
  }) {
    return IntervalWorkoutPlan(
      warmUpDuration: warmUpDuration ?? this.warmUpDuration,
      highIntensityDistanceMeters: highIntensityDistanceMeters ?? this.highIntensityDistanceMeters,
      recoveryDuration: recoveryDuration ?? this.recoveryDuration,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }

  @override
  List<Object?> get props => [warmUpDuration, highIntensityDistanceMeters, recoveryDuration, repeatCount];
}

final class FreeWorkoutPlan extends WorkoutPlan {
  static const initial = FreeWorkoutPlan();

  const FreeWorkoutPlan();

  @override
  List<Object?> get props => [];
}
