import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'workout_setup_state.dart';

final class WorkoutSetupCubit extends Cubit<WorkoutSetupState> {
  WorkoutSetupCubit() : super(WorkoutSetupState.initial());

  void changeEnvironment(WorkoutEnvironment environment) {
    emit(WorkoutSetupState(environment: environment));
  }
}
