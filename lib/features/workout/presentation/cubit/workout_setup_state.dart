part of 'workout_setup_cubit.dart';

enum WorkoutEnvironment { indoor, outdoor }

enum WorkoutTrainingType { zoneTwo, interval, free }

final class WorkoutSetupState extends Equatable {
  const WorkoutSetupState({
    required this.environment,
    required this.trainingType,
    this.isHeartRateDeviceConnected = true,
    this.isTreadmillConnected = false,
    this.isAutoPaceEnabled = true,
    this.isZoneAlertEnabled = true,
  });

  factory WorkoutSetupState.initial() {
    return const WorkoutSetupState(environment: WorkoutEnvironment.indoor, trainingType: WorkoutTrainingType.zoneTwo);
  }

  final WorkoutEnvironment environment;
  final WorkoutTrainingType trainingType;
  final bool isHeartRateDeviceConnected;
  final bool isTreadmillConnected;
  final bool isAutoPaceEnabled;
  final bool isZoneAlertEnabled;

  bool get canStart {
    return environment == WorkoutEnvironment.outdoor || isTreadmillConnected;
  }

  WorkoutSetupState copyWith({
    WorkoutEnvironment? environment,
    WorkoutTrainingType? trainingType,
    bool? isHeartRateDeviceConnected,
    bool? isTreadmillConnected,
    bool? isAutoPaceEnabled,
    bool? isZoneAlertEnabled,
  }) {
    return WorkoutSetupState(
      environment: environment ?? this.environment,
      trainingType: trainingType ?? this.trainingType,
      isHeartRateDeviceConnected: isHeartRateDeviceConnected ?? this.isHeartRateDeviceConnected,
      isTreadmillConnected: isTreadmillConnected ?? this.isTreadmillConnected,
      isAutoPaceEnabled: isAutoPaceEnabled ?? this.isAutoPaceEnabled,
      isZoneAlertEnabled: isZoneAlertEnabled ?? this.isZoneAlertEnabled,
    );
  }

  @override
  List<Object?> get props => [
    environment,
    trainingType,
    isHeartRateDeviceConnected,
    isTreadmillConnected,
    isAutoPaceEnabled,
    isZoneAlertEnabled,
  ];
}
