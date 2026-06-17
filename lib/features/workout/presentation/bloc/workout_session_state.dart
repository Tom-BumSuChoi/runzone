part of 'workout_session_bloc.dart';

enum WorkoutSessionStatus { ready, running, paused, ended }

final class WorkoutSessionState extends Equatable {
  const WorkoutSessionState({required this.status, required this.heartRateZoneTable, this.session});

  const WorkoutSessionState.initial({required HeartRateZoneTable heartRateZoneTable})
    : this(status: WorkoutSessionStatus.ready, heartRateZoneTable: heartRateZoneTable);

  final WorkoutSessionStatus status;
  final HeartRateZoneTable heartRateZoneTable;
  final WorkoutSession? session;

  Duration get elapsed => session?.elapsed ?? Duration.zero;
  HeartRateMeasurement? get latestHeartRateMeasurement => session?.latestHeartRateMeasurement;
  HeartRateZone? get latestHeartRateZone => session?.latestHeartRateZone;

  WorkoutSessionState copyWith({WorkoutSessionStatus? status, WorkoutSession? session}) {
    return WorkoutSessionState(
      status: status ?? this.status,
      heartRateZoneTable: heartRateZoneTable,
      session: session ?? this.session,
    );
  }

  @override
  List<Object?> get props => [status, heartRateZoneTable, session];
}
