part of 'workout_live_bloc.dart';

sealed class WorkoutLiveState extends Equatable {
  const WorkoutLiveState();
}

final class WorkoutLiveCountingDown extends WorkoutLiveState {
  const WorkoutLiveCountingDown({required this.countIndex});

  final int countIndex;

  @override
  List<Object?> get props => [countIndex];
}

final class WorkoutLiveRunning extends WorkoutLiveState {
  const WorkoutLiveRunning({
    required this.session,
    required this.activeStartedAt,
    this.treadmillSpeedKilometersPerHour,
    this.isTreadmillManualMode,
  });

  final WorkoutSession session;
  final DateTime activeStartedAt;
  final double? treadmillSpeedKilometersPerHour;
  final bool? isTreadmillManualMode;

  HeartRateMeasurement? get latestHeartRateMeasurement => session.latestHeartRateMeasurement;
  HeartRateZone? get latestHeartRateZone => session.latestHeartRateZone;

  bool? get isInTargetHeartRateZone {
    final zone = latestHeartRateZone;
    if (zone == null) return null;
    return zone == session.targetHeartRateZone;
  }

  Duration elapsedAt(DateTime now) => session.elapsed + now.difference(activeStartedAt);

  WorkoutLiveRunning copyWith({
    WorkoutSession? session,
    DateTime? activeStartedAt,
    double? treadmillSpeedKilometersPerHour,
    bool? isTreadmillManualMode,
  }) {
    return WorkoutLiveRunning(
      session: session ?? this.session,
      activeStartedAt: activeStartedAt ?? this.activeStartedAt,
      treadmillSpeedKilometersPerHour:
          treadmillSpeedKilometersPerHour ?? this.treadmillSpeedKilometersPerHour,
      isTreadmillManualMode: isTreadmillManualMode ?? this.isTreadmillManualMode,
    );
  }

  @override
  List<Object?> get props => [
    session,
    activeStartedAt,
    treadmillSpeedKilometersPerHour,
    isTreadmillManualMode,
  ];
}

final class WorkoutLivePaused extends WorkoutLiveState {
  const WorkoutLivePaused({
    required this.session,
    this.treadmillSpeedKilometersPerHour,
    this.isTreadmillManualMode,
  });

  final WorkoutSession session;
  final double? treadmillSpeedKilometersPerHour;
  final bool? isTreadmillManualMode;

  WorkoutLivePaused copyWith({
    WorkoutSession? session,
    double? treadmillSpeedKilometersPerHour,
    bool? isTreadmillManualMode,
  }) {
    return WorkoutLivePaused(
      session: session ?? this.session,
      treadmillSpeedKilometersPerHour:
          treadmillSpeedKilometersPerHour ?? this.treadmillSpeedKilometersPerHour,
      isTreadmillManualMode: isTreadmillManualMode ?? this.isTreadmillManualMode,
    );
  }

  @override
  List<Object?> get props => [session, treadmillSpeedKilometersPerHour, isTreadmillManualMode];
}

final class WorkoutLiveFinished extends WorkoutLiveState {
  const WorkoutLiveFinished({required this.session});

  final WorkoutSession session;

  @override
  List<Object?> get props => [session];
}
