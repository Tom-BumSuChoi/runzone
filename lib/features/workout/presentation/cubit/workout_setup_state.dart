part of 'workout_setup_cubit.dart';

enum WorkoutEnvironment { indoor, outdoor }

enum WorkoutTrainingType { zoneTwo, interval, free }

final class WorkoutSetupState extends Equatable {
  const WorkoutSetupState({required this.environment, required this.trainingType});

  factory WorkoutSetupState.initial() {
    return const WorkoutSetupState(environment: WorkoutEnvironment.indoor, trainingType: WorkoutTrainingType.zoneTwo);
  }

  final WorkoutEnvironment environment;
  final WorkoutTrainingType trainingType;

  WorkoutSetupState copyWith({WorkoutEnvironment? environment, WorkoutTrainingType? trainingType}) {
    return WorkoutSetupState(
      environment: environment ?? this.environment,
      trainingType: trainingType ?? this.trainingType,
    );
  }

  @override
  List<Object?> get props => [environment, trainingType];
}
