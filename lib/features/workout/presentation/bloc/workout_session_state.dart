part of 'workout_session_bloc.dart';

sealed class WorkoutSessionState extends Equatable {
  const WorkoutSessionState({required this.heartRateZoneTable});

  final HeartRateZoneTable heartRateZoneTable;

  Duration get elapsed => Duration.zero;
  HeartRateMeasurement? get latestHeartRateMeasurement => null;
  HeartRateZone? get latestHeartRateZone => null;
  bool? get isInTargetHeartRateZone => null;

  @override
  List<Object?> get props => [heartRateZoneTable];
}

final class WorkoutSessionReadyState extends WorkoutSessionState {
  const WorkoutSessionReadyState({required super.heartRateZoneTable});
}

enum WorkoutSessionCountdownStep { three, two, one, go }

final class WorkoutSessionCountdownState extends WorkoutSessionState {
  const WorkoutSessionCountdownState({required super.heartRateZoneTable, required this.step, this.session});

  final WorkoutSessionCountdownStep step;
  final WorkoutSession? session;

  @override
  Duration get elapsed => session?.elapsed ?? Duration.zero;

  @override
  HeartRateMeasurement? get latestHeartRateMeasurement => session?.latestHeartRateMeasurement;

  @override
  HeartRateZone? get latestHeartRateZone => session?.latestHeartRateZone;

  @override
  List<Object?> get props => [heartRateZoneTable, step, session];
}

sealed class SessionBackedWorkoutSessionState extends WorkoutSessionState {
  const SessionBackedWorkoutSessionState({
    required super.heartRateZoneTable,
    required this.session,
    required this.targetHeartRateZone,
  });

  final WorkoutSession session;
  final HeartRateZone targetHeartRateZone;

  @override
  Duration get elapsed => session.elapsed;

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
  List<Object?> get props => [heartRateZoneTable, session, targetHeartRateZone];
}

final class WorkoutSessionRunningState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionRunningState({
    required super.heartRateZoneTable,
    required super.session,
    required super.targetHeartRateZone,
    required this.activeStartedAt,
  });

  final DateTime activeStartedAt;

  Duration elapsedAt(DateTime now) {
    return session.elapsed + now.difference(activeStartedAt);
  }

  WorkoutSessionRunningState copyWith({WorkoutSession? session, DateTime? activeStartedAt}) {
    return WorkoutSessionRunningState(
      heartRateZoneTable: heartRateZoneTable,
      session: session ?? this.session,
      targetHeartRateZone: targetHeartRateZone,
      activeStartedAt: activeStartedAt ?? this.activeStartedAt,
    );
  }

  @override
  List<Object?> get props => [heartRateZoneTable, session, targetHeartRateZone, activeStartedAt];
}

final class WorkoutSessionPausedState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionPausedState({
    required super.heartRateZoneTable,
    required super.session,
    required super.targetHeartRateZone,
    required this.pausedAt,
  });

  final DateTime pausedAt;

  @override
  List<Object?> get props => [heartRateZoneTable, session, targetHeartRateZone, pausedAt];
}

final class WorkoutSessionEndedState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionEndedState({
    required super.heartRateZoneTable,
    required super.session,
    required super.targetHeartRateZone,
  });
}
