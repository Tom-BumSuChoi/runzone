import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/weekly_frequency.dart';

void main() {
  test('Given 경계를 포함한 유효한 주간 빈도 When 생성하면 Then 해당 값을 가진다', () {
    // 유효 범위 경계: 1~14회
    for (final int count in [1, 14]) {
      expect(WeeklyFrequency(count).count, count, reason: '$count times');
    }
  });

  test('Given 경계를 벗어난 주간 빈도 When 생성하면 Then 입력값 오류가 발생한다', () {
    for (final int count in [0, 15]) {
      WeeklyFrequency create() => WeeklyFrequency(count);

      expect(create, throwsArgumentError, reason: '$count times');
    }
  });
}
