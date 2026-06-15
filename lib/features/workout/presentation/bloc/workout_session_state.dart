part of 'workout_session_bloc.dart';

final class WorkoutSessionState extends Equatable {
  const WorkoutSessionState({required this.session, required this.elapsed});

  factory WorkoutSessionState.initial() {
    return const WorkoutSessionState(session: ReadyWorkoutSession(), elapsed: Duration.zero);
  }

  final WorkoutSession session;
  final Duration elapsed;

  WorkoutSessionState copyWith({WorkoutSession? session, Duration? elapsed}) {
    return WorkoutSessionState(session: session ?? this.session, elapsed: elapsed ?? this.elapsed);
  }

  @override
  List<Object?> get props => [session, elapsed];
}
