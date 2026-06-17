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
  WorkoutSessionBloc({
    required this.heartRateMonitor,
    required HeartRateZoneTable heartRateZoneTable,
    DateTime Function()? now,
    Stream<void> Function()? createTicker,
  }) : _now = now ?? DateTime.now,
       _createTicker = createTicker ?? (() => Stream<void>.periodic(const Duration(seconds: 1), (_) {})),
       super(WorkoutSessionState.initial(heartRateZoneTable: heartRateZoneTable)) {
    on<WorkoutSessionStarted>(_onStarted);
    on<WorkoutSessionPaused>(_onPaused);
    on<WorkoutSessionResumed>(_onResumed);
    on<WorkoutSessionEnded>(_onEnded);
    on<_WorkoutSessionTicked>(_onTicked);
  }

  final DateTime Function() _now;
  final Stream<void> Function() _createTicker;
  final HeartRateMonitor heartRateMonitor;
  StreamSubscription<void>? _tickerSubscription;
  Duration _accumulatedElapsed = Duration.zero;
  DateTime? _activeStartedAt;

  void _onStarted(WorkoutSessionStarted event, Emitter<WorkoutSessionState> emit) {
    if (state.status != WorkoutSessionStatus.ready) {
      return;
    }

    final DateTime now = _now();
    _accumulatedElapsed = Duration.zero;
    _activeStartedAt = now;
    emit(
      state.copyWith(
        status: WorkoutSessionStatus.running,
        session: WorkoutSession(startedAt: now, elapsed: Duration.zero, heartRateZoneTable: state.heartRateZoneTable),
      ),
    );
    _startTicker();
  }

  void _onPaused(WorkoutSessionPaused event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession? session = state.session;
    if (state.status != WorkoutSessionStatus.running || session == null) {
      return;
    }

    final DateTime now = _now();
    _stopTicker();
    _accumulatedElapsed = _elapsedAt(now);
    _activeStartedAt = null;
    emit(
      state.copyWith(
        status: WorkoutSessionStatus.paused,
        session: session.copyWith(elapsed: _accumulatedElapsed),
      ),
    );
  }

  void _onResumed(WorkoutSessionResumed event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession? session = state.session;
    if (state.status != WorkoutSessionStatus.paused || session == null) {
      return;
    }

    _activeStartedAt = _now();
    emit(state.copyWith(status: WorkoutSessionStatus.running, session: session));
    _startTicker();
  }

  void _onEnded(WorkoutSessionEnded event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession? session = state.session;
    if (session == null) {
      return;
    }

    final DateTime now = _now();
    switch (state.status) {
      case WorkoutSessionStatus.running:
        _stopTicker();
        _accumulatedElapsed = _elapsedAt(now);
        _activeStartedAt = null;
        emit(
          state.copyWith(
            status: WorkoutSessionStatus.ended,
            session: session.finish(endedAt: now, elapsed: _accumulatedElapsed),
          ),
        );
      case WorkoutSessionStatus.paused:
        _activeStartedAt = null;
        _accumulatedElapsed = session.elapsed;
        emit(
          state.copyWith(
            status: WorkoutSessionStatus.ended,
            session: session.finish(endedAt: now, elapsed: _accumulatedElapsed),
          ),
        );
      case WorkoutSessionStatus.ready || WorkoutSessionStatus.ended:
        return;
    }
  }

  void _onTicked(_WorkoutSessionTicked event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSession? session = state.session;
    if (state.status != WorkoutSessionStatus.running || session == null) {
      return;
    }

    final DateTime now = _now();
    final HeartRateMeasurement heartRateMeasurement = heartRateMonitor.measure();
    final WorkoutSession updatedSession = session
        .copyWith(elapsed: _elapsedAt(now))
        .recordHeartRate(heartRateMeasurement);
    emit(state.copyWith(session: updatedSession));
  }

  Duration _elapsedAt(DateTime now) {
    final DateTime? activeStartedAt = _activeStartedAt;
    if (activeStartedAt == null) {
      return _accumulatedElapsed;
    }
    return _accumulatedElapsed + now.difference(activeStartedAt);
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
