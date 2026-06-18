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

final class WorkoutSessionReadyState extends WorkoutSessionState {
  const WorkoutSessionReadyState({
    required super.heartRateZoneTable,
    this.environment = WorkoutEnvironment.indoor,
    this.plan = TargetZoneWorkoutPlan.initial,
    this.isHeartRateDeviceConnected = true,
    this.isTreadmillConnected = false,
    this.isAutoPaceEnabled = true,
    this.isZoneAlertEnabled = true,
  });

  final WorkoutEnvironment environment;
  final WorkoutPlan plan;
  final bool isHeartRateDeviceConnected;
  final bool isTreadmillConnected;
  final bool isAutoPaceEnabled;
  final bool isZoneAlertEnabled;

  bool get canStart {
    return isHeartRateDeviceConnected && (environment == WorkoutEnvironment.outdoor || isTreadmillConnected);
  }

  WorkoutSessionReadyState copyWith({
    WorkoutEnvironment? environment,
    WorkoutPlan? plan,
    bool? isHeartRateDeviceConnected,
    bool? isTreadmillConnected,
    bool? isAutoPaceEnabled,
    bool? isZoneAlertEnabled,
  }) {
    return WorkoutSessionReadyState(
      heartRateZoneTable: heartRateZoneTable,
      environment: environment ?? this.environment,
      plan: plan ?? this.plan,
      isHeartRateDeviceConnected: isHeartRateDeviceConnected ?? this.isHeartRateDeviceConnected,
      isTreadmillConnected: isTreadmillConnected ?? this.isTreadmillConnected,
      isAutoPaceEnabled: isAutoPaceEnabled ?? this.isAutoPaceEnabled,
      isZoneAlertEnabled: isZoneAlertEnabled ?? this.isZoneAlertEnabled,
    );
  }

  @override
  List<Object?> get props => [
    heartRateZoneTable,
    environment,
    plan,
    isHeartRateDeviceConnected,
    isTreadmillConnected,
    isAutoPaceEnabled,
    isZoneAlertEnabled,
  ];
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
    required this.targetHeartRateZone,
    required this.treadmillSpeedKilometersPerHour,
    required this.isTreadmillManualMode,
  });

  final WorkoutSession session;
  final HeartRateZone targetHeartRateZone;

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
    targetHeartRateZone,
    treadmillSpeedKilometersPerHour,
    isTreadmillManualMode,
  ];
}

final class WorkoutSessionRunningState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionRunningState({
    required super.heartRateZoneTable,
    required super.session,
    required super.targetHeartRateZone,
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
      targetHeartRateZone: targetHeartRateZone,
      treadmillSpeedKilometersPerHour: treadmillSpeedKilometersPerHour ?? this.treadmillSpeedKilometersPerHour,
      isTreadmillManualMode: isTreadmillManualMode ?? this.isTreadmillManualMode,
      activeStartedAt: activeStartedAt ?? this.activeStartedAt,
    );
  }

  @override
  List<Object?> get props => [
    heartRateZoneTable,
    session,
    targetHeartRateZone,
    treadmillSpeedKilometersPerHour,
    isTreadmillManualMode,
    activeStartedAt,
  ];
}

final class WorkoutSessionPausedState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionPausedState({
    required super.heartRateZoneTable,
    required super.session,
    required super.targetHeartRateZone,
    required super.treadmillSpeedKilometersPerHour,
    required super.isTreadmillManualMode,
    required this.pausedAt,
  });

  final DateTime pausedAt;

  @override
  List<Object?> get props => [
    heartRateZoneTable,
    session,
    targetHeartRateZone,
    treadmillSpeedKilometersPerHour,
    isTreadmillManualMode,
    pausedAt,
  ];
}

final class WorkoutSessionEndedState extends SessionBackedWorkoutSessionState {
  const WorkoutSessionEndedState({
    required super.heartRateZoneTable,
    required super.session,
    required super.targetHeartRateZone,
    required super.treadmillSpeedKilometersPerHour,
    required super.isTreadmillManualMode,
  });
}
