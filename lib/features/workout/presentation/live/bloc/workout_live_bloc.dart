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
    required WorkoutSession session,
    required bool isAutoPaceEnabled,
    required this.heartRateMonitor,
    required this.treadmillDevice,
    DateTime Function()? now,
    Stream<void> Function()? createTicker,
  }) : _session = session,
       _isAutoPaceEnabled = isAutoPaceEnabled,
       _now = now ?? DateTime.now,
       _createTicker =
           createTicker ?? (() => Stream<void>.periodic(const Duration(seconds: 1), (_) {})),
       super(const WorkoutLiveCountingDown(countIndex: 0)) {
    on<_WorkoutLiveCountdownTicked>(_onCountdownTicked);
    on<WorkoutLiveTreadmillSpeedDecreased>(_onTreadmillSpeedDecreased);
    on<WorkoutLiveTreadmillSpeedIncreased>(_onTreadmillSpeedIncreased);
    on<WorkoutLiveTreadmillAutomaticModeEnabled>(_onTreadmillAutomaticModeEnabled);
    on<WorkoutLivePauseButtonTapped>(_onPauseButtonTapped);
    on<WorkoutLiveResumed>(_onResumed);
    on<WorkoutLiveEnded>(_onEnded);
    on<_WorkoutLiveTicked>(_onTicked);
    _startCountdownTicker();
  }

  final WorkoutSession _session;
  final bool _isAutoPaceEnabled;
  final DateTime Function() _now;
  final Stream<void> Function() _createTicker;
  final HeartRateMonitor heartRateMonitor;
  final TreadmillDevice treadmillDevice;
  StreamSubscription<void>? _tickerSubscription;

  void _onCountdownTicked(_WorkoutLiveCountdownTicked event, Emitter<WorkoutLiveState> emit) {
    if (state is! WorkoutLiveCountingDown) return;
    final counting = state as WorkoutLiveCountingDown;

    final nextIndex = counting.countIndex + 1;
    if (nextIndex < 4) {
      emit(WorkoutLiveCountingDown(countIndex: nextIndex));
      return;
    }

    final TreadmillSnapshot treadmillSnapshot = treadmillDevice.read();
    _stopTicker();
    emit(
      WorkoutLiveRunning(
        session: _session,
        activeStartedAt: _now(),
        treadmillSpeedKilometersPerHour: treadmillSnapshot.speedKilometersPerHour,
        isTreadmillManualMode:
            treadmillSnapshot.isManualMode ||
            _session.plan is FreeWorkoutPlan ||
            !_isAutoPaceEnabled,
      ),
    );
    _startRunningTicker();
  }

  void _onTreadmillSpeedDecreased(
    WorkoutLiveTreadmillSpeedDecreased event,
    Emitter<WorkoutLiveState> emit,
  ) {
    _updateRunningTreadmillState(emit, treadmillDevice.decreaseSpeed);
  }

  void _onTreadmillSpeedIncreased(
    WorkoutLiveTreadmillSpeedIncreased event,
    Emitter<WorkoutLiveState> emit,
  ) {
    _updateRunningTreadmillState(emit, treadmillDevice.increaseSpeed);
  }

  void _onTreadmillAutomaticModeEnabled(
    WorkoutLiveTreadmillAutomaticModeEnabled event,
    Emitter<WorkoutLiveState> emit,
  ) {
    _updateRunningTreadmillState(emit, treadmillDevice.enableAutomaticMode);
  }

  void _onPauseButtonTapped(
    WorkoutLivePauseButtonTapped event,
    Emitter<WorkoutLiveState> emit,
  ) {
    if (state is! WorkoutLiveRunning) return;
    final running = state as WorkoutLiveRunning;

    final DateTime now = _now();
    final WorkoutSession pausedSession = running.session.copyWith(elapsed: running.elapsedAt(now));
    _stopTicker();
    emit(
      WorkoutLivePaused(
        session: pausedSession,
        treadmillSpeedKilometersPerHour: running.treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: running.isTreadmillManualMode,
      ),
    );
  }

  void _onResumed(WorkoutLiveResumed event, Emitter<WorkoutLiveState> emit) {
    if (state is! WorkoutLivePaused) return;
    final paused = state as WorkoutLivePaused;

    emit(
      WorkoutLiveRunning(
        session: paused.session,
        activeStartedAt: _now(),
        treadmillSpeedKilometersPerHour: paused.treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: paused.isTreadmillManualMode,
      ),
    );
    _startRunningTicker();
  }

  void _onEnded(WorkoutLiveEnded event, Emitter<WorkoutLiveState> emit) {
    final DateTime now = _now();
    final WorkoutSession session;
    final Duration elapsed;

    switch (state) {
      case WorkoutLiveRunning():
        final running = state as WorkoutLiveRunning;
        session = running.session;
        elapsed = running.elapsedAt(now);
      case WorkoutLivePaused():
        final paused = state as WorkoutLivePaused;
        session = paused.session;
        elapsed = paused.session.elapsed;
      default:
        return;
    }

    _stopTicker();
    emit(WorkoutLiveFinished(session: session.finish(endedAt: now, elapsed: elapsed)));
  }

  void _onTicked(_WorkoutLiveTicked event, Emitter<WorkoutLiveState> emit) {
    if (state is! WorkoutLiveRunning) return;
    final running = state as WorkoutLiveRunning;

    final DateTime now = _now();
    final HeartRateMeasurement heartRateMeasurement = heartRateMonitor.measure();
    final TreadmillSnapshot treadmillSnapshot = treadmillDevice.read();
    final double distanceMetersPerTick = running.session.environment == WorkoutEnvironment.indoor
        ? treadmillSnapshot.speedKilometersPerHour / 3.6
        : 0.0;
    final WorkoutSession updatedSession = running.session
        .copyWith(
          elapsed: running.elapsedAt(now),
          totalDistanceMeters: running.session.totalDistanceMeters + distanceMetersPerTick,
        )
        .recordHeartRate(heartRateMeasurement);

    emit(
      running.copyWith(
        session: updatedSession,
        treadmillSpeedKilometersPerHour: treadmillSnapshot.speedKilometersPerHour,
        isTreadmillManualMode:
            treadmillSnapshot.isManualMode || (running.isTreadmillManualMode ?? false),
        activeStartedAt: now,
      ),
    );
  }

  void _updateRunningTreadmillState(
    Emitter<WorkoutLiveState> emit,
    TreadmillSnapshot Function() update,
  ) {
    if (state is! WorkoutLiveRunning) return;
    final running = state as WorkoutLiveRunning;

    final snapshot = update();
    emit(
      running.copyWith(
        treadmillSpeedKilometersPerHour: snapshot.speedKilometersPerHour,
        isTreadmillManualMode: snapshot.isManualMode,
      ),
    );
  }

  void _startCountdownTicker() {
    _stopTicker();
    _tickerSubscription = _createTicker().listen((_) => add(const _WorkoutLiveCountdownTicked()));
  }

  void _startRunningTicker() {
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
