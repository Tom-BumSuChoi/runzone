import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/workout_duration_goal.dart';

void main() {
  test('Given 기본 운동 시간 목표 When 값을 확인하면 Then 40분이다', () {
    expect(WorkoutDurationGoal.initial().minutes, 40);
  });

  test('Given 운동 시간 목표 When 증가하면 Then 5분 증가한다', () {
    const goal = WorkoutDurationGoal(minutes: 40);

    expect(goal.increase(), const WorkoutDurationGoal(minutes: 45));
  });

  test('Given 운동 시간 목표 When 감소하면 Then 5분 감소한다', () {
    const goal = WorkoutDurationGoal(minutes: 40);

    expect(goal.decrease(), const WorkoutDurationGoal(minutes: 35));
  });

  test('Given 운동 시간 목표가 5분 When 감소하면 Then 5분을 유지한다', () {
    const goal = WorkoutDurationGoal(minutes: 5);

    expect(goal.decrease(), const WorkoutDurationGoal(minutes: 5));
  });

  test('Given 운동 시간 목표가 995분 When 증가하면 Then 995분을 유지한다', () {
    const goal = WorkoutDurationGoal(minutes: 995);

    expect(goal.increase(), const WorkoutDurationGoal(minutes: 995));
  });
}
