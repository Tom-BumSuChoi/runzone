import 'package:equatable/equatable.dart';

sealed class WorkoutSession extends Equatable {
  const WorkoutSession();

  Duration elapsedAt(DateTime now);
}

final class ReadyWorkoutSession extends WorkoutSession {
  const ReadyWorkoutSession();

  @override
  List<Object?> get props => [];

  RunningWorkoutSession start(DateTime now) {
    return RunningWorkoutSession._(accumulatedElapsed: .zero, activeStartedAt: now);
  }

  @override
  Duration elapsedAt(DateTime now) => Duration.zero;
}

final class RunningWorkoutSession extends WorkoutSession {
  const RunningWorkoutSession._({required this._accumulatedElapsed, required this._activeStartedAt});

  final Duration _accumulatedElapsed;
  final DateTime _activeStartedAt;

  @override
  List<Object?> get props => [_accumulatedElapsed, _activeStartedAt];

  PausedWorkoutSession pause(DateTime now) {
    return PausedWorkoutSession._(accumulatedElapsed: elapsedAt(now));
  }

  EndedWorkoutSession end(DateTime now) {
    return EndedWorkoutSession._(elapsed: elapsedAt(now));
  }

  @override
  Duration elapsedAt(DateTime now) {
    return _accumulatedElapsed + now.difference(_activeStartedAt);
  }
}

final class PausedWorkoutSession extends WorkoutSession {
  const PausedWorkoutSession._({required this._accumulatedElapsed});

  final Duration _accumulatedElapsed;

  @override
  List<Object?> get props => [_accumulatedElapsed];

  RunningWorkoutSession resume(DateTime now) {
    return RunningWorkoutSession._(accumulatedElapsed: _accumulatedElapsed, activeStartedAt: now);
  }

  EndedWorkoutSession end(DateTime now) {
    return EndedWorkoutSession._(elapsed: _accumulatedElapsed);
  }

  @override
  Duration elapsedAt(DateTime now) => _accumulatedElapsed;
}

final class EndedWorkoutSession extends WorkoutSession {
  const EndedWorkoutSession._({required this._elapsed});

  final Duration _elapsed;

  @override
  List<Object?> get props => [_elapsed];

  @override
  Duration elapsedAt(DateTime now) => _elapsed;
}
