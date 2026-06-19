part of 'workout_live_bloc.dart';

sealed class WorkoutLiveState extends Equatable {
  const WorkoutLiveState({required this.heartRateZoneTable});

  final HeartRateZoneTable heartRateZoneTable;

  Duration get elapsed => Duration.zero;
  HeartRateMeasurement? get latestHeartRateMeasurement => null;
  HeartRateZone? get latestHeartRateZone => null;
  bool? get isInTargetHeartRateZone => null;
  double? get treadmillSpeedKilometersPerHour => null;
  bool? get isTreadmillManualMode => null;

  @override
  List<Object?> get props => [heartRateZoneTable];
}

final class WorkoutLiveIdleState extends WorkoutLiveState {
  const WorkoutLiveIdleState({required super.heartRateZoneTable});
}

sealed class SessionBackedWorkoutLiveState extends WorkoutLiveState {
  const SessionBackedWorkoutLiveState({
    required super.heartRateZoneTable,
    required this.session,
    required this.treadmillSpeedKilometersPerHour,
    required this.isTreadmillManualMode,
  });

  final WorkoutSession session;

  HeartRateZone get targetHeartRateZone => session.targetHeartRateZone;

  @override
  final double? treadmillSpeedKilometersPerHour;

  @override
  final bool? isTreadmillManualMode;

  @override
  Duration get elapsed => session.elapsed;

  List<HeartRateMeasurement> get heartRateMeasurements => session.heartRateMeasurements;

  @override
  HeartRateMeasurement? get latestHeartRateMeasurement => session.latestHeartRateMeasurement;

  @override
  HeartRateZone? get latestHeartRateZone => session.latestHeartRateZone;

  @override
  bool? get isInTargetHeartRateZone {
    final HeartRateZone? heartRateZone = latestHeartRateZone;
    if (heartRateZone == null) {
      return null;
    }
    return heartRateZone == targetHeartRateZone;
  }

  @override
  List<Object?> get props => [
    heartRateZoneTable,
    session,
    treadmillSpeedKilometersPerHour,
    isTreadmillManualMode,
  ];
}

final class WorkoutLiveRunningState extends SessionBackedWorkoutLiveState {
  const WorkoutLiveRunningState({
    required super.heartRateZoneTable,
    required super.session,
    required super.treadmillSpeedKilometersPerHour,
    required super.isTreadmillManualMode,
    required this.activeStartedAt,
  });

  final DateTime activeStartedAt;

  Duration elapsedAt(DateTime now) {
    return session.elapsed + now.difference(activeStartedAt);
  }

  WorkoutLiveRunningState copyWith({
    WorkoutSession? session,
    DateTime? activeStartedAt,
    double? treadmillSpeedKilometersPerHour,
    bool? isTreadmillManualMode,
  }) {
    return WorkoutLiveRunningState(
      heartRateZoneTable: heartRateZoneTable,
      session: session ?? this.session,
      treadmillSpeedKilometersPerHour: treadmillSpeedKilometersPerHour ?? this.treadmillSpeedKilometersPerHour,
      isTreadmillManualMode: isTreadmillManualMode ?? this.isTreadmillManualMode,
      activeStartedAt: activeStartedAt ?? this.activeStartedAt,
    );
  }

  @override
  List<Object?> get props => [
    heartRateZoneTable,
    session,
    treadmillSpeedKilometersPerHour,
    isTreadmillManualMode,
    activeStartedAt,
  ];
}

final class WorkoutLivePausedState extends SessionBackedWorkoutLiveState {
  const WorkoutLivePausedState({
    required super.heartRateZoneTable,
    required super.session,
    required super.treadmillSpeedKilometersPerHour,
    required super.isTreadmillManualMode,
    required this.pausedAt,
  });

  final DateTime pausedAt;

  @override
  List<Object?> get props => [
    heartRateZoneTable,
    session,
    treadmillSpeedKilometersPerHour,
    isTreadmillManualMode,
    pausedAt,
  ];
}

final class WorkoutLiveEndedState extends SessionBackedWorkoutLiveState {
  const WorkoutLiveEndedState({
    required super.heartRateZoneTable,
    required super.session,
    required super.treadmillSpeedKilometersPerHour,
    required super.isTreadmillManualMode,
  });
}
