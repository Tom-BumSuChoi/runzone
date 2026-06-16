part of 'workout_setup_cubit.dart';

enum WorkoutEnvironment { indoor, outdoor }

enum WorkoutTrainingType { zoneTwo, interval, free }

final class WorkoutSetupState extends Equatable {
  const WorkoutSetupState({required this.environment, required this.trainingType, this.isTreadmillConnected = false});

  factory WorkoutSetupState.initial() {
    return const WorkoutSetupState(environment: WorkoutEnvironment.indoor, trainingType: WorkoutTrainingType.zoneTwo);
  }

  final WorkoutEnvironment environment;
  final WorkoutTrainingType trainingType;
  final bool isTreadmillConnected;

  WorkoutSetupState copyWith({
    WorkoutEnvironment? environment,
    WorkoutTrainingType? trainingType,
    bool? isTreadmillConnected,
  }) {
    return WorkoutSetupState(
      environment: environment ?? this.environment,
      trainingType: trainingType ?? this.trainingType,
      isTreadmillConnected: isTreadmillConnected ?? this.isTreadmillConnected,
    );
  }

  @override
  List<Object?> get props => [environment, trainingType, isTreadmillConnected];
}
