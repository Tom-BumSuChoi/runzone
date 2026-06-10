import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/weekly_frequency.dart';

void main() {
  test('Given 경계를 포함한 유효한 주간 빈도 When 생성하면 Then 해당 값을 가진다', () {
    for (final int count in [WeeklyFrequency.min, WeeklyFrequency.max]) {
      expect(WeeklyFrequency(count).count, count, reason: '$count times');
    }
  });

  test('Given 경계를 벗어난 주간 빈도 When 생성하면 Then 입력값 오류가 발생한다', () {
    for (final int count in [WeeklyFrequency.min - 1, WeeklyFrequency.max + 1]) {
      WeeklyFrequency create() => WeeklyFrequency(count);

      expect(create, throwsArgumentError, reason: '$count times');
    }
  });
}
