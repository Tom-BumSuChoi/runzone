import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/heart_rate_zone_calculator.dart';

void main() {
  test('Given 30세 사용자 When 최대심박을 계산하면 Then 187bpm을 반환한다', () {
    // Given
    const int age = 30;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    // When
    final maxHeartRate = calculator.maxHeartRate(age: age);

    // Then
    expect(maxHeartRate, 187);
  });

  test('Given 30세 사용자 When 심박존을 계산하면 Then Zone2는 112bpm부터 131bpm까지다', () {
    // Given
    const int age = 30;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    // When
    final HeartRateZone heartRateZone = calculator.getHeartRateZone(age: age);

    // Then
    expect(heartRateZone.zone2.lower, 112);
    expect(heartRateZone.zone2.upper, 131);
  });

  test('Given 30세 사용자 When 심박존을 계산하면 Then Z1부터 Z5까지 50퍼센트부터 100퍼센트까지 나뉜다', () {
    // Given
    const int age = 30;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    // When
    final HeartRateZone heartRateZone = calculator.getHeartRateZone(age: age);

    // Then (최대심박 187 기준, 50~100%)
    expect(heartRateZone.zone1.lower, 94);
    expect(heartRateZone.zone1.upper, 112);
    expect(heartRateZone.zone2.lower, 112);
    expect(heartRateZone.zone2.upper, 131);
    expect(heartRateZone.zone3.lower, 131);
    expect(heartRateZone.zone3.upper, 150);
    expect(heartRateZone.zone4.lower, 150);
    expect(heartRateZone.zone4.upper, 168);
    expect(heartRateZone.zone5.lower, 168);
    expect(heartRateZone.zone5.upper, 187);
  });

  test('Given 여러 나이 When 심박존을 계산하면 Then 각 존 경계는 빈틈없이 이어진다', () {
    // Given
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    for (final int age in [20, 30, 45, 60]) {
      // When
      final HeartRateZone heartRateZone = calculator.getHeartRateZone(age: age);

      // Then
      expect(
        heartRateZone.zone1.upper,
        heartRateZone.zone2.lower,
        reason: 'age $age',
      );
      expect(
        heartRateZone.zone2.upper,
        heartRateZone.zone3.lower,
        reason: 'age $age',
      );
      expect(
        heartRateZone.zone3.upper,
        heartRateZone.zone4.lower,
        reason: 'age $age',
      );
      expect(
        heartRateZone.zone4.upper,
        heartRateZone.zone5.lower,
        reason: 'age $age',
      );
      expect(
        heartRateZone.zone1.lower,
        lessThan(heartRateZone.zone1.upper),
        reason: 'age $age',
      );
      expect(
        heartRateZone.zone2.lower,
        lessThan(heartRateZone.zone2.upper),
        reason: 'age $age',
      );
      expect(
        heartRateZone.zone3.lower,
        lessThan(heartRateZone.zone3.upper),
        reason: 'age $age',
      );
      expect(
        heartRateZone.zone4.lower,
        lessThan(heartRateZone.zone4.upper),
        reason: 'age $age',
      );
      expect(
        heartRateZone.zone5.lower,
        lessThan(heartRateZone.zone5.upper),
        reason: 'age $age',
      );
    }
  });
}
