import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/workout_session.dart';

part 'workout_session_event.dart';
part 'workout_session_state.dart';

final class WorkoutSessionBloc extends Bloc<WorkoutSessionEvent, WorkoutSessionState> {
  WorkoutSessionBloc({DateTime Function()? now, Stream<void> Function()? createTicker})
    : _now = now ?? DateTime.now,
      _createTicker = createTicker ?? (() => Stream<void>.periodic(const Duration(seconds: 1), (_) {})),
      super(WorkoutSessionState.initial()) {
    on<WorkoutSessionStarted>(_onStarted);
    on<WorkoutSessionPaused>(_onPaused);
    on<WorkoutSessionResumed>(_onResumed);
    on<WorkoutSessionEnded>(_onEnded);
    on<_WorkoutSessionTicked>(_onTicked);
  }

  final DateTime Function() _now;
  final Stream<void> Function() _createTicker;
  StreamSubscription<void>? _tickerSubscription;

  void _onStarted(WorkoutSessionStarted event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession session = state.session;
    if (session is! ReadyWorkoutSession) {
      return;
    }

    final DateTime now = _now();
    final RunningWorkoutSession startedSession = session.start(now);
    emit(WorkoutSessionState(session: startedSession, elapsed: startedSession.elapsedAt(now)));
    _startTicker();
  }

  void _onPaused(WorkoutSessionPaused event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession session = state.session;
    if (session is! RunningWorkoutSession) {
      return;
    }

    final DateTime now = _now();
    _stopTicker();
    final PausedWorkoutSession pausedSession = session.pause(now);
    emit(WorkoutSessionState(session: pausedSession, elapsed: pausedSession.elapsedAt(now)));
  }

  void _onResumed(WorkoutSessionResumed event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession session = state.session;
    if (session is! PausedWorkoutSession) {
      return;
    }

    final DateTime now = _now();
    final RunningWorkoutSession resumedSession = session.resume(now);
    emit(WorkoutSessionState(session: resumedSession, elapsed: resumedSession.elapsedAt(now)));
    _startTicker();
  }

  void _onEnded(WorkoutSessionEnded event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession session = state.session;
    final DateTime now = _now();

    switch (session) {
      case RunningWorkoutSession():
        _stopTicker();
        final EndedWorkoutSession endedSession = session.end(now);
        emit(WorkoutSessionState(session: endedSession, elapsed: endedSession.elapsedAt(now)));
      case PausedWorkoutSession():
        final EndedWorkoutSession endedSession = session.end(now);
        emit(WorkoutSessionState(session: endedSession, elapsed: endedSession.elapsedAt(now)));
      case ReadyWorkoutSession() || EndedWorkoutSession():
        return;
    }
  }

  void _onTicked(_WorkoutSessionTicked event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession session = state.session;
    if (session is RunningWorkoutSession) {
      emit(state.copyWith(elapsed: session.elapsedAt(_now())));
    }
  }

  void _startTicker() {
    _stopTicker();
    _tickerSubscription = _createTicker().listen((_) => add(const _WorkoutSessionTicked()));
  }

  void _stopTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = null;
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
