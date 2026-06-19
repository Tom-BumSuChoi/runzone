part of 'workout_session_bloc.dart';

sealed class WorkoutSessionState extends Equatable {
  const WorkoutSessionState({required this.heartRateZoneTable});

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

final class WorkoutSessionIdleState extends WorkoutSessionState {
  const WorkoutSessionIdleState({required super.heartRateZoneTable});
}

enum WorkoutSessionCountdownStep { three, two, one, go }

final class WorkoutSessionCountdownState extends WorkoutSessionState {
  const WorkoutSessionCountdownState({
    required super.heartRateZoneTable,
    required this.step,
    required this.session,
    required this.treadmillSpeedKilometersPerHour,
    required this.isTreadmillManualMode,
  });

  final WorkoutSessionCountdownStep step;
  final WorkoutSession session;

  @override
  final double? treadmillSpeedKilometersPerHour;

  @override
  final bool? isTreadmillManualMode;

  @override
  Duration get elapsed => session.elapsed;

  @override
  HeartRateMeasurement? get latestHeartRateMeasurement => session.latestHeartRateMeasurement;

  @override
  HeartRateZone? get latestHeartRateZone => session.latestHeartRateZone;

  @override
  List<Object?> get props => [
    heartRateZoneTable,
    step,
    session,
    treadmillSpeedKilometersPerHour,
    isTreadmillManualMode,
  ];
}

sealed class SessionBackedWorkoutSessionState extends WorkoutSessionState {
  const SessionBackedWorkoutSessionState({
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

final class WorkoutSessionRunningState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionRunningState({
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

  WorkoutSessionRunningState copyWith({
    WorkoutSession? session,
    DateTime? activeStartedAt,
    double? treadmillSpeedKilometersPerHour,
    bool? isTreadmillManualMode,
  }) {
    return WorkoutSessionRunningState(
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

final class WorkoutSessionPausedState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionPausedState({
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

final class WorkoutSessionEndedState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionEndedState({
    required super.heartRateZoneTable,
    required super.session,
    required super.treadmillSpeedKilometersPerHour,
    required super.isTreadmillManualMode,
  });
}
