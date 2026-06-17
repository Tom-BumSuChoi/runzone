part of 'workout_session_bloc.dart';

sealed class WorkoutSessionState extends Equatable {
  const WorkoutSessionState({required this.heartRateZoneTable});

  final HeartRateZoneTable heartRateZoneTable;

  Duration get elapsed => Duration.zero;
  HeartRateMeasurement? get latestHeartRateMeasurement => null;
  HeartRateZone? get latestHeartRateZone => null;

  @override
  List<Object?> get props => [heartRateZoneTable];
}

final class WorkoutSessionReadyState extends WorkoutSessionState {
  const WorkoutSessionReadyState({required super.heartRateZoneTable});
}

enum WorkoutSessionCountdownStep { three, two, one, go }

final class WorkoutSessionCountdownState extends WorkoutSessionState {
  const WorkoutSessionCountdownState({
    required super.heartRateZoneTable,
    required this.step,
    this.session,
  });

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

sealed class StartedWorkoutSessionState extends WorkoutSessionState {
  const StartedWorkoutSessionState({required super.heartRateZoneTable, required this.session});

  final WorkoutSession session;

  @override
  Duration get elapsed => session.elapsed;

  @override
  HeartRateMeasurement? get latestHeartRateMeasurement => session.latestHeartRateMeasurement;

  @override
  HeartRateZone? get latestHeartRateZone => session.latestHeartRateZone;

  @override
  List<Object?> get props => [heartRateZoneTable, session];
}

final class WorkoutSessionRunningState extends StartedWorkoutSessionState {
  const WorkoutSessionRunningState({
    required super.heartRateZoneTable,
    required super.session,
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
      activeStartedAt: activeStartedAt ?? this.activeStartedAt,
    );
  }

  @override
  List<Object?> get props => [heartRateZoneTable, session, activeStartedAt];
}

final class WorkoutSessionPausedState extends StartedWorkoutSessionState {
  const WorkoutSessionPausedState({required super.heartRateZoneTable, required super.session, required this.pausedAt});

  final DateTime pausedAt;

  @override
  List<Object?> get props => [heartRateZoneTable, session, pausedAt];
}

final class WorkoutSessionEndedState extends StartedWorkoutSessionState {
  const WorkoutSessionEndedState({required super.heartRateZoneTable, required super.session});
}
