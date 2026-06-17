import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_measurement.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_monitor.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone_range.dart';
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

void main() {
  late _FakeClock clock;
  late _FakeTicker ticker;
  late _FakeHeartRateMonitor heartRateMonitor;
  final DateTime startedAt = DateTime(2026, 6, 15, 7);
  const HeartRateZoneTable heartRateZoneTable = HeartRateZoneTable(
    zone1: HeartRateZoneRange(lower: 90, upper: 111),
    zone2: HeartRateZoneRange(lower: 112, upper: 130),
    zone3: HeartRateZoneRange(lower: 131, upper: 149),
    zone4: HeartRateZoneRange(lower: 150, upper: 167),
    zone5: HeartRateZoneRange(lower: 168, upper: 187),
  );

  setUp(() {
    clock = _FakeClock(startedAt);
    ticker = _FakeTicker();
    heartRateMonitor = _FakeHeartRateMonitor([HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)]);
  });

  WorkoutSessionBloc buildBloc() {
    return WorkoutSessionBloc(
      now: clock.call,
      createTicker: ticker.create,
      heartRateMonitor: heartRateMonitor,
      heartRateZoneTable: heartRateZoneTable,
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

  test('Given 새로 생성한 bloc When 초기 상태를 확인하면 Then 준비 상태와 0초 경과다', () {
    expect(buildBloc().state, const WorkoutSessionState.initial(heartRateZoneTable: heartRateZoneTable));
  });

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 시작 이벤트를 보내면 Then 진행 상태와 운동 세션을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) => bloc.add(const WorkoutSessionStarted()),
    expect: () => [
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: Duration.zero),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When tick하면 Then 경과 시간과 심박 기록을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      bloc.add(const WorkoutSessionStarted());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 2));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: Duration.zero),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 2),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)],
        ),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When tick마다 측정하면 Then 다음 심박 측정값을 누적한다',
    build: () {
      heartRateMonitor = _FakeHeartRateMonitor([
        HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt.add(const Duration(seconds: 1))),
        HeartRateMeasurement(beatsPerMinute: 151, measuredAt: startedAt.add(const Duration(seconds: 2))),
      ]);
      return buildBloc();
    },
    act: (WorkoutSessionBloc bloc) async {
      bloc.add(const WorkoutSessionStarted());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 1));
      ticker.tick();
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 1));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: Duration.zero),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 1),
          heartRateMeasurements: [
            HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt.add(const Duration(seconds: 1))),
          ],
        ),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 2),
          heartRateMeasurements: [
            HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt.add(const Duration(seconds: 1))),
            HeartRateMeasurement(beatsPerMinute: 151, measuredAt: startedAt.add(const Duration(seconds: 2))),
          ],
        ),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When 일시정지하면 Then 경과가 멈추고 이후 tick에도 변하지 않는다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      bloc.add(const WorkoutSessionStarted());
      await pumpEventQueue();
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
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: Duration.zero),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)],
        ),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.paused,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)],
        ),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 일시정지 상태 When 재개하면 Then 멈췄던 지점부터 경과 시간이 다시 증가한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      bloc.add(const WorkoutSessionStarted());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 3));
      ticker.tick();
      await pumpEventQueue();
      bloc.add(const WorkoutSessionPaused());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 7));
      bloc.add(const WorkoutSessionResumed());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 2));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: Duration.zero),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)],
        ),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.paused,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)],
        ),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 3),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)],
        ),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 5),
          heartRateMeasurements: [
            HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt),
            HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt),
          ],
        ),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When 종료하면 Then 종료 상태와 종료된 운동 세션을 방출한다',
    build: buildBloc,
    act: (WorkoutSessionBloc bloc) async {
      bloc.add(const WorkoutSessionStarted());
      await pumpEventQueue();
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
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(elapsed: Duration.zero),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.running,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 30),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)],
        ),
      ),
      WorkoutSessionState(
        status: WorkoutSessionStatus.ended,
        heartRateZoneTable: heartRateZoneTable,
        session: session(
          elapsed: const Duration(seconds: 30),
          endedAt: startedAt.add(const Duration(seconds: 30)),
          heartRateMeasurements: [HeartRateMeasurement(beatsPerMinute: 125, measuredAt: startedAt)],
        ),
      ),
    ],
  );
}
