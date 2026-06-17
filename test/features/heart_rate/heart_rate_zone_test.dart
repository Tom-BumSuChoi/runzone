import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone.dart';

void main() {
  test('Given 심박존 When 증가하면 Then 다음 존으로 변경된다', () {
    expect(HeartRateZone.zone2.increase(), HeartRateZone.zone3);
  });

  test('Given 심박존 When 감소하면 Then 이전 존으로 변경된다', () {
    expect(HeartRateZone.zone2.decrease(), HeartRateZone.zone1);
  });

  test('Given 심박존이 Z1 When 감소하면 Then Z1을 유지한다', () {
    expect(HeartRateZone.zone1.decrease(), HeartRateZone.zone1);
  });

  test('Given 심박존이 Z5 When 증가하면 Then Z5를 유지한다', () {
    expect(HeartRateZone.zone5.increase(), HeartRateZone.zone5);
  });
}
