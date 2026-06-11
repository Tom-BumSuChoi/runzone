import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/profile/domain/weight.dart';

void main() {
  test('Given 경계를 포함한 유효한 체중 When 생성하면 Then 해당 값을 가진다', () {
    // 유효 범위 경계: 30~200kg
    for (final int kilograms in [30, 200]) {
      expect(Weight(kilograms).kilograms, kilograms, reason: '$kilograms kg');
    }
  });

  test('Given 경계를 벗어난 체중 When 생성하면 Then 입력값 오류가 발생한다', () {
    for (final int kilograms in [29, 201]) {
      Weight create() => Weight(kilograms);

      expect(create, throwsArgumentError, reason: '$kilograms kg');
    }
  });
}
