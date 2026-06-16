import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/heart_rate_zone.dart';
import '../../domain/workout_duration_goal.dart';

part 'workout_setup_state.dart';

final class WorkoutSetupCubit extends Cubit<WorkoutSetupState> {
  WorkoutSetupCubit() : super(WorkoutSetupState.initial());

  void changeEnvironment(WorkoutEnvironment environment) {
    emit(state.copyWith(environment: environment));
  }

  void selectTargetZonePlan() {
    emit(state.copyWith(plan: TargetZoneWorkoutPlan.initial));
  }

  void selectIntervalPlan() {
    emit(state.copyWith(plan: IntervalWorkoutPlan.initial));
  }

  void selectFreePlan() {
    emit(state.copyWith(plan: FreeWorkoutPlan.initial));
  }

  void toggleTreadmillConnection() {
    emit(state.copyWith(isTreadmillConnected: !state.isTreadmillConnected));
  }

  void toggleAutoPace() {
    emit(state.copyWith(isAutoPaceEnabled: !state.isAutoPaceEnabled));
  }

  void toggleZoneAlert() {
    emit(state.copyWith(isZoneAlertEnabled: !state.isZoneAlertEnabled));
  }

  void increaseTargetZoneDuration() {
    final plan = state.plan;

    if (plan is! TargetZoneWorkoutPlan) {
      return;
    }

    final nextDurationGoal = plan.durationGoal.increase();

    if (nextDurationGoal == plan.durationGoal) {
      return;
    }

    emit(
      state.copyWith(
        plan: TargetZoneWorkoutPlan(durationGoal: nextDurationGoal, targetHeartRateZone: plan.targetHeartRateZone),
      ),
    );
  }

  void decreaseTargetZoneDuration() {
    final plan = state.plan;

    if (plan is! TargetZoneWorkoutPlan) {
      return;
    }

    final nextDurationGoal = plan.durationGoal.decrease();

    if (nextDurationGoal == plan.durationGoal) {
      return;
    }

    emit(
      state.copyWith(
        plan: TargetZoneWorkoutPlan(durationGoal: nextDurationGoal, targetHeartRateZone: plan.targetHeartRateZone),
      ),
    );
  }

  void increaseTargetHeartRateZone() {
    final plan = state.plan;

    if (plan is! TargetZoneWorkoutPlan) {
      return;
    }

    final nextHeartRateZone = plan.targetHeartRateZone.increase();

    if (nextHeartRateZone == plan.targetHeartRateZone) {
      return;
    }

    emit(
      state.copyWith(
        plan: TargetZoneWorkoutPlan(durationGoal: plan.durationGoal, targetHeartRateZone: nextHeartRateZone),
      ),
    );
  }

  void decreaseTargetHeartRateZone() {
    final plan = state.plan;

    if (plan is! TargetZoneWorkoutPlan) {
      return;
    }

    final nextHeartRateZone = plan.targetHeartRateZone.decrease();

    if (nextHeartRateZone == plan.targetHeartRateZone) {
      return;
    }

    emit(
      state.copyWith(
        plan: TargetZoneWorkoutPlan(durationGoal: plan.durationGoal, targetHeartRateZone: nextHeartRateZone),
      ),
    );
  }
}
