import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/weight.dart';

void main() {
  test('Given 경계를 포함한 유효한 체중 When 생성하면 Then 해당 값을 가진다', () {
    for (final int kilograms in [Weight.min, Weight.max]) {
      expect(Weight(kilograms).kilograms, kilograms, reason: '$kilograms kg');
    }
  });

  test('Given 경계를 벗어난 체중 When 생성하면 Then 입력값 오류가 발생한다', () {
    for (final int kilograms in [Weight.min - 1, Weight.max + 1]) {
      Weight create() => Weight(kilograms);

      expect(create, throwsArgumentError, reason: '$kilograms kg');
    }
  });
}
