import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_measurement.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_monitor.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone_range.dart';
import 'package:runzone/features/treadmill/domain/treadmill_monitor.dart';
import 'package:runzone/features/treadmill/domain/treadmill_snapshot.dart';
import 'package:runzone/features/workout/domain/workout_duration_goal.dart';
import 'package:runzone/features/workout/domain/workout_environment.dart';
import 'package:runzone/features/workout/domain/workout_plan.dart';
import 'package:runzone/features/workout/domain/workout_session.dart';
import 'package:runzone/features/workout/presentation/bloc/workout_session_bloc.dart';

final class _FakeClock {
  _FakeClock(this._now);

  DateTime _now;

  DateTime call() => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}

final class _FakeTicker {
  StreamController<void>? _controller;

  Stream<void> create() {
    final StreamController<void> controller = StreamController<void>();
    _controller = controller;
    return controller.stream;
  }

  void tick() {
    _controller?.add(null);
  }
}

final class _FakeHeartRateMonitor implements HeartRateMonitor {
  _FakeHeartRateMonitor(this._measurements);

  final List<HeartRateMeasurement> _measurements;
  int _nextIndex = 0;

  @override
  HeartRateMeasurement measure() {
    final HeartRateMeasurement measurement = _measurements[_nextIndex % _measurements.length];
    _nextIndex += 1;
    return measurement;
  }
}

final class _FakeTreadmillMonitor implements TreadmillMonitor {
  _FakeTreadmillMonitor(this._snapshots);

  final List<TreadmillSnapshot> _snapshots;
  int _nextIndex = 0;

  @override
  TreadmillSnapshot read() {
    final TreadmillSnapshot snapshot = _snapshots[_nextIndex % _snapshots.length];
    _nextIndex += 1;
    return snapshot;
  }
}

