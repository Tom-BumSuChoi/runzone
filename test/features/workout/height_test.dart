import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/height.dart';

void main() {
  test('Given 경계를 포함한 유효한 키 When 생성하면 Then 해당 값을 가진다', () {
    for (final int centimeters in [Height.min, Height.max]) {
      expect(Height(centimeters).centimeters, centimeters, reason: '$centimeters cm');
    }
  });

  test('Given 경계를 벗어난 키 When 생성하면 Then 입력값 오류가 발생한다', () {
    for (final int centimeters in [Height.min - 1, Height.max + 1]) {
      Height create() => Height(centimeters);

      expect(create, throwsArgumentError, reason: '$centimeters cm');
    }
  });
}
