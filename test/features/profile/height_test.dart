import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/profile/domain/height.dart';

void main() {
  test('Given 경계를 포함한 유효한 키 When 생성하면 Then 해당 값을 가진다', () {
    // 유효 범위 경계: 100~250cm
    for (final int centimeters in [100, 250]) {
      expect(Height(centimeters).centimeters, centimeters, reason: '$centimeters cm');
    }
  });

  test('Given 경계를 벗어난 키 When 생성하면 Then 입력값 오류가 발생한다', () {
    for (final int centimeters in [99, 251]) {
      Height create() => Height(centimeters);

      expect(create, throwsArgumentError, reason: '$centimeters cm');
    }
  });
}