void main() {
  late _FakeClock clock;
  late _FakeTicker ticker;
  late _FakeHeartRateMonitor heartRateMonitor;
  late _FakeTreadmillMonitor treadmillMonitor;
  final DateTime startedAt = DateTime(2026, 6, 15, 7);
  final DateTime runningStartedAt = startedAt.add(const Duration(seconds: 4));
  const HeartRateZoneTable heartRateZoneTable = HeartRateZoneTable(
    zone1: HeartRateZoneRange(lower: 90, upper: 111),
    zone2: HeartRateZoneRange(lower: 112, upper: 130),
    zone3: HeartRateZoneRange(lower: 131, upper: 149),
    zone4: HeartRateZoneRange(lower: 150, upper: 167),
    zone5: HeartRateZoneRange(lower: 168, upper: 187),
  );
  const HeartRateZone targetHeartRateZone = HeartRateZone.zone2;
  const double defaultTreadmillSpeedKilometersPerHour = 7.2;
  const bool defaultIsTreadmillManualMode = false;
  setUp(() {
    clock = _FakeClock(startedAt);
    ticker = _FakeTicker();
    heartRateMonitor = _FakeHeartRateMonitor([HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)]);
    treadmillMonitor = _FakeTreadmillMonitor(const [
      TreadmillSnapshot(
        speedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isManualMode: defaultIsTreadmillManualMode,
      ),
    ]);
  });

  WorkoutSessionBloc buildBloc() {
    return WorkoutSessionBloc(
      now: clock.call,
      createTicker: ticker.create,
      heartRateMonitor: heartRateMonitor,
      treadmillMonitor: treadmillMonitor,
      heartRateZoneTable: heartRateZoneTable,
      targetHeartRateZone: targetHeartRateZone,
    );
  }

  WorkoutSession session({
    required Duration elapsed,
    DateTime? endedAt,
    List<HeartRateMeasurement> heartRateMeasurements = const [],
  }) {
    return WorkoutSession(
      startedAt: startedAt,
      endedAt: endedAt,
      elapsed: elapsed,
      heartRateZoneTable: heartRateZoneTable,
      heartRateMeasurements: heartRateMeasurements,
    );
  }

  Future<void> startWorkout(WorkoutSessionBloc bloc) async {
    bloc.add(const WorkoutSessionStarted());
    await pumpEventQueue();
    for (int i = 0; i < 4; i += 1) {
      clock.advance(const Duration(seconds: 1));
      ticker.tick();
      await pumpEventQueue();
    }
  }

  List<WorkoutSessionState> countdownStates({
    required WorkoutSession workoutSession,
    double treadmillSpeedKilometersPerHour = defaultTreadmillSpeedKilometersPerHour,
    bool isTreadmillManualMode = defaultIsTreadmillManualMode,
  }) {
    return [
      WorkoutSessionCountdownState(
        heartRateZoneTable: heartRateZoneTable,
        step: WorkoutSessionCountdownStep.three,
        session: workoutSession,
        treadmillSpeedKilometersPerHour: treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: isTreadmillManualMode,
      ),
      WorkoutSessionCountdownState(
        heartRateZoneTable: heartRateZoneTable,
        step: WorkoutSessionCountdownStep.two,
        session: workoutSession,
        treadmillSpeedKilometersPerHour: treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: isTreadmillManualMode,
      ),
      WorkoutSessionCountdownState(
        heartRateZoneTable: heartRateZoneTable,
        step: WorkoutSessionCountdownStep.one,
        session: workoutSession,
        treadmillSpeedKilometersPerHour: treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: isTreadmillManualMode,
      ),
      WorkoutSessionCountdownState(
        heartRateZoneTable: heartRateZoneTable,
        step: WorkoutSessionCountdownStep.go,
        session: workoutSession,
        treadmillSpeedKilometersPerHour: treadmillSpeedKilometersPerHour,
        isTreadmillManualMode: isTreadmillManualMode,
      ),
    ];
  }

  List<WorkoutSessionState> countdownToRunningStates() {
    return [
      ...countdownStates(workoutSession: session(elapsed: Duration.zero)),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: Duration.zero),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: 7.2,
        isTreadmillManualMode: false,
        activeStartedAt: runningStartedAt,
      ),
    ];
  }

  test('Given 새로 생성한 bloc When 초기 상태를 확인하면 Then 준비 상태와 0초 경과다', () {
    expect(buildBloc().state, const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable));
  });

  test('Given 실내 운동 환경과 러닝머신 미연결 상태 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable);

    expect(state.canStart, isFalse);
  });

  test('Given 실내 운동 환경과 러닝머신 연결 상태 When 시작 가능 여부를 확인하면 Then 시작할 수 있다', () {
    const state = WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, isTreadmillConnected: true);

    expect(state.canStart, isTrue);
  });

  test('Given 야외 운동 환경 When 시작 가능 여부를 확인하면 Then 러닝머신 연결 없이 시작할 수 있다', () {
    const state = WorkoutSessionReadyState(
      heartRateZoneTable: heartRateZoneTable,
      environment: WorkoutEnvironment.outdoor,
    );

    expect(state.canStart, isTrue);
  });

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 운동 환경을 변경하면 Then 선택한 운동 환경을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionEnvironmentChanged(WorkoutEnvironment.outdoor)),
    expect: () => [
      const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, environment: WorkoutEnvironment.outdoor),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 인터벌 계획을 선택하면 Then 인터벌 계획을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionIntervalPlanSelected()),
    expect: () => [
      const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, plan: IntervalWorkoutPlan.initial),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 자유 러닝 계획을 선택하면 Then 자유 러닝 계획을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionFreePlanSelected()),
    expect: () => [
      const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, plan: FreeWorkoutPlan.initial),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 러닝머신 연결 상태를 토글하면 Then 변경된 연결 상태를 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionTreadmillConnectionToggled()),
    expect: () => [const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, isTreadmillConnected: true)],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 자동 페이스 조절 상태를 토글하면 Then 변경된 자동 페이스 조절 상태를 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionAutoPaceToggled()),
    expect: () => [const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, isAutoPaceEnabled: false)],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 존 이탈 알림 상태를 토글하면 Then 변경된 존 이탈 알림 상태를 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionZoneAlertToggled()),
    expect: () => [const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, isZoneAlertEnabled: false)],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 목표존 계획 When 목표 시간을 증가하면 Then 5분 증가한 목표 시간을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionTargetZoneDurationIncreased()),
    expect: () => [
      const WorkoutSessionReadyState(
        heartRateZoneTable: heartRateZoneTable,
        plan: TargetZoneWorkoutPlan(
          durationGoal: WorkoutDurationGoal(minutes: 45),
          targetHeartRateZone: HeartRateZone.zone2,
        ),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 목표존 계획 When 목표 심박존을 증가하면 Then 다음 목표 심박존을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionTargetHeartRateZoneIncreased()),
    expect: () => [
      const WorkoutSessionReadyState(
        heartRateZoneTable: heartRateZoneTable,
        plan: TargetZoneWorkoutPlan(
          durationGoal: WorkoutDurationGoal(minutes: WorkoutDurationGoal.initialMinutes),
          targetHeartRateZone: HeartRateZone.zone3,
        ),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 인터벌 계획 When 워밍업 시간을 증가하면 Then 1분 증가한 인터벌 계획을 방출한다',
    build: buildBloc,
    seed: () =>
        const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, plan: IntervalWorkoutPlan.initial),
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionIntervalWarmUpDurationIncreased()),
    expect: () => [
      const WorkoutSessionReadyState(
        heartRateZoneTable: heartRateZoneTable,
        plan: IntervalWorkoutPlan(
          warmUpDuration: Duration(minutes: 6),
          highIntensityDistanceMeters: 400,
          recoveryDuration: Duration(seconds: 90),
          repeatCount: 6,
        ),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 인터벌 계획 When 고강도 거리를 증가하면 Then 100m 증가한 인터벌 계획을 방출한다',
    build: buildBloc,
    seed: () =>
        const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, plan: IntervalWorkoutPlan.initial),
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionIntervalHighIntensityDistanceIncreased()),
    expect: () => [
      const WorkoutSessionReadyState(
        heartRateZoneTable: heartRateZoneTable,
        plan: IntervalWorkoutPlan(
          warmUpDuration: Duration(minutes: 5),
          highIntensityDistanceMeters: 500,
          recoveryDuration: Duration(seconds: 90),
          repeatCount: 6,
        ),
      ),
    ],
  );

  test('Given 현재 심박존 When 목표 존 상태를 확인하면 Then 안과 밖을 구분한다', () {
    final WorkoutSessionRunningState inTargetState = WorkoutSessionRunningState(
      heartRateZoneTable: heartRateZoneTable,
      session: session(
        elapsed: Duration.zero,
        heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
      ),
      targetHeartRateZone: targetHeartRateZone,
      treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
      isTreadmillManualMode: defaultIsTreadmillManualMode,
      activeStartedAt: runningStartedAt,
    );
    final WorkoutSessionRunningState outOfTargetState = WorkoutSessionRunningState(
      heartRateZoneTable: heartRateZoneTable,
      session: session(
        elapsed: Duration.zero,
        heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 151, measuredAt: runningStartedAt)],
      ),
      targetHeartRateZone: targetHeartRateZone,
      treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
      isTreadmillManualMode: defaultIsTreadmillManualMode,
      activeStartedAt: runningStartedAt,
    );

    expect(inTargetState.isInTargetHeartRateZone, isTrue);
    expect(outOfTargetState.isInTargetHeartRateZone, isFalse);
  });

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 시작 이벤트를 보내면 Then 카운트다운 상태를 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionStarted()),
    expect: () => [
      WorkoutSessionCountdownState(
        heartRateZoneTable: heartRateZoneTable,
        step: WorkoutSessionCountdownStep.three,
        session: session(elapsed: Duration.zero),
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 자동 페이스를 끈 준비 상태 When 시작하면 Then 수동 러닝머신 상태를 카운트다운에 전달한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) {
      bloc.add(const WorkoutSessionAutoPaceToggled());
      bloc.add(const WorkoutSessionStarted());
    },
    expect: () => [
      const WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable, isAutoPaceEnabled: false),
      WorkoutSessionCountdownState(
        heartRateZoneTable: heartRateZoneTable,
        step: WorkoutSessionCountdownStep.three,
        session: session(elapsed: Duration.zero),
        treadmillSpeedKilometersPerHour: 7.2,
        isTreadmillManualMode: true,
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 러닝머신 스냅샷 When 시작하고 tick하면 Then 러닝머신 상태를 최신 스냅샷으로 갱신한다',
    build: () {
      treadmillMonitor = _FakeTreadmillMonitor(const [
        TreadmillSnapshot(speedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour, isManualMode: false),
        TreadmillSnapshot(speedKilometersPerHour: 8.4, isManualMode: true),
      ]);
      return buildBloc();
    },
    act: (WorkoutSessionBloc bloc) async {
      await startWorkout(bloc);
      clock.advance(const Duration(seconds: 2));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      ...countdownStates(
        workoutSession: session(elapsed: Duration.zero),
        treadmillSpeedKilometersPerHour: 7.2,
        isTreadmillManualMode: false,
      ),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: Duration.zero),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: 7.2,
        isTreadmillManualMode: false,
        activeStartedAt: runningStartedAt,
      ),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 2),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: 8.4,
        isTreadmillManualMode: true,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 2)),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 카운트다운 상태 When 네 번 tick하면 Then 운동 세션을 시작한다',
    build: buildBloc,
    act: startWorkout,
    expect: countdownToRunningStates,
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When tick하면 Then 경과 시간과 심박 기록을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      await startWorkout(bloc);
      clock.advance(const Duration(seconds: 2));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      ...countdownToRunningStates(),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 2),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 2)),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When tick마다 측정하면 Then 다음 심박 측정값을 누적한다',
    build: () {
      heartRateMonitor = _FakeHeartRateMonitor([
        HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt.add(const Duration(seconds: 1))),
        HeartRateMeasurement(beatsPerMinute: 151, measuredAt: runningStartedAt.add(const Duration(seconds: 2))),
      ]);
      return buildBloc();
    },
    act: (WorkoutSessionBloc bloc) async {
      await startWorkout(bloc);
      clock.advance(const Duration(seconds: 1));
      ticker.tick();
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 1));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      ...countdownToRunningStates(),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 1),
          heartRateMeasurements: [
            HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt.add(const Duration(seconds: 1))),
          ],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 1)),
      ),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 2),
          heartRateMeasurements: [
            HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt.add(const Duration(seconds: 1))),
            HeartRateMeasurement(beatsPerMinute: 151, measuredAt: runningStartedAt.add(const Duration(seconds: 2))),
          ],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 2)),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When 일시정지하면 Then 경과가 멈추고 이후 tick에도 변하지 않는다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      await startWorkout(bloc);
      clock.advance(const Duration(seconds: 3));
      ticker.tick();
      await pumpEventQueue();
      bloc.add(const WorkoutSessionPaused());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 10));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      ...countdownToRunningStates(),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 3)),
      ),
      WorkoutSessionPausedState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        pausedAt: runningStartedAt.add(const Duration(seconds: 3)),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 일시정지 상태 When 재개하면 Then 멈췄던 지점부터 경과 시간이 다시 증가한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      await startWorkout(bloc);
      clock.advance(const Duration(seconds: 3));
      ticker.tick();
      await pumpEventQueue();
      bloc.add(const WorkoutSessionPaused());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 7));
      bloc.add(const WorkoutSessionResumed());
      await pumpEventQueue();
      for (int i = 0; i < 4; i += 1) {
        clock.advance(const Duration(seconds: 1));
        ticker.tick();
        await pumpEventQueue();
      }
      clock.advance(const Duration(seconds: 2));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      ...countdownToRunningStates(),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 3)),
      ),
      WorkoutSessionPausedState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        pausedAt: runningStartedAt.add(const Duration(seconds: 3)),
      ),
      ...countdownStates(
        workoutSession: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
      ),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 14)),
      ),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 5),
          heartRateMeasurements: [
            HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt),
            HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt),
          ],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 16)),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When 종료하면 Then 종료 상태와 종료된 운동 세션을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      await startWorkout(bloc);
      clock.advance(const Duration(seconds: 30));
      ticker.tick();
      await pumpEventQueue();
      bloc.add(const WorkoutSessionEnded());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 10));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      ...countdownToRunningStates(),
      WorkoutSessionRunningState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 30),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        activeStartedAt: runningStartedAt.add(const Duration(seconds: 30)),
      ),
      WorkoutSessionEndedState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 30),
          endedAt: runningStartedAt.add(const Duration(seconds: 30)),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: runningStartedAt)],
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 일시정지 상태 When 종료하면 Then 일시정지 시각을 종료 시각으로 기록한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      await startWorkout(bloc);
      clock.advance(const Duration(seconds: 3));
      bloc.add(const WorkoutSessionPaused());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 7));
      bloc.add(const WorkoutSessionEnded());
      await pumpEventQueue();
    },
    expect: () => [
      ...countdownToRunningStates(),
      WorkoutSessionPausedState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: const Duration(seconds: 3)),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
        pausedAt: runningStartedAt.add(const Duration(seconds: 3)),
      ),
      WorkoutSessionEndedState(
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          endedAt: runningStartedAt.add(const Duration(seconds: 3)),
        ),
        targetHeartRateZone: targetHeartRateZone,
        treadmillSpeedKilometersPerHour: defaultTreadmillSpeedKilometersPerHour,
        isTreadmillManualMode: defaultIsTreadmillManualMode,
      ),
    ],
  );
}
