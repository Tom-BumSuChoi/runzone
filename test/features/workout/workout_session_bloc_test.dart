import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/workout_session.dart';
import 'package:runzone/features/workout/presentation/bloc/workout_session_bloc.dart';

/// 주입형 가짜 시계 — now()가 advance한 만큼만 흐른다.
final class _FakeClock {
  _FakeClock(this._now);

  DateTime _now;

  DateTime call() => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}

/// createTicker() 호출마다 새 스트림을 내준다(매번 새 single-subscription).
/// tick()은 가장 최근에 만든 스트림에 1틱을 발사한다.
final class _FakeTicker {
  StreamController<void>? _controller;

  Stream<void> create() {
    final controller = StreamController<void>();
    _controller = controller;
    return controller.stream;
  }

  void tick() {
    _controller?.add(null);
  }
}

void main() {
  late _FakeClock clock;
  late _FakeTicker ticker;
  final DateTime startedAt = DateTime(2026, 6, 15, 7);

  setUp(() {
    clock = _FakeClock(startedAt);
    ticker = _FakeTicker();
  });

  WorkoutSessionBloc buildBloc() {
    return WorkoutSessionBloc(now: clock.call, createTicker: ticker.create);
  }

  test('Given 새로 생성한 bloc When 초기 상태를 확인하면 Then 준비 세션과 0초 경과다', () {
    expect(buildBloc().state, WorkoutSessionState.initial());
  });

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 준비 상태 When 시작 이벤트를 보내면 Then 진행 세션을 방출한다',
    build: buildBloc,
    act: (bloc) => bloc.add(const WorkoutSessionStarted()),
    expect: () => [WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: Duration.zero)],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When tick하면 Then 경과 시간이 증가한다',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const WorkoutSessionStarted());
      await pumpEventQueue();
      clock.advance(const Duration(seconds: 2));
      ticker.tick();
      await pumpEventQueue();
    },
    expect: () => [
      WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: Duration.zero),
      WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: const Duration(seconds: 2)),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When 일시정지하면 Then 경과가 멈추고 이후 tick에도 변하지 않는다',
    build: buildBloc,
    act: (bloc) async {
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
      WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: Duration.zero),
      WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: const Duration(seconds: 3)),
      WorkoutSessionState(
        session: const ReadyWorkoutSession().start(startedAt).pause(startedAt.add(const Duration(seconds: 3))),
        elapsed: const Duration(seconds: 3),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 일시정지 상태 When 재개하면 Then 멈췄던 지점부터 경과 시간이 다시 증가한다',
    build: buildBloc,
    act: (bloc) async {
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
      WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: Duration.zero),
      WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: const Duration(seconds: 3)),
      WorkoutSessionState(
        session: const ReadyWorkoutSession().start(startedAt).pause(startedAt.add(const Duration(seconds: 3))),
        elapsed: const Duration(seconds: 3),
      ),
      WorkoutSessionState(
        session: const ReadyWorkoutSession()
            .start(startedAt)
            .pause(startedAt.add(const Duration(seconds: 3)))
            .resume(startedAt.add(const Duration(seconds: 10))),
        elapsed: const Duration(seconds: 3),
      ),
      WorkoutSessionState(
        session: const ReadyWorkoutSession()
            .start(startedAt)
            .pause(startedAt.add(const Duration(seconds: 3)))
            .resume(startedAt.add(const Duration(seconds: 10))),
        elapsed: const Duration(seconds: 5),
      ),
    ],
  );

  blocTest<WorkoutSessionBloc, WorkoutSessionState>(
    'Given 진행 상태 When 종료하면 Then 종료 세션을 방출하고 이후 tick에도 변하지 않는다',
    build: buildBloc,
    act: (bloc) async {
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
      WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: Duration.zero),
      WorkoutSessionState(session: const ReadyWorkoutSession().start(startedAt), elapsed: const Duration(seconds: 30)),
      WorkoutSessionState(
        session: const ReadyWorkoutSession().start(startedAt).end(startedAt.add(const Duration(seconds: 30))),
        elapsed: const Duration(seconds: 30),
      ),
    ],
  );
}
