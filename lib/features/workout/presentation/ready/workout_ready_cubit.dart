import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../heart_rate/domain/heart_rate_zone.dart';
import '../../domain/workout_environment.dart';
import '../../domain/workout_plan.dart';
import '../../domain/workout_session.dart';

final class WorkoutReadyCubit extends Cubit<WorkoutReadyState> {
  WorkoutReadyCubit({required this.heartRateZoneTable, DateTime Function()? now})
    : _now = now ?? DateTime.now,
      super(const WorkoutReadyState());

  final HeartRateZoneTable heartRateZoneTable;
  final DateTime Function() _now;

  WorkoutSession? startWorkoutTapped() {
    if (!state.canStart) {
      return null;
    }

    return WorkoutSession(
      startedAt: _now(),
      elapsed: Duration.zero,
      environment: state.environment,
      plan: state.plan,
      heartRateZoneTable: heartRateZoneTable,
    );
  }

  void indoorEnvironmentTapped() {
    emit(state.copyWith(environment: WorkoutEnvironment.indoor));
  }

  void outdoorEnvironmentTapped() {
    emit(state.copyWith(environment: WorkoutEnvironment.outdoor));
  }

  void targetZonePlanSelected() {
    emit(state.copyWith(plan: TargetZoneWorkoutPlan.initial));
  }

  void intervalPlanSelected() {
    emit(state.copyWith(plan: IntervalWorkoutPlan.initial));
  }

  void freePlanSelected() {
    emit(state.copyWith(plan: FreeWorkoutPlan.initial));
  }

  void treadmillConnectionToggled() {
    emit(state.copyWith(isTreadmillConnected: !state.isTreadmillConnected));
  }

  void autoPaceToggled() {
    emit(state.copyWith(isAutoPaceEnabled: !state.isAutoPaceEnabled));
  }

  void zoneAlertToggled() {
    emit(state.copyWith(isZoneAlertEnabled: !state.isZoneAlertEnabled));
  }

  void targetZoneDurationIncreased() {
    _updateTargetZonePlan((plan) {
      return TargetZoneWorkoutPlan(
        durationGoal: plan.durationGoal.increase(),
        targetHeartRateZone: plan.targetHeartRateZone,
      );
    });
  }

  void targetZoneDurationDecreased() {
    _updateTargetZonePlan((plan) {
      return TargetZoneWorkoutPlan(
        durationGoal: plan.durationGoal.decrease(),
        targetHeartRateZone: plan.targetHeartRateZone,
      );
    });
  }

  void targetHeartRateZoneIncreased() {
    _updateTargetZonePlan((plan) {
      return TargetZoneWorkoutPlan(
        durationGoal: plan.durationGoal,
        targetHeartRateZone: plan.targetHeartRateZone.increase(),
      );
    });
  }

  void targetHeartRateZoneDecreased() {
    _updateTargetZonePlan((plan) {
      return TargetZoneWorkoutPlan(
        durationGoal: plan.durationGoal,
        targetHeartRateZone: plan.targetHeartRateZone.decrease(),
      );
    });
  }

  void intervalWarmUpDurationIncreased() {
    _updateIntervalPlan((plan) => plan.increaseWarmUpDuration());
  }

  void intervalWarmUpDurationDecreased() {
    _updateIntervalPlan((plan) => plan.decreaseWarmUpDuration());
  }

  void intervalHighIntensityDistanceIncreased() {
    _updateIntervalPlan((plan) => plan.increaseHighIntensityDistance());
  }

  void intervalHighIntensityDistanceDecreased() {
    _updateIntervalPlan((plan) => plan.decreaseHighIntensityDistance());
  }

  void intervalRecoveryDurationIncreased() {
    _updateIntervalPlan((plan) => plan.increaseRecoveryDuration());
  }

  void intervalRecoveryDurationDecreased() {
    _updateIntervalPlan((plan) => plan.decreaseRecoveryDuration());
  }

  void intervalRepeatCountIncreased() {
    _updateIntervalPlan((plan) => plan.increaseRepeatCount());
  }

  void intervalRepeatCountDecreased() {
    _updateIntervalPlan((plan) => plan.decreaseRepeatCount());
  }

  void _updateTargetZonePlan(TargetZoneWorkoutPlan Function(TargetZoneWorkoutPlan plan) update) {
    final plan = state.plan;
    if (plan is! TargetZoneWorkoutPlan) {
      return;
    }

    final nextPlan = update(plan);
    if (nextPlan == plan) {
      return;
    }

    emit(state.copyWith(plan: nextPlan));
  }

  void _updateIntervalPlan(IntervalWorkoutPlan Function(IntervalWorkoutPlan plan) update) {
    final plan = state.plan;
    if (plan is! IntervalWorkoutPlan) {
      return;
    }

    final nextPlan = update(plan);
    if (nextPlan == plan) {
      return;
    }

    emit(state.copyWith(plan: nextPlan));
  }
}

final class WorkoutReadyState extends Equatable {
  const WorkoutReadyState({
    this.environment = WorkoutEnvironment.indoor,
    this.plan = TargetZoneWorkoutPlan.initial,
    this.isHeartRateDeviceConnected = true,
    this.isTreadmillConnected = false,
    this.isAutoPaceEnabled = true,
    this.isZoneAlertEnabled = true,
  });

  final WorkoutEnvironment environment;
  final WorkoutPlan plan;
  final bool isHeartRateDeviceConnected;
  final bool isTreadmillConnected;
  final bool isAutoPaceEnabled;
  final bool isZoneAlertEnabled;

  bool get canStart {
    return isHeartRateDeviceConnected && (environment == WorkoutEnvironment.outdoor || isTreadmillConnected);
  }

  WorkoutReadyState copyWith({
    WorkoutEnvironment? environment,
    WorkoutPlan? plan,
    bool? isHeartRateDeviceConnected,
    bool? isTreadmillConnected,
    bool? isAutoPaceEnabled,
    bool? isZoneAlertEnabled,
  }) {
    return WorkoutReadyState(
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
