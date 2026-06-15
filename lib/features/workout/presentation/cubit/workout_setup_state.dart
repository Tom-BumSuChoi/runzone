part of 'workout_setup_cubit.dart';

enum WorkoutEnvironment { indoor, outdoor }

final class WorkoutSetupState extends Equatable {
  const WorkoutSetupState({required this.environment});

  factory WorkoutSetupState.initial() {
    return const WorkoutSetupState(environment: WorkoutEnvironment.indoor);
  }

  final WorkoutEnvironment environment;

  @override
  List<Object?> get props => [environment];
}
