import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone_calculator.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone_range.dart';

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

  test('Given 30세 사용자 When 심박존을 계산하면 Then Zone2는 112bpm부터 130bpm까지다', () {
    // Given
    const int age = 30;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    // When
    final HeartRateZoneTable heartRateZone = calculator.getHeartRateZone(age: age);

    // Then
    expect(heartRateZone.zone2, const HeartRateZoneRange(lower: 112, upper: 130));
  });

  test('Given 30세 사용자 When 심박존을 계산하면 Then Z1부터 Z5까지 50퍼센트부터 100퍼센트까지 나뉜다', () {
    // Given
    const int age = 30;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    // When
    final HeartRateZoneTable heartRateZone = calculator.getHeartRateZone(age: age);

    // Then (최대심박 187 기준, 50~100%)
    expect(
      heartRateZone,
      const HeartRateZoneTable(
        zone1: HeartRateZoneRange(lower: 94, upper: 111),
        zone2: HeartRateZoneRange(lower: 112, upper: 130),
        zone3: HeartRateZoneRange(lower: 131, upper: 149),
        zone4: HeartRateZoneRange(lower: 150, upper: 167),
        zone5: HeartRateZoneRange(lower: 168, upper: 187),
      ),
    );
  });

  test('Given 여러 나이 When 심박존을 계산하면 Then 각 존 경계는 빈틈없이 이어진다', () {
    // Given
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    for (final int age in [20, 30, 45, 60]) {
      // When
      final HeartRateZoneTable heartRateZone = calculator.getHeartRateZone(age: age);

      // Then
      expect(heartRateZone.zone1.upper + 1, heartRateZone.zone2.lower, reason: 'age $age');
      expect(heartRateZone.zone2.upper + 1, heartRateZone.zone3.lower, reason: 'age $age');
      expect(heartRateZone.zone3.upper + 1, heartRateZone.zone4.lower, reason: 'age $age');
      expect(heartRateZone.zone4.upper + 1, heartRateZone.zone5.lower, reason: 'age $age');
      expect(heartRateZone.zone1.lower, lessThan(heartRateZone.zone1.upper), reason: 'age $age');
      expect(heartRateZone.zone2.lower, lessThan(heartRateZone.zone2.upper), reason: 'age $age');
      expect(heartRateZone.zone3.lower, lessThan(heartRateZone.zone3.upper), reason: 'age $age');
      expect(heartRateZone.zone4.lower, lessThan(heartRateZone.zone4.upper), reason: 'age $age');
      expect(heartRateZone.zone5.lower, lessThan(heartRateZone.zone5.upper), reason: 'age $age');
    }
  });

  test('Given 유효하지 않은 나이 When 최대심박을 계산하면 Then 입력값 오류가 발생한다', () {
    // Given
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    for (final int age in [0, -1, 121]) {
      // When
      int calculate() => calculator.maxHeartRate(age: age);

      // Then
      expect(calculate, throwsArgumentError, reason: 'age $age');
    }
  });

  test('Given 유효하지 않은 나이 When 심박존을 계산하면 Then 입력값 오류가 발생한다', () {
    // Given
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    for (final int age in [0, -1, 121]) {
      // When
      HeartRateZoneTable calculate() => calculator.getHeartRateZone(age: age);

      // Then
      expect(calculate, throwsArgumentError, reason: 'age $age');
    }
  });

  test('Given 30세 사용자와 125bpm When 현재 심박존을 판별하면 Then Zone2를 반환한다', () {
    // Given
    const int age = 30;
    const int heartRate = 125;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    // When
    final HeartRateZone zoneType = calculator.getZoneType(age: age, heartRate: heartRate);

    // Then
    expect(zoneType, HeartRateZone.zone2);
  });

  test('Given 계산된 심박존과 125bpm When 심박존 객체에 현재 심박존 판별을 요청하면 Then Zone2를 반환한다', () {
    // Given
    const int age = 30;
    const int heartRate = 125;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();
    final HeartRateZoneTable heartRateZone = calculator.getHeartRateZone(age: age);

    // When
    final HeartRateZone zoneType = heartRateZone.getZoneType(heartRate);

    // Then
    expect(zoneType, HeartRateZone.zone2);
  });

  test('Given 30세 사용자와 187bpm When 현재 심박존을 판별하면 Then Zone5를 반환한다', () {
    // Given
    const int age = 30;
    const int heartRate = 187;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    // When
    final HeartRateZone zoneType = calculator.getZoneType(age: age, heartRate: heartRate);

    // Then
    expect(zoneType, HeartRateZone.zone5);
  });

  test('Given 30세 사용자와 Zone1 하한 미만 심박 When 현재 심박존을 판별하면 Then Zone1을 반환한다', () {
    // Given
    const int age = 30;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    for (final int heartRate in [60, 80, 93]) {
      // When
      HeartRateZone calculate() => calculator.getZoneType(age: age, heartRate: heartRate);

      // Then
      expect(calculate(), HeartRateZone.zone1, reason: 'heartRate $heartRate');
    }
  });

  test('Given 30세 사용자와 0 이하 심박 When 현재 심박존을 판별하면 Then 입력값 오류가 발생한다', () {
    // Given
    const int age = 30;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    for (final int heartRate in [0, -1]) {
      // When
      HeartRateZone calculate() => calculator.getZoneType(age: age, heartRate: heartRate);

      // Then
      expect(calculate, throwsArgumentError, reason: 'heartRate $heartRate');
    }
  });

  test('Given 30세 사용자와 계산된 최대심박 초과 심박 When 현재 심박존을 판별하면 Then Zone5를 반환한다', () {
    // Given
    const int age = 30;
    const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

    for (final int heartRate in [188, 200]) {
      // When
      HeartRateZone calculate() => calculator.getZoneType(age: age, heartRate: heartRate);

      // Then
      expect(calculate(), HeartRateZone.zone5, reason: 'heartRate $heartRate');
    }
  });
}
