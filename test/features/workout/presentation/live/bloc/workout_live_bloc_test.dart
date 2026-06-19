import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/heart_rate/data/mock_heart_rate_monitor.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone_range.dart';
import 'package:runzone/features/treadmill/data/mock_treadmill_device.dart';
import 'package:runzone/features/treadmill/domain/treadmill_snapshot.dart';
import 'package:runzone/features/workout/domain/workout_session.dart';
import 'package:runzone/features/workout/presentation/live/bloc/workout_live_bloc.dart';

final class _FakeDelegate implements WorkoutLiveDelegate {
  WorkoutSession? pausedSession;
  WorkoutSession? endedSession;

  @override
  void pauseWorkout({required WorkoutSession session}) => pausedSession = session;

  @override
  void endWorkout({required WorkoutSession session}) => endedSession = session;
}

final _zoneTable = const HeartRateZoneTable(
  zone1: HeartRateZoneRange(lower: 96, upper: 120),
  zone2: HeartRateZoneRange(lower: 121, upper: 148),
  zone3: HeartRateZoneRange(lower: 149, upper: 160),
  zone4: HeartRateZoneRange(lower: 161, upper: 172),
  zone5: HeartRateZoneRange(lower: 173, upper: 182),
);

final _startedAt = DateTime(2026, 1, 1, 7);

final _testSession = WorkoutSession(
  startedAt: _startedAt,
  elapsed: Duration.zero,
  heartRateZoneTable: _zoneTable,
);

WorkoutLiveBloc _buildBloc({
  WorkoutSession? session,
  bool isAutoPaceEnabled = false,
  Stream<void> Function()? createTicker,
  DateTime Function()? now,
  _FakeDelegate? delegate,
}) {
  return WorkoutLiveBloc(
    session: session ?? _testSession,
    isAutoPaceEnabled: isAutoPaceEnabled,
    heartRateMonitor: MockHeartRateMonitor(scenario: const [150]),
    treadmillDevice: MockTreadmillDevice(
      scenario: const [TreadmillSnapshot(speedKilometersPerHour: 6.0, isManualMode: false)],
    ),
    delegate: delegate ?? _FakeDelegate(),
    createTicker: createTicker ?? () => const Stream.empty(),
    now: now ?? () => _startedAt,
  );
}

