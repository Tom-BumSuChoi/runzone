import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../heart_rate/domain/heart_rate_measurement.dart';
import '../../../heart_rate/domain/heart_rate_monitor.dart';
import '../../../heart_rate/domain/heart_rate_zone.dart';
import '../../domain/workout_session.dart';

part 'workout_session_event.dart';
part 'workout_session_state.dart';

final class WorkoutSessionBloc extends Bloc<WorkoutSessionEvent, WorkoutSessionState> {
  static const WorkoutSessionCountdownStep _countdownStartStep = WorkoutSessionCountdownStep.three;

  WorkoutSessionBloc({
    required this.heartRateMonitor,
    required HeartRateZoneTable heartRateZoneTable,
    required this.targetHeartRateZone,
    DateTime Function()? now,
    Stream<void> Function()? createTicker,
  }) : _now = now ?? DateTime.now,
       _createTicker = createTicker ?? (() => Stream<void>.periodic(const Duration(seconds: 1), (_) {})),
       super(WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable)) {
    on<WorkoutSessionStarted>(_onStarted);
    on<WorkoutSessionPaused>(_onPaused);
    on<WorkoutSessionResumed>(_onResumed);
    on<WorkoutSessionEnded>(_onEnded);
    on<_WorkoutSessionTicked>(_onTicked);
  }

  final DateTime Function() _now;
  final Stream<void> Function() _createTicker;
  final HeartRateMonitor heartRateMonitor;
  final HeartRateZone targetHeartRateZone;
  StreamSubscription<void>? _tickerSubscription;

  void _onStarted(WorkoutSessionStarted event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSessionState currentState = state;
    if (currentState is! WorkoutSessionReadyState) {
      return;
    }

    emit(WorkoutSessionCountdownState(heartRateZoneTable: currentState.heartRateZoneTable, step: _countdownStartStep));
    _startTicker();
  }

  void _onPaused(WorkoutSessionPaused event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSessionState currentState = state;
    if (currentState is! WorkoutSessionRunningState) {
      return;
    }

    final DateTime now = _now();
    _stopTicker();
    emit(
      WorkoutSessionPausedState(
        heartRateZoneTable: currentState.heartRateZoneTable,
        session: currentState.session.copyWith(elapsed: currentState.elapsedAt(now)),
        targetHeartRateZone: currentState.targetHeartRateZone,
        pausedAt: now,
      ),
    );
  }

  void _onResumed(WorkoutSessionResumed event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSessionState currentState = state;
    if (currentState is! WorkoutSessionPausedState) {
      return;
    }

    emit(
      WorkoutSessionCountdownState(
        heartRateZoneTable: currentState.heartRateZoneTable,
        session: currentState.session,
        step: _countdownStartStep,
      ),
    );
    _startTicker();
  }

  void _onEnded(WorkoutSessionEnded event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSessionState currentState = state;
    final DateTime now = _now();
    switch (currentState) {
      case WorkoutSessionRunningState():
        _stopTicker();
        emit(
          WorkoutSessionEndedState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session.finish(endedAt: now, elapsed: currentState.elapsedAt(now)),
            targetHeartRateZone: currentState.targetHeartRateZone,
          ),
        );
      case WorkoutSessionPausedState():
        emit(
          WorkoutSessionEndedState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session.finish(endedAt: currentState.pausedAt, elapsed: currentState.session.elapsed),
            targetHeartRateZone: currentState.targetHeartRateZone,
          ),
        );
      case WorkoutSessionReadyState() || WorkoutSessionCountdownState() || WorkoutSessionEndedState():
        return;
    }
  }

  void _onTicked(_WorkoutSessionTicked event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSessionState currentState = state;
    switch (currentState) {
      case WorkoutSessionCountdownState():
        _tickCountdown(currentState, emit);
      case WorkoutSessionRunningState():
        _tickRunning(currentState, emit);
      case WorkoutSessionReadyState() || WorkoutSessionPausedState() || WorkoutSessionEndedState():
        return;
    }
  }

  void _tickCountdown(WorkoutSessionCountdownState currentState, Emitter<WorkoutSessionState> emit) {
    switch (currentState.step) {
      case WorkoutSessionCountdownStep.three:
        emit(
          WorkoutSessionCountdownState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session,
            step: WorkoutSessionCountdownStep.two,
          ),
        );
      case WorkoutSessionCountdownStep.two:
        emit(
          WorkoutSessionCountdownState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session,
            step: WorkoutSessionCountdownStep.one,
          ),
        );
      case WorkoutSessionCountdownStep.one:
        emit(
          WorkoutSessionCountdownState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session,
            step: WorkoutSessionCountdownStep.go,
          ),
        );
      case WorkoutSessionCountdownStep.go:
        final DateTime now = _now();
        emit(
          WorkoutSessionRunningState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session:
                currentState.session ??
                WorkoutSession(
                  startedAt: now,
                  elapsed: Duration.zero,
                  heartRateZoneTable: currentState.heartRateZoneTable,
                ),
            targetHeartRateZone: targetHeartRateZone,
            activeStartedAt: now,
          ),
        );
    }
  }

  void _tickRunning(WorkoutSessionRunningState currentState, Emitter<WorkoutSessionState> emit) {
    final DateTime now = _now();
    final HeartRateMeasurement heartRateMeasurement = heartRateMonitor.measure();
    final WorkoutSession updatedSession = currentState.session
        .copyWith(elapsed: currentState.elapsedAt(now))
        .recordHeartRate(heartRateMeasurement);
    emit(currentState.copyWith(session: updatedSession, activeStartedAt: now));
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
