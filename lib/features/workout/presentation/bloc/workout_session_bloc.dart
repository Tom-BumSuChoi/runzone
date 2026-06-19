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
    required this.targetHeartRateZone,
    DateTime Function()? now,
    Stream<void> Function()? createTicker,
  }) : _now = now ?? DateTime.now,
       _createTicker = createTicker ?? (() => Stream<void>.periodic(const Duration(seconds: 1), (_) {})),
       super(WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable)) {
    on<WorkoutSessionStarted>(_onStarted);
    on<WorkoutSessionEnvironmentChanged>(_onEnvironmentChanged);
    on<WorkoutSessionTargetZonePlanSelected>(_onTargetZonePlanSelected);
    on<WorkoutSessionIntervalPlanSelected>(_onIntervalPlanSelected);
    on<WorkoutSessionFreePlanSelected>(_onFreePlanSelected);
    on<WorkoutSessionTreadmillConnectionToggled>(_onTreadmillConnectionToggled);
    on<WorkoutSessionAutoPaceToggled>(_onAutoPaceToggled);
    on<WorkoutSessionZoneAlertToggled>(_onZoneAlertToggled);
    on<WorkoutSessionTreadmillSpeedDecreased>(_onTreadmillSpeedDecreased);
    on<WorkoutSessionTreadmillSpeedIncreased>(_onTreadmillSpeedIncreased);
    on<WorkoutSessionTreadmillAutomaticModeEnabled>(_onTreadmillAutomaticModeEnabled);
    on<WorkoutSessionTargetZoneDurationIncreased>(_onTargetZoneDurationIncreased);
    on<WorkoutSessionTargetZoneDurationDecreased>(_onTargetZoneDurationDecreased);
    on<WorkoutSessionTargetHeartRateZoneIncreased>(_onTargetHeartRateZoneIncreased);
    on<WorkoutSessionTargetHeartRateZoneDecreased>(_onTargetHeartRateZoneDecreased);
    on<WorkoutSessionIntervalWarmUpDurationIncreased>(_onIntervalWarmUpDurationIncreased);
    on<WorkoutSessionIntervalWarmUpDurationDecreased>(_onIntervalWarmUpDurationDecreased);
    on<WorkoutSessionIntervalHighIntensityDistanceIncreased>(_onIntervalHighIntensityDistanceIncreased);
    on<WorkoutSessionIntervalHighIntensityDistanceDecreased>(_onIntervalHighIntensityDistanceDecreased);
    on<WorkoutSessionIntervalRecoveryDurationIncreased>(_onIntervalRecoveryDurationIncreased);
    on<WorkoutSessionIntervalRecoveryDurationDecreased>(_onIntervalRecoveryDurationDecreased);
    on<WorkoutSessionIntervalRepeatCountIncreased>(_onIntervalRepeatCountIncreased);
    on<WorkoutSessionIntervalRepeatCountDecreased>(_onIntervalRepeatCountDecreased);
    on<WorkoutSessionPaused>(_onPaused);
    on<WorkoutSessionResumed>(_onResumed);
    on<WorkoutSessionEnded>(_onEnded);
    on<_WorkoutSessionTicked>(_onTicked);
  }

  final DateTime Function() _now;
  final Stream<void> Function() _createTicker;
  final HeartRateMonitor heartRateMonitor;
  final TreadmillDevice treadmillDevice;
  final HeartRateZone targetHeartRateZone;
  StreamSubscription<void>? _tickerSubscription;

  void _onStarted(WorkoutSessionStarted event, Emitter<WorkoutSessionState> emit) {
    final WorkoutSessionState currentState = state;
    if (currentState is! WorkoutSessionReadyState) {
      return;
    }

    final TreadmillSnapshot treadmillSnapshot = treadmillDevice.read();
    emit(
      WorkoutSessionCountdownState(
        heartRateZoneTable: currentState.heartRateZoneTable,
        session: WorkoutSession(
          startedAt: _now(),
          elapsed: Duration.zero,
          heartRateZoneTable: currentState.heartRateZoneTable,
        ),
        treadmillSpeedKilometersPerHour: treadmillSnapshot.speedKilometersPerHour,
        isTreadmillManualMode:
            treadmillSnapshot.isManualMode || currentState.plan is FreeWorkoutPlan || !currentState.isAutoPaceEnabled,
        step: _countdownStartStep,
      ),
    );
    _startTicker();
  }

  void _onEnvironmentChanged(WorkoutSessionEnvironmentChanged event, Emitter<WorkoutSessionState> emit) {
    _updateReadyState(emit, (state) => state.copyWith(environment: event.environment));
  }

  void _onTargetZonePlanSelected(WorkoutSessionTargetZonePlanSelected event, Emitter<WorkoutSessionState> emit) {
    _updateReadyState(emit, (state) => state.copyWith(plan: TargetZoneWorkoutPlan.initial));
  }

  void _onIntervalPlanSelected(WorkoutSessionIntervalPlanSelected event, Emitter<WorkoutSessionState> emit) {
    _updateReadyState(emit, (state) => state.copyWith(plan: IntervalWorkoutPlan.initial));
  }

  void _onFreePlanSelected(WorkoutSessionFreePlanSelected event, Emitter<WorkoutSessionState> emit) {
    _updateReadyState(emit, (state) => state.copyWith(plan: FreeWorkoutPlan.initial));
  }

  void _onTreadmillConnectionToggled(
    WorkoutSessionTreadmillConnectionToggled event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyState(emit, (state) => state.copyWith(isTreadmillConnected: !state.isTreadmillConnected));
  }

  void _onAutoPaceToggled(WorkoutSessionAutoPaceToggled event, Emitter<WorkoutSessionState> emit) {
    _updateReadyState(emit, (state) => state.copyWith(isAutoPaceEnabled: !state.isAutoPaceEnabled));
  }

  void _onZoneAlertToggled(WorkoutSessionZoneAlertToggled event, Emitter<WorkoutSessionState> emit) {
    _updateReadyState(emit, (state) => state.copyWith(isZoneAlertEnabled: !state.isZoneAlertEnabled));
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

  void _onTargetZoneDurationIncreased(
    WorkoutSessionTargetZoneDurationIncreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyTargetZonePlan(emit, (plan) {
      return TargetZoneWorkoutPlan(
        durationGoal: plan.durationGoal.increase(),
        targetHeartRateZone: plan.targetHeartRateZone,
      );
    });
  }

  void _onTargetZoneDurationDecreased(
    WorkoutSessionTargetZoneDurationDecreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyTargetZonePlan(emit, (plan) {
      return TargetZoneWorkoutPlan(
        durationGoal: plan.durationGoal.decrease(),
        targetHeartRateZone: plan.targetHeartRateZone,
      );
    });
  }

  void _onTargetHeartRateZoneIncreased(
    WorkoutSessionTargetHeartRateZoneIncreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyTargetZonePlan(emit, (plan) {
      return TargetZoneWorkoutPlan(
        durationGoal: plan.durationGoal,
        targetHeartRateZone: plan.targetHeartRateZone.increase(),
      );
    });
  }

  void _onTargetHeartRateZoneDecreased(
    WorkoutSessionTargetHeartRateZoneDecreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyTargetZonePlan(emit, (plan) {
      return TargetZoneWorkoutPlan(
        durationGoal: plan.durationGoal,
        targetHeartRateZone: plan.targetHeartRateZone.decrease(),
      );
    });
  }

  void _onIntervalWarmUpDurationIncreased(
    WorkoutSessionIntervalWarmUpDurationIncreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyIntervalPlan(emit, (plan) => plan.increaseWarmUpDuration());
  }

  void _onIntervalWarmUpDurationDecreased(
    WorkoutSessionIntervalWarmUpDurationDecreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyIntervalPlan(emit, (plan) => plan.decreaseWarmUpDuration());
  }

  void _onIntervalHighIntensityDistanceIncreased(
    WorkoutSessionIntervalHighIntensityDistanceIncreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyIntervalPlan(emit, (plan) => plan.increaseHighIntensityDistance());
  }

  void _onIntervalHighIntensityDistanceDecreased(
    WorkoutSessionIntervalHighIntensityDistanceDecreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyIntervalPlan(emit, (plan) => plan.decreaseHighIntensityDistance());
  }

  void _onIntervalRecoveryDurationIncreased(
    WorkoutSessionIntervalRecoveryDurationIncreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyIntervalPlan(emit, (plan) => plan.increaseRecoveryDuration());
  }

  void _onIntervalRecoveryDurationDecreased(
    WorkoutSessionIntervalRecoveryDurationDecreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyIntervalPlan(emit, (plan) => plan.decreaseRecoveryDuration());
  }

  void _onIntervalRepeatCountIncreased(
    WorkoutSessionIntervalRepeatCountIncreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyIntervalPlan(emit, (plan) => plan.increaseRepeatCount());
  }

  void _onIntervalRepeatCountDecreased(
    WorkoutSessionIntervalRepeatCountDecreased event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _updateReadyIntervalPlan(emit, (plan) => plan.decreaseRepeatCount());
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
            targetHeartRateZone: currentState.targetHeartRateZone,
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
          ),
        );
      case WorkoutSessionPausedState():
        emit(
          WorkoutSessionEndedState(
            heartRateZoneTable: currentState.heartRateZoneTable,
            session: currentState.session.finish(endedAt: currentState.pausedAt, elapsed: currentState.session.elapsed),
            targetHeartRateZone: currentState.targetHeartRateZone,
            treadmillSpeedKilometersPerHour: currentState.treadmillSpeedKilometersPerHour,
            isTreadmillManualMode: currentState.isTreadmillManualMode,
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
            targetHeartRateZone: targetHeartRateZone,
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
    final WorkoutSession updatedSession = currentState.session
        .copyWith(elapsed: currentState.elapsedAt(now))
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

  void _updateReadyState(
    Emitter<WorkoutSessionState> emit,
    WorkoutSessionReadyState Function(WorkoutSessionReadyState state) update,
  ) {
    final WorkoutSessionState currentState = state;
    if (currentState is! WorkoutSessionReadyState) {
      return;
    }

    emit(update(currentState));
  }

  void _updateReadyTargetZonePlan(
    Emitter<WorkoutSessionState> emit,
    TargetZoneWorkoutPlan Function(TargetZoneWorkoutPlan plan) update,
  ) {
    _updateReadyState(emit, (state) {
      final plan = state.plan;
      if (plan is! TargetZoneWorkoutPlan) {
        return state;
      }

      final nextPlan = update(plan);
      if (nextPlan == plan) {
        return state;
      }

      return state.copyWith(plan: nextPlan);
    });
  }

  void _updateReadyIntervalPlan(
    Emitter<WorkoutSessionState> emit,
    IntervalWorkoutPlan Function(IntervalWorkoutPlan plan) update,
  ) {
    _updateReadyState(emit, (state) {
      final plan = state.plan;
      if (plan is! IntervalWorkoutPlan) {
        return state;
      }

      final nextPlan = update(plan);
      if (nextPlan == plan) {
        return state;
      }

      return state.copyWith(plan: nextPlan);
    });
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
