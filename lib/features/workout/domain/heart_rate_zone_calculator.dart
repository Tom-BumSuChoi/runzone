import 'package:runzone/features/workout/domain/heart_rate_zone.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_range.dart';

final class HeartRateZoneCalculator {
  const HeartRateZoneCalculator();

  static const int _minimumAge = 1;
  static const int _maximumAge = 120;

  int maxHeartRate({required int age}) {
    _validateAge(age);

    return (208 - 0.7 * age).round();
  }

  HeartRateZone getHeartRateZone({required int age}) {
    final int max = maxHeartRate(age: age);
    final int zone1Lower = (max * 0.5).round();
    final int zone2Lower = (max * 0.6).round();
    final int zone3Lower = (max * 0.7).round();
    final int zone4Lower = (max * 0.8).round();
    final int zone5Lower = (max * 0.9).round();

    final HeartRateZoneRange zone1 = HeartRateZoneRange(
      lower: zone1Lower,
      upper: zone2Lower - 1,
    );
    final HeartRateZoneRange zone2 = HeartRateZoneRange(
      lower: zone2Lower,
      upper: zone3Lower - 1,
    );
    final HeartRateZoneRange zone3 = HeartRateZoneRange(
      lower: zone3Lower,
      upper: zone4Lower - 1,
    );
    final HeartRateZoneRange zone4 = HeartRateZoneRange(
      lower: zone4Lower,
      upper: zone5Lower - 1,
    );
    final HeartRateZoneRange zone5 = HeartRateZoneRange(
      lower: zone5Lower,
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

  HeartRateZoneType getZoneType({required int age, required int heartRate}) {
    final HeartRateZone zone = getHeartRateZone(age: age);

    if (zone.zone5.contains(heartRate)) {
      return HeartRateZoneType.zone5;
    }
    if (zone.zone4.contains(heartRate)) {
      return HeartRateZoneType.zone4;
    }
    if (zone.zone3.contains(heartRate)) {
      return HeartRateZoneType.zone3;
    }
    if (zone.zone2.contains(heartRate)) {
      return HeartRateZoneType.zone2;
    }
    if (zone.zone1.contains(heartRate)) {
      return HeartRateZoneType.zone1;
    }

    throw ArgumentError.value(
      heartRate,
      'heartRate',
      'must be between ${zone.zone1.lower} and ${zone.zone5.upper}',
    );
  }

  void _validateAge(int age) {
    if (age < _minimumAge || age > _maximumAge) {
      throw ArgumentError.value(
        age,
        'age',
        'must be between $_minimumAge and $_maximumAge',
      );
    }
  }
}
