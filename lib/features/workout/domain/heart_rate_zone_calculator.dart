import 'package:runzone/features/workout/domain/heart_rate_zone.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_range.dart';

final class HeartRateZoneCalculator {
  const HeartRateZoneCalculator();

  int maxHeartRate({required int age}) {
    return (208 - 0.7 * age).round();
  }

  HeartRateZone getHeartRateZone({required int age}) {
    final int max = maxHeartRate(age: age);

    final HeartRateZoneRange zone1 = HeartRateZoneRange(
      lower: (max * 0.5).round(),
      upper: (max * 0.6).round(),
    );
    final HeartRateZoneRange zone2 = HeartRateZoneRange(
      lower: (max * 0.6).round(),
      upper: (max * 0.7).round(),
    );
    final HeartRateZoneRange zone3 = HeartRateZoneRange(
      lower: (max * 0.7).round(),
      upper: (max * 0.8).round(),
    );
    final HeartRateZoneRange zone4 = HeartRateZoneRange(
      lower: (max * 0.8).round(),
      upper: (max * 0.9).round(),
    );
    final HeartRateZoneRange zone5 = HeartRateZoneRange(
      lower: (max * 0.9).round(),
      upper: max,
    );

    return HeartRateZone(
      zone1: zone1,
      zone2: zone2,
      zone3: zone3,
      zone4: zone4,
      zone5: zone5,
    );
  }
}
