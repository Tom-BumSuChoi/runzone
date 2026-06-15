import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/workout_session.dart';

void main() {
  test('Given 준비 상태 세션 When 시작하면 Then 진행 상태가 되고 경과 시간이 증가한다', () {
    // Given
    final DateTime startedAt = DateTime(2026, 6, 15, 7);
    const ReadyWorkoutSession session = ReadyWorkoutSession();

    // When
    final RunningWorkoutSession startedSession = session.start(startedAt);

    // Then
    expect(startedSession, isA<RunningWorkoutSession>());
    expect(startedSession.elapsedAt(startedAt.add(const Duration(seconds: 42))), const Duration(seconds: 42));
  });

  test('Given 진행 중인 세션 When 일시정지하면 Then 일시정지 상태가 되고 경과 시간이 멈춘다', () {
    // Given
    final DateTime startedAt = DateTime(2026, 6, 15, 7);
    final DateTime pausedAt = startedAt.add(const Duration(minutes: 3));
    final RunningWorkoutSession session = const ReadyWorkoutSession().start(startedAt);

    // When
    final PausedWorkoutSession pausedSession = session.pause(pausedAt);

    // Then
    expect(pausedSession, isA<PausedWorkoutSession>());
    expect(pausedSession.elapsedAt(pausedAt.add(const Duration(minutes: 10))), const Duration(minutes: 3));
  });

  test('Given 일시정지한 세션 When 재개하면 Then 멈춘 지점부터 경과 시간이 다시 증가한다', () {
    // Given
    final DateTime startedAt = DateTime(2026, 6, 15, 7);
    final DateTime pausedAt = startedAt.add(const Duration(minutes: 3));
    final DateTime resumedAt = pausedAt.add(const Duration(minutes: 2));
    final PausedWorkoutSession session = const ReadyWorkoutSession().start(startedAt).pause(pausedAt);

    // When
    final RunningWorkoutSession resumedSession = session.resume(resumedAt);

    // Then
    expect(resumedSession, isA<RunningWorkoutSession>());
    expect(resumedSession.elapsedAt(resumedAt.add(const Duration(minutes: 4))), const Duration(minutes: 7));
  });

  test('Given 진행 중인 세션 When 종료하면 Then 종료 상태가 되고 경과 시간이 고정된다', () {
    // Given
    final DateTime startedAt = DateTime(2026, 6, 15, 7);
    final DateTime endedAt = startedAt.add(const Duration(minutes: 30));
    final RunningWorkoutSession session = const ReadyWorkoutSession().start(startedAt);

    // When
    final EndedWorkoutSession endedSession = session.end(endedAt);

    // Then
    expect(endedSession, isA<EndedWorkoutSession>());
    expect(endedSession.elapsedAt(endedAt.add(const Duration(hours: 1))), const Duration(minutes: 30));
  });

  test('Given 종료된 세션 When 시간이 지나면 Then 종료 상태와 경과 시간이 유지된다', () {
    // Given
    final DateTime startedAt = DateTime(2026, 6, 15, 7);
    final DateTime endedAt = startedAt.add(const Duration(minutes: 30));
    final DateTime requestedAt = endedAt.add(const Duration(minutes: 10));
    final EndedWorkoutSession session = const ReadyWorkoutSession().start(startedAt).end(endedAt);

    // Then
    expect(session, isA<EndedWorkoutSession>());
    expect(session.elapsedAt(requestedAt), const Duration(minutes: 30));
  });

  test('Given 일시정지와 재개를 반복하면 Then 진행 시간만 누적된다', () {
    // Given
    final DateTime startedAt = DateTime(2026, 6, 15, 7);
    final DateTime firstPausedAt = startedAt.add(const Duration(minutes: 3));
    final DateTime firstResumedAt = firstPausedAt.add(const Duration(minutes: 7));
    final DateTime secondPausedAt = firstResumedAt.add(const Duration(minutes: 5));
    final DateTime secondResumedAt = secondPausedAt.add(const Duration(minutes: 5));
    final DateTime thirdPausedAt = secondResumedAt.add(const Duration(minutes: 2));

    // When
    final PausedWorkoutSession session = const ReadyWorkoutSession()
        .start(startedAt)
        .pause(firstPausedAt)
        .resume(firstResumedAt)
        .pause(secondPausedAt)
        .resume(secondResumedAt)
        .pause(thirdPausedAt);

    // Then
    expect(session, isA<PausedWorkoutSession>());
    expect(session.elapsedAt(thirdPausedAt.add(const Duration(minutes: 30))), const Duration(minutes: 10));
  });
}