void main() {
  test('Given bloc 생성 When 초기 상태 확인 Then CountingDown(countIndex: 0)', () {
    final bloc = _buildBloc();
    expect(bloc.state, const WorkoutLiveCountingDown(countIndex: 0));
    bloc.close();
  });

  group('카운트다운', () {
    late StreamController<void> ticker;

    setUp(() => ticker = StreamController<void>.broadcast());
    tearDown(() => ticker.close());

    blocTest<WorkoutLiveBloc, WorkoutLiveState>(
      'Given CountingDown(0) When tick 3번 Then countIndex 1→2→3',
      build: () => _buildBloc(createTicker: () => ticker.stream),
      act: (bloc) async {
        ticker.add(null);
        await Future.delayed(Duration.zero);
        ticker.add(null);
        await Future.delayed(Duration.zero);
        ticker.add(null);
      },
      expect: () => const [
        WorkoutLiveCountingDown(countIndex: 1),
        WorkoutLiveCountingDown(countIndex: 2),
        WorkoutLiveCountingDown(countIndex: 3),
      ],
    );

    blocTest<WorkoutLiveBloc, WorkoutLiveState>(
      'Given CountingDown(0) When tick 4번 Then WorkoutLiveRunning 전환',
      build: () => _buildBloc(
        createTicker: () => ticker.stream,
        now: () => _startedAt,
      ),
      act: (bloc) async {
        for (var i = 0; i < 4; i++) {
          ticker.add(null);
          await Future.delayed(Duration.zero);
        }
      },
      expect: () => [
        const WorkoutLiveCountingDown(countIndex: 1),
        const WorkoutLiveCountingDown(countIndex: 2),
        const WorkoutLiveCountingDown(countIndex: 3),
        isA<WorkoutLiveRunning>()
            .having((s) => s.session, 'session', _testSession)
            .having((s) => s.activeStartedAt, 'activeStartedAt', _startedAt),
      ],
    );
  });

  group('일시정지 / 재개', () {
    late StreamController<void> ticker;
    setUp(() => ticker = StreamController<void>.broadcast());
    tearDown(() => ticker.close());

    blocTest<WorkoutLiveBloc, WorkoutLiveState>(
      'Given Running When PauseButtonTapped Then WorkoutLivePaused',
      build: () => _buildBloc(
        createTicker: () => ticker.stream,
        now: () => _startedAt,
      ),
      act: (bloc) async {
        for (var i = 0; i < 4; i++) {
          ticker.add(null);
          await Future.delayed(Duration.zero);
        }
        bloc.add(const WorkoutLivePauseButtonTapped());
      },
      expect: () => [
        const WorkoutLiveCountingDown(countIndex: 1),
        const WorkoutLiveCountingDown(countIndex: 2),
        const WorkoutLiveCountingDown(countIndex: 3),
        isA<WorkoutLiveRunning>(),
        isA<WorkoutLivePaused>(),
      ],
    );

    blocTest<WorkoutLiveBloc, WorkoutLiveState>(
      'Given Paused When WorkoutLiveResumed Then WorkoutLiveRunning',
      build: () => _buildBloc(
        createTicker: () => ticker.stream,
        now: () => _startedAt,
      ),
      act: (bloc) async {
        for (var i = 0; i < 4; i++) {
          ticker.add(null);
          await Future.delayed(Duration.zero);
        }
        bloc.add(const WorkoutLivePauseButtonTapped());
        await Future.delayed(Duration.zero);
        bloc.add(const WorkoutLiveResumed());
      },
      expect: () => [
        const WorkoutLiveCountingDown(countIndex: 1),
        const WorkoutLiveCountingDown(countIndex: 2),
        const WorkoutLiveCountingDown(countIndex: 3),
        isA<WorkoutLiveRunning>(),
        isA<WorkoutLivePaused>(),
        isA<WorkoutLiveRunning>(),
      ],
    );

    test('Given Running When PauseButtonTapped Then delegate.pauseWorkout 호출됨', () async {
      final delegate = _FakeDelegate();
      final ticker = StreamController<void>.broadcast();
      final bloc = _buildBloc(
        createTicker: () => ticker.stream,
        now: () => _startedAt,
        delegate: delegate,
      );

      for (var i = 0; i < 4; i++) {
        ticker.add(null);
        await Future.delayed(Duration.zero);
      }
      bloc.add(const WorkoutLivePauseButtonTapped());
      await Future.delayed(Duration.zero);

      expect(delegate.pausedSession, isNotNull);
      await bloc.close();
      await ticker.close();
    });
  });

  group('종료', () {
    late StreamController<void> ticker;
    setUp(() => ticker = StreamController<void>.broadcast());
    tearDown(() => ticker.close());

    test('Given Running When WorkoutLiveEnded Then delegate.endWorkout 호출됨', () async {
      final delegate = _FakeDelegate();
      final bloc = _buildBloc(
        createTicker: () => ticker.stream,
        now: () => _startedAt,
        delegate: delegate,
      );

      for (var i = 0; i < 4; i++) {
        ticker.add(null);
        await Future.delayed(Duration.zero);
      }
      bloc.add(const WorkoutLiveEnded());
      await Future.delayed(Duration.zero);

      expect(delegate.endedSession, isNotNull);
      expect(delegate.endedSession!.endedAt, _startedAt);
      await bloc.close();
    });

    test('Given Paused When WorkoutLiveEnded Then delegate.endWorkout 호출됨', () async {
      final delegate = _FakeDelegate();
      final bloc = _buildBloc(
        createTicker: () => ticker.stream,
        now: () => _startedAt,
        delegate: delegate,
      );

      for (var i = 0; i < 4; i++) {
        ticker.add(null);
        await Future.delayed(Duration.zero);
      }
      bloc.add(const WorkoutLivePauseButtonTapped());
      await Future.delayed(Duration.zero);
      bloc.add(const WorkoutLiveEnded());
      await Future.delayed(Duration.zero);

      expect(delegate.endedSession, isNotNull);
      await bloc.close();
    });
  });

  group('이벤트 무시 케이스', () {
    blocTest<WorkoutLiveBloc, WorkoutLiveState>(
      'Given CountingDown When PauseButtonTapped Then 상태 변화 없음',
      build: () => _buildBloc(),
      act: (bloc) => bloc.add(const WorkoutLivePauseButtonTapped()),
      expect: () => const <WorkoutLiveState>[],
    );

    blocTest<WorkoutLiveBloc, WorkoutLiveState>(
      'Given CountingDown When WorkoutLiveResumed Then 상태 변화 없음',
      build: () => _buildBloc(),
      act: (bloc) => bloc.add(const WorkoutLiveResumed()),
      expect: () => const <WorkoutLiveState>[],
    );
  });
}
