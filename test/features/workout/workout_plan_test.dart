import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/features/workout/domain/workout_plan.dart';

void main() {
  test('Given 초기 인터벌 계획 When 값을 확인하면 Then 기본 인터벌 구성을 가진다', () {
    expect(IntervalWorkoutPlan.initial.warmUpDuration, const Duration(minutes: 5));
    expect(IntervalWorkoutPlan.initial.highIntensityDistanceMeters, 400);
    expect(IntervalWorkoutPlan.initial.recoveryDuration, const Duration(seconds: 90));
    expect(IntervalWorkoutPlan.initial.repeatCount, 6);
  });

  test('Given 인터벌 계획 When 워밍업 시간을 증가하면 Then 1분 증가한다', () {
    final plan = IntervalWorkoutPlan.initial.increaseWarmUpDuration();

    expect(plan.warmUpDuration, const Duration(minutes: 6));
  });

  test('Given 인터벌 계획 When 고강도 거리를 증가하면 Then 100m 증가한다', () {
    final plan = IntervalWorkoutPlan.initial.increaseHighIntensityDistance();

    expect(plan.highIntensityDistanceMeters, 500);
  });

  test('Given 인터벌 계획 When 회복 시간을 증가하면 Then 15초 증가한다', () {
    final plan = IntervalWorkoutPlan.initial.increaseRecoveryDuration();

    expect(plan.recoveryDuration, const Duration(seconds: 105));
  });

  test('Given 인터벌 계획 When 반복 횟수를 증가하면 Then 1회 증가한다', () {
    final plan = IntervalWorkoutPlan.initial.increaseRepeatCount();

    expect(plan.repeatCount, 7);
  });
}
