import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../heart_rate/domain/heart_rate_measurement.dart';
import '../../../heart_rate/domain/heart_rate_monitor.dart';
import '../../../heart_rate/domain/heart_rate_zone.dart';
import '../../../treadmill/domain/treadmill_device.dart';
import '../../../treadmill/domain/treadmill_snapshot.dart';
import '../../domain/workout_environment.dart';
import '../../domain/workout_plan.dart';
import '../../domain/workout_session.dart';

part 'workout_session_event.dart';
part 'workout_session_state.dart';

final class WorkoutSessionBloc extends Bloc<WorkoutSessionEvent, WorkoutSessionState> {
  static const WorkoutSessionCountdownStep _countdownStartStep = WorkoutSessionCountdownStep.three;

  WorkoutSessionBloc({
    required this.heartRateMonitor,
    required this.treadmillDevice,
    required HeartRateZoneTable heartRateZoneTable,
    DateTime Function()? now,
    Stream<void> Function()? createTicker,
  }) : _now = now ?? DateTime.now,
       _createTicker = createTicker ?? (() => Stream<void>.periodic(const Duration(seconds: 1), (_) {})),
       super(WorkoutSessionIdleState(heartRateZoneTable: heartRateZoneTable)) {
    on<WorkoutSessionStarted>(_onStarted);
    on<WorkoutSessionTreadmillSpeedDecreased>(_onTreadmillSpeedDecreased);
    on<WorkoutSessionTreadmillSpeedIncreased>(_onTreadmillSpeedIncreased);
    on<WorkoutSessionTreadmillAutomaticModeEnabled>(_onTreadmillAutomaticModeEnabled);
    on<WorkoutSessionPaused>(_onPaused);
    on<WorkoutSessionResumed>(_onResumed);
    on<WorkoutSessionEnded>(_onEnded);
    on<_WorkoutSessionTicked>(_onTicked);
  }

  final DateTime Function() _now;
  final Stream<void> Function() _createTicker;
  final HeartRateMonitor heartRateMonitor;
  final TreadmillDevice treadmillDevice;
  StreamSubscription<void>? _tickerSubscription;

  void _onStarted(WorkoutSessionStarted event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSessionState currentState = state;
    switch (currentState) {
      case WorkoutSessionIdleState() || WorkoutSessionEndedState():
        break;
      case WorkoutSessionCountdownState() || WorkoutSessionRunningState() || WorkoutSessionPausedState():
        return;
    }

    final TreadmillSnapshot treadmillSnapshot = treadmillDevice.read();
    emit(
      WorkoutSessionCountdownState(
        heartRateZoneTable: currentState.heartRateZoneTable,
        session: event.session,
        treadmillSpeedKilometersPerHour: treadmillSnapshot.speedKilometersPerHour,
        isTreadmillManualMode: treadmillSnapshot.isManualMode || event.session.plan is FreeWorkoutPlan || !event.isAutoPaceEnabled,
        step: _countdownStartStep,
      ),
    );
    _startTicker();
  }

  void _onTreadmillSpeedDecreased(WorkoutSessionTreadmillSpeedDecreased event, Emitter<WorkoutSessionState> emit) {
    _updateRunningTreadmillState(emit, treadmillDevice.decreaseSpeed);
  }

  void _onTreadmillSpeedIncreased(WorkoutSessionTreadmillSpeedIncreased event, Emitter<WorkoutSessionState> emit) {
    _updateRunningTreadmillState(emit, treadmillDevice.increaseSpeed);
  }

  void _onTreadmillAutomaticModeEnabled(
    WorkoutSessionTreadmillAutomaticModeEnabled event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateRunningTreadmillState(emit, treadmillDevice.enableAutomaticMode);
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
        treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: currentState.isTreadmillManualMode,
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
        treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: currentState.isTreadmillManualMode,
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
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
          ),
        );
      case WorkoutSessionPausedState():
        emit(
          WorkoutSessionEndedState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session.finish(endedAt: currentState.pausedAt, elapsed: currentState.session.elapsed),
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
          ),
        );
      case WorkoutSessionIdleState() || WorkoutSessionCountdownState() || WorkoutSessionEndedState():
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
      case WorkoutSessionIdleState() || WorkoutSessionPausedState() || WorkoutSessionEndedState():
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
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
            step: WorkoutSessionCountdownStep.two,
          ),
        );
      case WorkoutSessionCountdownStep.two:
        emit(
          WorkoutSessionCountdownState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session,
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
            step: WorkoutSessionCountdownStep.one,
          ),
        );
      case WorkoutSessionCountdownStep.one:
        emit(
          WorkoutSessionCountdownState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session,
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
            step: WorkoutSessionCountdownStep.go,
          ),
        );
      case WorkoutSessionCountdownStep.go:
        final DateTime now = _now();
        emit(
          WorkoutSessionRunningState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session,
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
            activeStartedAt: now,
          ),
        );
    }
  }

  void _tickRunning(WorkoutSessionRunningState currentState, Emitter<WorkoutSessionState> emit) {
    final DateTime now = _now();
    final HeartRateMeasurement heartRateMeasurement = heartRateMonitor.measure();
    final TreadmillSnapshot treadmillSnapshot = treadmillDevice.read();
    final double distanceMetersPerTick = currentState.session.environment == WorkoutEnvironment.indoor
        ? treadmillSnapshot.speedKilometersPerHour / 3.6
        : 0.0;
    final WorkoutSession updatedSession = currentState.session
        .copyWith(
          elapsed: currentState.elapsedAt(now),
          totalDistanceMeters: currentState.session.totalDistanceMeters + distanceMetersPerTick,
        )
        .recordHeartRate(heartRateMeasurement);
    emit(
      currentState.copyWith(
        session: updatedSession,
        treadmillSpeedKilometersPerHour: treadmillSnapshot.speedKilometersPerHour,
        isTreadmillManualMode: treadmillSnapshot.isManualMode || currentState.isTreadmillManualMode == true,
        activeStartedAt: now,
      ),
    );
  }

  void _updateRunningTreadmillState(Emitter<WorkoutSessionState> emit, TreadmillSnapshot Function() update) {
    final WorkoutSessionState currentState = state;
    if (currentState is! WorkoutSessionRunningState) {
      return;
    }

    final snapshot = update();
    emit(
      currentState.copyWith(
        treadmillSpeedKilometersPerHour: snapshot.speedKilometersPerHour,
        isTreadmillManualMode: snapshot.isManualMode,
      ),
    );
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
