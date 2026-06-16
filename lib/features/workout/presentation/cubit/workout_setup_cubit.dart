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

  void changeTrainingType(WorkoutTrainingType trainingType) {
    emit(state.copyWith(trainingType: trainingType));
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
    emit(state.copyWith(targetZoneDurationGoal: state.targetZoneDurationGoal.increase()));
  }

  void decreaseTargetZoneDuration() {
    emit(state.copyWith(targetZoneDurationGoal: state.targetZoneDurationGoal.decrease()));
  }

  void increaseTargetHeartRateZone() {
    emit(state.copyWith(targetHeartRateZone: state.targetHeartRateZone.increase()));
  }

  void decreaseTargetHeartRateZone() {
    emit(state.copyWith(targetHeartRateZone: state.targetHeartRateZone.decrease()));
  }
}
