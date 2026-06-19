import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../heart_rate/domain/heart_rate_measurement.dart';
import '../../../../heart_rate/domain/heart_rate_monitor.dart';
import '../../../../heart_rate/domain/heart_rate_zone.dart';
import '../../../../treadmill/domain/treadmill_device.dart';
import '../../../../treadmill/domain/treadmill_snapshot.dart';
import '../../../domain/workout_environment.dart';
import '../../../domain/workout_plan.dart';
import '../../../domain/workout_session.dart';

part 'workout_live_event.dart';
part 'workout_live_state.dart';

final class WorkoutLiveBloc extends Bloc<WorkoutLiveEvent, WorkoutLiveState> {
  WorkoutLiveBloc({
    required this.heartRateMonitor,
    required this.treadmillDevice,
    required HeartRateZoneTable heartRateZoneTable,
    DateTime Function()? now,
    Stream<void> Function()? createTicker,
  }) : _now = now ?? DateTime.now,
       _createTicker = createTicker ?? (() => Stream<void>.periodic(const Duration(seconds: 1), (_) {})),
       super(WorkoutLiveIdleState(heartRateZoneTable: heartRateZoneTable)) {
    on<WorkoutLiveStarted>(_onStarted);
    on<WorkoutLiveTreadmillSpeedDecreased>(_onTreadmillSpeedDecreased);
    on<WorkoutLiveTreadmillSpeedIncreased>(_onTreadmillSpeedIncreased);
    on<WorkoutLiveTreadmillAutomaticModeEnabled>(_onTreadmillAutomaticModeEnabled);
    on<WorkoutLivePaused>(_onPaused);
    on<WorkoutLiveResumed>(_onResumed);
    on<WorkoutLiveEnded>(_onEnded);
    on<_WorkoutLiveTicked>(_onTicked);
  }

  final DateTime Function() _now;
  final Stream<void> Function() _createTicker;
  final HeartRateMonitor heartRateMonitor;
  final TreadmillDevice treadmillDevice;
  StreamSubscription<void>? _tickerSubscription;

  void _onStarted(WorkoutLiveStarted event, Emitter<WorkoutLiveState> emit) {
    final WorkoutLiveState currentState = state;
    switch (currentState) {
      case WorkoutLiveIdleState() || WorkoutLiveEndedState():
        break;
      case WorkoutLiveRunningState() || WorkoutLivePausedState():
        return;
    }

    final TreadmillSnapshot treadmillSnapshot = treadmillDevice.read();
    emit(
      WorkoutLiveRunningState(
        heartRateZoneTable: currentState.heartRateZoneTable,
        session: event.session,
        treadmillSpeedKilometersPerHour: treadmillSnapshot.speedKilometersPerHour,
        isTreadmillManualMode: treadmillSnapshot.isManualMode || event.session.plan is FreeWorkoutPlan || !event.isAutoPaceEnabled,
        activeStartedAt: _now(),
      ),
    );
    _startTicker();
  }

  void _onTreadmillSpeedDecreased(WorkoutLiveTreadmillSpeedDecreased event, Emitter<WorkoutLiveState> emit) {
    _updateRunningTreadmillState(emit, treadmillDevice.decreaseSpeed);
  }

  void _onTreadmillSpeedIncreased(WorkoutLiveTreadmillSpeedIncreased event, Emitter<WorkoutLiveState> emit) {
    _updateRunningTreadmillState(emit, treadmillDevice.increaseSpeed);
  }

  void _onTreadmillAutomaticModeEnabled(
    WorkoutLiveTreadmillAutomaticModeEnabled event,
    Emitter<WorkoutLiveState> emit,
  ) {
    _updateRunningTreadmillState(emit, treadmillDevice.enableAutomaticMode);
  }

  void _onPaused(WorkoutLivePaused event, Emitter<WorkoutLiveState> emit) {
    final WorkoutLiveState currentState = state;
    if (currentState is! WorkoutLiveRunningState) {
      return;
    }

    final DateTime now = _now();
    _stopTicker();
    emit(
      WorkoutLivePausedState(
        heartRateZoneTable: currentState.heartRateZoneTable,
        session: currentState.session.copyWith(elapsed: currentState.elapsedAt(now)),
        treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: currentState.isTreadmillManualMode,
        pausedAt: now,
      ),
    );
  }

  void _onResumed(WorkoutLiveResumed event, Emitter<WorkoutLiveState> emit) {
    final WorkoutLiveState currentState = state;
    if (currentState is! WorkoutLivePausedState) {
      return;
    }

    emit(
      WorkoutLiveRunningState(
        heartRateZoneTable: currentState.heartRateZoneTable,
        session: currentState.session,
        treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: currentState.isTreadmillManualMode,
        activeStartedAt: _now(),
      ),
    );
    _startTicker();
  }

  void _onEnded(WorkoutLiveEnded event, Emitter<WorkoutLiveState> emit) {
    final WorkoutLiveState currentState = state;
    final DateTime now = _now();
    switch (currentState) {
      case WorkoutLiveRunningState():
        _stopTicker();
        emit(
          WorkoutLiveEndedState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session.finish(endedAt: now, elapsed: currentState.elapsedAt(now)),
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
          ),
        );
      case WorkoutLivePausedState():
        emit(
          WorkoutLiveEndedState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session.finish(endedAt: currentState.pausedAt, elapsed: currentState.session.elapsed),
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
          ),
        );
      case WorkoutLiveIdleState() || WorkoutLiveEndedState():
        return;
    }
  }

  void _onTicked(_WorkoutLiveTicked event, Emitter<WorkoutLiveState> emit) {
    final WorkoutLiveState currentState = state;
    switch (currentState) {
      case WorkoutLiveRunningState():
        _tickRunning(currentState, emit);
      case WorkoutLiveIdleState() || WorkoutLivePausedState() || WorkoutLiveEndedState():
        return;
    }
  }

  void _tickRunning(WorkoutLiveRunningState currentState, Emitter<WorkoutLiveState> emit) {
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

  void _updateRunningTreadmillState(Emitter<WorkoutLiveState> emit, TreadmillSnapshot Function() update) {
    final WorkoutLiveState currentState = state;
    if (currentState is! WorkoutLiveRunningState) {
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
    _tickerSubscription = _createTicker().listen((_) => add(const _WorkoutLiveTicked()));
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
