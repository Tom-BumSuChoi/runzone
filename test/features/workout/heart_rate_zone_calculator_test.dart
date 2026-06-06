import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/heart_rate_zone_calculator.dart';

void main() {
  test(
    'Given 나이 30 When HeartRateZoneCalculator에 넣으면 Then 최대 심박이 187이 나온다',
    () {
      // Given
      const int age = 30;
      const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

      // When
      final maxHeartRate = calculator.maxHeartRate(age: age);

      // Then
      expect(maxHeartRate, 187);
    },
  );
}